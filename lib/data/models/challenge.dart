import 'package:log/data/models/question.dart';

class Challenge{
  final String name; 
  final String category;
  final List<Question> questions;

  Challenge({required this.name, required this.category, required this.questions});

  factory Challenge.fromJson(Map data){
    return Challenge(
      name: data['name'],
      category: data['category'],
      questions: (data['questions'] as List<dynamic>).map((e){
        return Question.fromJson(e);
      }).toList()
    );
  }
}