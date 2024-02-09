import 'package:alaa_admin/services/age_service.dart';
import 'package:alaa_admin/services/category_service.dart';
import 'package:alaa_admin/services/quiz_service.dart';
import 'package:alaa_admin/services/story_service.dart';
import 'package:alaa_admin/services/users_service.dart';
import 'package:flutter/material.dart';

import '../services/video_service.dart';

class HomeProvider extends ChangeNotifier{
  int usersCount = 0;
  int storiesCount = 0;
  int videosCount = 0;
  int quizzesCount = 0;
  int categoriesCount = 0;
  int agesCount = 0;

  Future initializeCounts() async{
    usersCount = await UserService.getUsersCount();
    storiesCount = await StoryService.getStoriesCount();
    videosCount = await VideoService.getVideosCount();
    quizzesCount = await QuizService.getQuizzesCount();
    categoriesCount = await CategoryService.getCategoriesCount();
    agesCount = await AgeService.getAgesCount();

    notifyListeners();
  }
}