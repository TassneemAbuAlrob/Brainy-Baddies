import 'dart:convert';

import 'package:log/core/constants/app_contants.dart';
import 'package:log/data/models/video.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/video_data.dart';

class VideoService {
  static Future<List<Video>> getAllVideos() async {
    try {
      final uri = Uri.parse('$baseUrl/videos/admin');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List decoded = jsonDecode(response.body);
        List<Video> videos = decoded.map((e) {
          return Video.fromJson(e);
        }).toList();

        return videos;
      } else {
        throw response.body;
      }
    } catch (error) {
      rethrow;
    }
  }

  // static Future<List<Video>> getAllCurrentUserVideos() async{
  //   try{
  //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //     String? userId = sharedPreferences.getString('id');
  //     final uri = Uri.parse('$baseUrl/videos/user/$userId');
  //     final response = await http.get(uri);

  //     if(response.statusCode == 200){
  //       List decoded = jsonDecode(response.body);
  //       List<Video> videos = decoded.map((e){
  //         return Video.fromJson(e);
  //       }).toList();

  //       return videos;
  //     }else{
  //       throw response.body;
  //     }
  //   }catch(error){
  //     rethrow;
  //   }
  // }
  static Future<List<Video>> getAllCurrentUserVideos(
      String targetUserId) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? currentUserId = sharedPreferences.getString('id');

      if (currentUserId == null) {
        print("Error: Current user ID is null.");
        return [];
      }

      final uri = Uri.parse('$baseUrl/videos/user/$targetUserId');
      print('URL: $uri'); // Log the URL for debugging purposes.

      final response = await http.get(uri);
      print('Status Code: ${response.statusCode}'); // Log the status code.

      if (response.statusCode == 200) {
        List decoded = jsonDecode(response.body);
        List<Video> videos = decoded.map((e) {
          return Video.fromJson(e);
        }).toList();

        return videos;
      } else {
        print(
            'Error Response Body: ${response.body}'); // Log the error response body.
        throw 'Failed to get videos. Status Code: ${response.statusCode}';
      }
    } catch (error) {
      print(
          'Error in getAllCurrentUserVideos: $error'); // Log the general error.
      rethrow; // Rethrow the error for further handling.
    }
  }

  static Future createVideo(VideoData videoData, String userId) async {
    try {
      final uri = Uri.parse('http://10.0.2.2:4000/api/videos');
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(videoData.toJson());

      request.fields.addAll({'publisher': userId});

      request.files
          .add(await http.MultipartFile.fromPath('video', videoData.video));
      request.files
          .add(await http.MultipartFile.fromPath('image', videoData.poster));

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

  //comment
  static Future<void> commentOnVideo(
      String id, String userId, String comment) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/videos/$id/comment'),
        body: {
          'userId': userId,
          'text': comment,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Comment added successfully: ${responseData['message']}');
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Error: ${responseData['error']}');
      } else if (response.statusCode == 404) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Error: ${responseData['message']}');
      } else {
        print('Failed to add comment. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error commenting on video: $error');
    }
  }
}
