import 'package:alaa_admin/models/question.dart';
import 'package:alaa_admin/models/quiz.dart';
import 'package:alaa_admin/services/quiz_service.dart';
import 'package:flutter/material.dart';

class QuestionBox{
  final TextEditingController title;
  final TextEditingController description;
  final List<TextEditingController> answers;
  final TextEditingController correctAnswerIndex;

  QuestionBox({required this.title, required this.description, required this.answers, required this.correctAnswerIndex});

}

class CreateQuizProvider extends ChangeNotifier{
  List<Question> questions = [];
  List<QuestionBox> boxes = [];

  String name = '';
  String category = '';
  String? image;

  bool errorState = false;
  bool loadingState = false;

  String errorMessage = '';

  void changeLoadingState(bool newState) {
    loadingState = newState;
    notifyListeners();
  }

  clear(){
    name = '';
    category = '';
    image = null;
    questions.clear();

    errorMessage = '';
    errorState = false;
    loadingState = false;
  }

  insertQuestion(Question question){
    questions.add(question);
    notifyListeners();
  }

  updateName(String newName){
    name = newName;
  }

  updateCategory(String newCategory){
    category = newCategory;
  }

  updateImage(String newImage){
    image = newImage;
  }

  generateQuestionsBoxes(int total){
    boxes = List.generate(total, (index){
      return QuestionBox(
        title: TextEditingController(), 
        description: TextEditingController(), 
        answers: [TextEditingController(),TextEditingController(),TextEditingController()], 
        correctAnswerIndex: TextEditingController()
      );
    });

    notifyListeners();
  }

  createQuiz() async{
    try{
      changeLoadingState(true);
      Quiz newQuiz = Quiz(
        name: name,
        category: category,
        image: image,
        questions: questions
      );

      await QuizService.createQuiz(newQuiz);
      
      clear();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }

    notifyListeners();
  }
}