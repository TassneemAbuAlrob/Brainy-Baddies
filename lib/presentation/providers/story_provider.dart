import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:log/data/models/category.dart';
import 'package:log/data/models/story.dart';
import 'package:log/data/services/story_service.dart';

enum StoryProviderErrorType { none, errorGettingStories }

class StoryProvider extends ChangeNotifier {
  bool errorState = false;
  String errorMessage = "";
  StoryProviderErrorType errorType = StoryProviderErrorType.none;

  List<Story> currentUserStories = [];
  List<Story> stories = [];
  List<Story> originals = [];

  clear() {
    errorState = false;
    errorMessage = "";
    errorType = StoryProviderErrorType.none;
  }

  filterStories(Category category) {
    stories = originals.where((story) {
      return story.category?.id == category.id;
    }).toList();

    notifyListeners();
  }

  Future getAllStories() async {
    try {
      List<Story> _stories = await StoryService.getAllStories();
      stories = _stories;
      originals = _stories;

      clear();
    } catch (error) {
      errorState = true;
      errorMessage = error.toString();
      errorType = StoryProviderErrorType.errorGettingStories;
    }

    notifyListeners();
  }

  // Future getAllCurrentChildStories() async {
  //   try {
  //     List<Story> _stories = await StoryService.getCurrentUserAllStories();
  //     currentUserStories = _stories;

  //     clear();
  //   } catch (error) {
  //     errorState = true;
  //     errorMessage = error.toString();
  //     errorType = StoryProviderErrorType.errorGettingStories;
  //   }

  //   notifyListeners();
  // }
  Future getAllCurrentChildStories({required String userId}) async {
    try {
      List<Story> _stories =
          await StoryService.getCurrentUserAllStories(userId);
      currentUserStories = _stories;

      clear();
    } catch (error) {
      errorState = true;
      errorMessage = error.toString();
      errorType = StoryProviderErrorType.errorGettingStories;
    }

    notifyListeners();
  }
}
