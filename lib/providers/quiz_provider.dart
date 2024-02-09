import 'package:alaa_admin/models/quiz.dart';
import 'package:alaa_admin/services/quiz_service.dart';
import 'package:flutter/material.dart';

class QuizProvider extends ChangeNotifier{
  List<Quiz> quizzes = [];

  bool loading = false;

  bool errorState = false;
  String errorMessage = "";

  clearErrors(){
    errorMessage = "";
    errorState = false;
  }

  changeLoadingState(bool newState){
    loading = newState;
    notifyListeners();
  }

  Future getAllQuizzes() async{
    try{
      changeLoadingState(true);
      quizzes = await QuizService.getAllQuizzes();
      print(quizzes);
      clearErrors();
      changeLoadingState(false);
    }catch(e){
      loading = false;
      errorState = true;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}