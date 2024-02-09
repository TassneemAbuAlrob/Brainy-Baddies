import 'package:alaa_admin/models/answer.dart';

class Question{
  final String title;
  final List<Answer> answers;
  final int correctAnswerIndex;

  Question({
    required this.title, 
    required this.answers,
    required this.correctAnswerIndex
  });

  factory Question.fromJson(Map json){
    List decoded = json['answers'];
    List<Answer> answers = decoded.map((a){
      return Answer.fromJson(a);
    }).toList();


    return Question(
      title: json["title"], 
      answers: answers,
      correctAnswerIndex: json["correct_answer_index"],
    );
  }

  Map toJson(){
    final encAnswers = answers.map((e){
      return e.toJson();
    }).toList();
    return {
      'title': title,
      'answers': encAnswers,
      'correct_answer_index': correctAnswerIndex
    };
  }
}