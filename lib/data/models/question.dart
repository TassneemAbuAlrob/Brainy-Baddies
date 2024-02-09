import 'package:log/data/models/answer.dart';

class Question{
  final String title;
  final int correctAnswerIndex;
  final List<Answer> answers;

  Question({required this.title, required this.correctAnswerIndex, required this.answers});

  factory Question.fromJson(Map data){
    return Question(
      title: data['title'], 
      correctAnswerIndex: data['correct_answer_index'], 
      answers: (data['answers'] as List<dynamic>).map((e){
        return Answer.fromJson(e);
      }).toList(),
    );
  }
}