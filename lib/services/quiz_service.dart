import 'dart:convert';

import 'package:alaa_admin/models/question.dart';
import 'package:http/http.dart' as http;

import '../models/quiz.dart';

class QuizService{
  static Future<List<Quiz>> getAllQuizzes() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/quizzes');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<Quiz> quizzes = decoded.map((e){
          return Quiz.fromJson(e);
        }).toList();
        print(quizzes);

        return quizzes;
        
      }else{
        throw response.body;
      }
    }catch(e){
      rethrow;
    }
  }

  static Future<int> getQuizzesCount() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/quizzes/count');
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

  static Future<void> createQuiz(Quiz quiz) async{
    print(quiz.toJson());
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/quizzes');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(quiz.toJson())
      );
    }catch(e){
      rethrow;
    }
  }
}