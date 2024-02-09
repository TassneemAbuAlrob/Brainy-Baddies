import 'package:flutter/material.dart';
import 'package:log/data/models/category.dart';
import 'package:log/data/models/video.dart';
import 'package:log/data/services/video_service.dart';
import 'package:provider/provider.dart';

enum VideoProviderErrorType { none, errorGettingVideos }

class VideoProvider extends ChangeNotifier {
  bool errorState = false;
  String errorMessage = "";
  VideoProviderErrorType errorType = VideoProviderErrorType.none;

  List<Video> videos = [];
  List<Video> currentUserVideos = [];
  List<Video> originals = [];

  clear() {
    errorState = false;
    errorMessage = "";
    errorType = VideoProviderErrorType.none;
  }

  // filterVideos(Category category) {
  //   videos = originals.where((video) {
  //     if (video.category == null) {
  //       return true;
  //     }

  //     return video.category!.id == category.id;
  //   }).toList();

  //   notifyListeners();
  // }
  filterVideos(Category category) {
    videos = originals.where((video) {
      if (video.category == null && category.id == null) {
        return true;
      } else if (video.category != null &&
          category.id != null &&
          video.category!.id == category.id) {
        return true;
      }
      return false;
    }).toList();

    notifyListeners();
  }

  Future getAllVideos() async {
    try {
      List<Video> _videos = await VideoService.getAllVideos();
      videos = _videos;
      originals = _videos;

      clear();
    } catch (error) {
      errorState = true;
      errorMessage = error.toString();
      errorType = VideoProviderErrorType.errorGettingVideos;
    }

    notifyListeners();
  }

  //   Future getAllCurrentUserVideos() async{
  //   try{
  //     List <Video> _videos = await VideoService.getAllCurrentUserVideos();
  //     currentUserVideos = _videos;

  //     clear();
  //   }catch(error){
  //     errorState = true;
  //     errorMessage = error.toString();
  //     errorType = VideoProviderErrorType.errorGettingVideos;
  //   }

  //   notifyListeners();
  // }
  Future getAllCurrentUserVideos({required String userId}) async {
    try {
      List<Video> _videos = await VideoService.getAllCurrentUserVideos(userId);
      currentUserVideos = _videos;

      clear();
    } catch (error) {
      errorState = true;
      errorMessage = error.toString();
      errorType = VideoProviderErrorType.errorGettingVideos;
    }

    notifyListeners();
  }
}
