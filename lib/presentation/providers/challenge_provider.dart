import 'package:flutter/material.dart';
import 'package:log/data/models/challenge.dart';
import 'package:log/data/services/challenge_service.dart';

enum ChallengeProviderErrorType {
  none,
  errorGettingChallenges
}

class ChallengePorvider extends ChangeNotifier{
  bool errorState = false;
  String errorMessage = "";
  ChallengeProviderErrorType errorType = ChallengeProviderErrorType.none;

  List<Challenge> challenges = [];
  List<Challenge> originals = [];

  Future getAllChallenges() async{
    try{
      challenges = await ChallengeService.getAllChallenges();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
      errorType = ChallengeProviderErrorType.errorGettingChallenges;
    }

    notifyListeners();
  }
}