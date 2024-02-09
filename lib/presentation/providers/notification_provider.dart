import 'package:flutter/material.dart';
import 'package:log/data/models/notification_model.dart';
import 'package:log/data/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier{
  List<NotificationModel> notifications = [];

  bool errorState = false;
  String errorMessage = "";

  clear(){
    errorState = false;
    errorMessage = "";
    notifyListeners();
  }

  getAllNotifications() async{
    try{
      notifications = await NotificationService.getAllNotifications();
      clear();
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}