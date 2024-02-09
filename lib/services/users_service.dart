import 'dart:convert';

import 'package:alaa_admin/models/user.dart';
import 'package:http/http.dart' as http;

class UserService{
  static Future<List<User>> getAllUsers() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/users');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<User> users = decoded.map((e){
          return User.fromJson(e);
        }).toList();

        return users;
      }else{
        throw response.body;
      }
    }catch(error){
      throw error.toString();
    }
  }

    static Future<int> getUsersCount() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/users/count');
      final response = await http.get(uri);
      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){
        return int.parse(response.body);
        
      }else{
        throw response.body;
      }
    }catch(e){
      rethrow;
    }
  }
    static Future<int> deleteUser(String userId) async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/users/$userId');
      final response = await http.delete(uri);
      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){
        return 0;
        
      }else{
        throw response.body;
      }
    }catch(e){
      rethrow;
    }
  }
}