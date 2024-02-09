import 'package:alaa_admin/models/age.dart';
import 'package:alaa_admin/services/age_service.dart';
import 'package:flutter/material.dart';

class AgeProvider extends ChangeNotifier {
  List<Age> ages = [];

  bool errorState = false;
  String errorMessage = "";

  clear(){
    errorState = false;
    errorMessage = "";
  }

  Future fetchAges() async{
    try{
      ages = await AgeService.getAllAges();
      clear();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }

    notifyListeners();
  }

  Future createAge(Age age) async{
    try{
      await AgeService.createAge(age);
      ages.add(age);
      clear();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }

    notifyListeners();
  }
}