import 'dart:convert';

import 'package:alaa_admin/models/age.dart';
import 'package:alaa_admin/models/category.dart';
import 'package:http/http.dart' as http;

class AgeService{
  static Future<List<Age>> getAllAges() async{
    try{
        final uri = Uri.parse('http://10.0.2.2:4000/api/ages');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<Age> agesList = decoded.map((e){
          return Age.fromJson(e);
        }).toList();

        return agesList;
      }else{
        throw response.body;
      }
    }catch(error){
      rethrow;
    }
  }

    static Future<int> getAgesCount() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/ages/count');
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

  static Future<void> createAge(Age age) async{
    try{
        final uri = Uri.parse('http://10.0.2.2:4000/api/ages');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(age.toJson())
      );

      if(response.statusCode == 200){
        return;
      }else{
        throw response.body;
      }
    }catch(error){
      rethrow;
    }
  }
}