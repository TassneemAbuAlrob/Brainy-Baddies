import 'package:flutter/material.dart';
import 'package:log/data/services/post_service.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import '../../data/models/post.dart';

enum PostProviderErrorType { none, errorGettingCurrentUserPosts }

class PostProvider with ChangeNotifier {
  bool errorState = false;
  String errorMessage = "";
  PostProviderErrorType errorType = PostProviderErrorType.none;

  clear() {
    errorMessage = "";
    errorState = false;
    errorType = PostProviderErrorType.none;
  }

  List<Post> _currentUserPosts = [];

  // Getter for getting the current user posts
  List<Post> get currentUserPosts => _currentUserPosts;

  // Method to fetch current user posts
  Future<void> getCurrentUserPosts(String userId) async {
    try {
      _currentUserPosts = await PostService.getCurrentUserPosts(userId);
      clear();
    } catch (error) {
      print(error.toString());
      errorState = true;
      errorMessage = error.toString();
      errorType = PostProviderErrorType.errorGettingCurrentUserPosts;
    }

    notifyListeners();
  }

  // Method to remove a post by its ID
  void removePost(String postId) {
    _currentUserPosts.removeWhere((post) => post.id == postId);
    notifyListeners();
  }
}
