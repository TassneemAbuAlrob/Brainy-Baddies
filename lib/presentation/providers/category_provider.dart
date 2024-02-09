import 'package:flutter/material.dart';
import 'package:log/data/models/video.dart';
import 'package:log/data/services/category_service.dart';
import 'package:log/data/services/video_service.dart';

import '../../data/models/category.dart';


enum CategoryProviderErrorType{
  none,
  errorGettingCategories
}

class CategoryProvider extends ChangeNotifier{
  bool errorState = false;
  String errorMessage = "";
  CategoryProviderErrorType errorType = CategoryProviderErrorType.none;

  bool loading = false;

  List<Category> categories = [];
  int? selectedCategoryIndex;

  changeSelectedCategoryIndex(int index){
    selectedCategoryIndex = index;
    notifyListeners();
  }

  changeLoadingState(bool state){
    loading = state;
    notifyListeners();
  }

  clear(){
    errorState = false;
    errorMessage = "";
    errorType = CategoryProviderErrorType.none;
  }

  Future getAllCategories() async{
    try{
      changeLoadingState(true);
      categories = await CategoryService.getAllCategories();
      clear();
      changeLoadingState(false);
    }catch(error){
      errorState = true;
      errorMessage = error.toString();
      errorType = CategoryProviderErrorType.errorGettingCategories;
    }

    notifyListeners();
  }
}