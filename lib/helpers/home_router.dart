import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/screens/control_panel_home.dart';
import 'package:alaa_admin/screens/home_screen.dart';
import 'package:flutter/material.dart';


class HomeRouter{
  static Route<dynamic> generatedRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (context) => HomeScreen());


      default:
        return MaterialPageRoute(builder: (context) => Container(color: AppColors.dangerColor,));
    }
  }
}