import 'dart:convert';

import 'package:log/core/constants/app_contants.dart';
import 'package:log/data/models/challenge.dart';
import 'package:http/http.dart' as http;

class ChallengeService{
  static Future<List<Challenge>> getAllChallenges() async{
    try{
      final uri = Uri.parse('$baseUrl/quizzes');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<Challenge> challenges = decoded.map((e){
          return Challenge.fromJson(e);
        }).toList();

        return challenges;
      }else{
        throw response.body;
      }
    }catch(error){
      rethrow;
    }
  }
}