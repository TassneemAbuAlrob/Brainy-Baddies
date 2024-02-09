import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log/core/constants/app_contants.dart';
import 'package:http/http.dart' as http;
import 'package:log/data/models/post.dart';

class PostService {
  static Future createPost(
      {required String textContent,
      XFile? file,
      PlatformFile? video,
      required String type,
      required String token}) async {
    try {
      final uri = Uri.parse('$baseUrl/posts');
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll({
        'textContent': textContent,
      });

      request.headers.addAll({'token': token});

      if (file != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', file.path));
      }

      if (video != null) {
        request.files
            .add(await http.MultipartFile.fromPath('video', video.path!));
      }

      final response = await request.send();

      print(response.statusCode);

      if (response.statusCode == 200) {
        Map decoded = jsonDecode(await response.stream.bytesToString());
        print(decoded);
        Post post = Post.fromJson(decoded);

        return post;
      } else {
        throw await response.stream.bytesToString();
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<Post>> getCurrentUserPosts(String id) async {
    try {
      final uri = Uri.parse('$baseUrl/posts/user/$id');
      final response = await http.get(uri);
      print(response.statusCode);
      if (response.statusCode == 200) {
        List decoded = jsonDecode(response.body);
        print(decoded);
        List<Post> posts = decoded.map((e) {
          return Post.fromJson(e);
        }).toList();

        return posts;
      } else {
        throw response.body;
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> likePost(String id, String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/posts/$id/like');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'userId': userId}));

      if (response.statusCode == 200) {
        return;
      } else {
        throw response.body;
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> commentOnPost(
      String id, String userId, String comment) async {
    try {
      final uri = Uri.parse('$baseUrl/posts/$id/comment');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'userId': userId,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        dynamic responseBody;
        try {
          // Try parsing the response as JSON
          responseBody = json.decode(response.body);
        } catch (e) {
          // If parsing as JSON fails, treat it as a string
          responseBody = response.body;
        }

        // Now responseBody can be either a Map or a String
        print('Comment response: $responseBody');
      } else {
        throw 'Failed to comment on post. Server responded with status code ${response.statusCode}.';
      }
    } catch (error) {
      print("Error during commentOnPost: $error");
      rethrow;
    }
  }

  static Future<bool> deletePost(String postId) async {
    try {
      final uri = Uri.parse('$baseUrl/deletePost/$postId');
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        print('Post deleted successfully');
        return true;
      } else if (response.statusCode == 404) {
        print('Post not found for deletion');
        return false;
      } else {
        throw response.body;
      }
    } catch (error) {
      print('Error deleting the post: $error');
      return false;
    }
  }

  static Future<List<Post>> getAllPosts(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/allposts/$userId'); // Adjust the URI
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List decoded = jsonDecode(response.body);
        List<Post> posts = decoded.map((e) {
          return Post.fromJson(e);
        }).toList();

        return posts;
      } else {
        throw response.body;
      }
    } catch (error) {
      rethrow;
    }
  }
}
