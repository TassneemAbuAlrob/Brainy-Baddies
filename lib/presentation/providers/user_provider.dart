import 'package:flutter/material.dart';
import 'package:log/data/services/user_services.dart';

import '../../data/models/user.dart';

enum UserProviderErrorType{
  none,
  errorGettingUsers
}

class UserProvider extends ChangeNotifier{
    bool errorState = false;
  String errorMessage = "";
  UserProviderErrorType errorType = UserProviderErrorType.none;

  List<User> users = [];
  List<User> originals = [];

  clear(){
    errorState = false;
    errorMessage = "";
    errorType = UserProviderErrorType.none;
  }

  filterUsers(String query){
    users = originals.where((user){
      return 
        user.name.toLowerCase().contains(query.toLowerCase()) 
        || user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();

    notifyListeners();
  }

  Future getAllUsers() async{
    try{
      List <User> _users = await UserServices.getAllUsers();
      users = _users;
      originals = _users;
      
      clear();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
      errorType = UserProviderErrorType.errorGettingUsers;
    }

    notifyListeners();
  }
}