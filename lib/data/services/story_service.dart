import 'dart:convert';

import 'package:log/core/constants/app_contants.dart';
import 'package:log/data/models/story.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/story_data.dart';

class StoryService {
  static Future<List<Story>> getAllStories() async {
    try {
      final uri = Uri.parse('$baseUrl/stories/admin');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List decoded = jsonDecode(response.body);
        List<Story> stories = decoded.map((e) {
          return Story.fromJson(e);
        }).toList();

        return stories;
      } else {
        throw response.body;
      }
    } catch (error) {
      rethrow;
    }
  }

  // static Future<List<Story>> getCurrentUserAllStories() async {
  //   try {
  //     SharedPreferences sharedPreferences =
  //         await SharedPreferences.getInstance();
  //     String? userId = sharedPreferences.getString('id');
  //     final uri = Uri.parse('$baseUrl/stories/user/$userId');
  //     final response = await http.get(uri);

  //     if (response.statusCode == 200) {
  //       List decoded = jsonDecode(response.body);
  //       List<Story> stories = decoded.map((e) {
  //         return Story.fromJson(e);
  //       }).toList();

  //       return stories;
  //     } else {
  //       throw response.body;
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  static Future<List<Story>> getCurrentUserAllStories(String userId) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? currentUserId = sharedPreferences.getString('id');

      if (currentUserId == null) {
        print("Error: Current user ID is null.");
        return [];
      }

      final uri = Uri.parse('$baseUrl/stories/user/$userId');
      print('URL: $uri'); // Log the URL for debugging purposes.

      final response = await http.get(uri);
      print('Status Code: ${response.statusCode}'); // Log the status code.

      if (response.statusCode == 200) {
        List decoded = jsonDecode(response.body);
        List<Story> stories = decoded.map((e) {
          return Story.fromJson(e);
        }).toList();

        return stories;
      } else {
        print(
            'Error Response Body: ${response.body}'); // Log the error response body.
        throw 'Failed to get stories. Status Code: ${response.statusCode}';
      }
    } catch (error) {
      print(
          'Error in getCurrentUserAllStories: $error'); // Log the general error.
      rethrow; // Rethrow the error for further handling.
    }
  }

  static Future createStory(StoryData storyData) async {
    try {
      final uri = Uri.parse('http://10.0.2.2:4000/api/stories');
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(storyData.toJson());
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString('id');

      request.fields.addAll({'publisher': userId.toString()});

      request.files
          .add(await http.MultipartFile.fromPath('image', storyData.image));
      request.files
          .add(await http.MultipartFile.fromPath('file', storyData.pdf));

      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle success response if needed
        print('Data and files/images uploaded successfully');
      } else {
        throw await response.stream.bytesToString();
      }
    } catch (error) {
      throw error.toString();
    }
  }
}
