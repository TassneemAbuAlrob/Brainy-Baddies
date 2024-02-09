import 'package:alaa_admin/data%20classes/video_data.dart';
import 'package:http/http.dart' as http;

class VideoService{
  static Future createVideo(VideoData videoData, String? image) async{
    try{
      if(image == null){
        return;
      }
      final uri = Uri.parse('http://10.0.2.2:4000/api/videos');
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(
          videoData.toJson()
      );

      request.fields.addAll({
        'publisher': 'admin'
      });

      request.files.add(await http.MultipartFile.fromPath('image', image.toString()));
      request.files.add(await http.MultipartFile.fromPath('video', videoData.video));

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

    static Future<int> getVideosCount() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/videos/count');
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

  static Future deleteVideo(String id) async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/videos/$id');
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

  static Future updateVideo(VideoData videoData) async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/stories/${videoData.id}');
      var request = http.MultipartRequest('PUT', uri);

      request.fields.addAll(
          videoData.toJson() as Map<String,String>
      );

      request.files.add(await http.MultipartFile.fromPath('image', videoData.video));

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