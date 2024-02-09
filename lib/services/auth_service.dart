import 'dart:convert';

import 'package:alaa_admin/models/auth_credentials.dart';
import 'package:http/http.dart' as http;

class AuthService{
  static Future login(AuthCredentials credentials) async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/managers/login');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(credentials.toJson())
      );

      if(response.statusCode == 200){
        return;
      }else{
        throw response.body;
      }
    }catch(error){
      throw error.toString();
    }
  }
}