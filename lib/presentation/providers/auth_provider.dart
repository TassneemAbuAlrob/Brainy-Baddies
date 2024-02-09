import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log/data/entities/user_update.dart';
import 'package:log/data/services/native_service.dart';
import 'package:log/data/services/user_services.dart';

import '../../data/repositories/cache_repository_impl.dart';
import '../../data/models/user.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  bool authenticated = false;
  late User user;
  bool isBoarding = true;

  bool updateUserHasError = false;
  String updateUserErrorMessage = '';

  static AuthProvider? _instance;

  // Private constructor to prevent external instantiation
  AuthProvider._();

  // Singleton instance getter
  static AuthProvider get instance {
    _instance ??= AuthProvider._();
    return _instance!;
  }

  detectToShowIntro() async {
    final prefs = CacheRepositoryImpl.instance;
    bool? boarding = await prefs.getBool('boarding');

    if (boarding != null) {
      isBoarding = boarding;
      notifyListeners();
    }
  }

  detectAuthenticationState() async {
    String? cachedToken = await CacheRepositoryImpl.instance.get('token');
    print(cachedToken);
    if (cachedToken != null) {
      token = cachedToken;
      authenticated = true;

      String? email = await CacheRepositoryImpl.instance.get('email');
      String? name = await CacheRepositoryImpl.instance.get('name');
      String? role = await CacheRepositoryImpl.instance.get('role');
      String? image = await CacheRepositoryImpl.instance.get('image');
      String? joinedAt = await CacheRepositoryImpl.instance.get('joined_at');
      String? phone = await CacheRepositoryImpl.instance.get('phone');
      String? id = await CacheRepositoryImpl.instance.get('id');

      String uniuqeId = await getUniqueId();

      user = await UserServices.getUser(id);

      notifyListeners();
    }
  }

  provideAuthenticationState(String newToken, User newUser) async {
    token = newToken;
    authenticated = true;
    user = newUser;

    await CacheRepositoryImpl.instance.set('token', newToken);

    await CacheRepositoryImpl.instance.set('email', newUser.email);
    await CacheRepositoryImpl.instance.set('name', newUser.name);
    await CacheRepositoryImpl.instance.set('role', newUser.role);
    await CacheRepositoryImpl.instance.set('image', newUser.image);
    await CacheRepositoryImpl.instance.set('phone', newUser.phone);
    await CacheRepositoryImpl.instance.set('id', newUser.id);
    await CacheRepositoryImpl.instance.set('joined_at', newUser.joinedAt);

    notifyListeners();
  }

  clearAuthenticationState() async {
    token = null;
    authenticated = false;

    await CacheRepositoryImpl.instance.remove('token');
    await CacheRepositoryImpl.instance.remove('email');
    await CacheRepositoryImpl.instance.remove('name');
    await CacheRepositoryImpl.instance.remove('role');
    await CacheRepositoryImpl.instance.remove('image');
    await CacheRepositoryImpl.instance.remove('phone');
    await CacheRepositoryImpl.instance.remove('joined_at');
    await CacheRepositoryImpl.instance.remove('id');

    notifyListeners();
  }

  updateUser(UserUpdate userData, XFile? image) async {
    try {
      User newUser = await UserServices.updateUserData(
          userId: user.id,
          name: userData.name,
          email: userData.email,
          phone: userData.phone,
          image: image);

      user = newUser;
    } catch (error) {
      updateUserHasError = true;
      updateUserErrorMessage = error.toString();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    updateUserErrorMessage = '';
    updateUserHasError = false;
    super.dispose();
  }
}
