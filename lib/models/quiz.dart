import 'dart:convert';

import 'package:alaa_admin/models/question.dart';

class Quiz{
  final String name;
  final String category;
  final String? image;
  final List<Question> questions;

  Quiz({required this.name, required this.category, required this.image, required this.questions});


  factory Quiz.fromJson(Map json){
    List decoded = json['questions'];
        print(decoded);

    List<Question> questions = decoded.map((d){
      return Question.fromJson(d);
    }).toList();
    return Quiz(
      name: json['name'], 
      category: json['category'], 
      image: json['image'], 
      questions: questions
    );
  }

  Map<String, dynamic> toJson() {
    List encQuestions = questions.map((e){
      return e.toJson();
    }).toList();
    Map<String, dynamic> json = {
      'name' : name,
      'category' : category,
      'questions': encQuestions
    };
    if(image != null){
      json.addAll({
        'image' : image!
      });
    }

    return json;
  }
}