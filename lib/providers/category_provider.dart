import 'package:alaa_admin/models/category.dart';
import 'package:alaa_admin/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier{
  List<Category> categories = [];

  bool errorState = false;
  String errorMessage = "";

  clear(){
    errorState = false;
    errorMessage = "";
  }

  Future fetchCategories() async{
    try{
      categories = await CategoryService.getAllCategories();
      clear();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }

    notifyListeners();
  }

  Future createCategory(Category category) async{
    try{
      await CategoryService.createCategory(category);
      categories.add(category);
      clear();
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
    }

    notifyListeners();
  }
}