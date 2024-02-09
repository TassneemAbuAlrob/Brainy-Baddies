import 'package:flutter/material.dart' show ChangeNotifier;

class AddChildProvider extends ChangeNotifier{
  double religiousInterest = 0;
  double scientificInterest = 0;
  double cultuealInterest = 0;

  changeReligiousInterest(double value){
    religiousInterest = value;
    notifyListeners();
  }

  changeScientificInterest(double value){
    scientificInterest = value;
    notifyListeners();
  }

  changeCultuealInterest(double value){
    cultuealInterest = value;
    notifyListeners();
  }
}