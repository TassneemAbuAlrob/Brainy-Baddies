import 'dart:convert';

import 'package:alaa_admin/data%20classes/story_data.dart';
import 'package:alaa_admin/models/story.dart';
import 'package:http/http.dart' as http;

class StoryService{
  static Future createStory(StoryData storyData) async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/stories');
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(
          storyData.toJson()
      );

      request.fields.addAll({
        'publisher': 'admin'
      });
      
      request.files.add(await http.MultipartFile.fromPath('image', storyData.image));
      request.files.add(await http.MultipartFile.fromPath('file', storyData.pdf));

      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle success response if needed
        print('Data and files/images uploaded successfully');
      } else {
        throw await response.stream.bytesToString();
      }
    }catch(error){
      throw error.toString();
    }
  }


  static Future<int> getStoriesCount() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/stories/count');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        return int.parse(response.body);
        
      }else{
        throw response.body;
      }
    }catch(e){
      rethrow;
    }
  }

  static Future<List<Story>> getAllStories() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/stories');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Handle success response if needed
        print('Data and files/images uploaded successfully');
        List decoded = jsonDecode(response.body);
        return decoded.map((e){
          return Story.fromJson(e);
        }).toList();
      } else {
        throw response.body;
      }
    }catch(error){
      throw error.toString();
    }
  }

  static Future deleteStory(String id) async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/stories/$id');
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        // Handle success response if needed
        print('Data and files/images uploaded successfully');
      } else {
        throw response.body;
      }
    }catch(error){
      throw error.toString();
    }
  }

  static Future deleteAllStories() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/stories');
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        // Handle success response if needed
        print('Data and files/images uploaded successfully');
        List decoded = jsonDecode(response.body);
        return decoded.map((e){
          return Story.fromJson(e);
        }).toList();
      } else {
        throw response.body;
      }
    }catch(error){
      throw error.toString();
    }
  }


  static Future updateStory(StoryData storyData) async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/stories/${storyData.id}');
      var request = http.MultipartRequest('PUT', uri);

      request.fields.addAll(
          storyData.toJson() as Map<String,String>
      );

      request.files.add(await http.MultipartFile.fromPath('image', storyData.image));

      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle success response if needed
        print('Data and files/images uploaded successfully');
      } else {
        throw await response.stream.bytesToString();
      }
    }catch(error){
      throw error.toString();
    }
  }

}