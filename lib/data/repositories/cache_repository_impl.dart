import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/repositories/cache_repository.dart';

class CacheRepositoryImpl implements ICacheRepository {
  static SharedPreferences? sharedPreferences;
  static CacheRepositoryImpl? _instance;

  // Private constructor to prevent external instantiation
  CacheRepositoryImpl._();

  // Singleton instance getter
  static CacheRepositoryImpl get instance {
    _instance ??= CacheRepositoryImpl._();
    return _instance!;
  }

  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<String?> get(String key) async {
    if (sharedPreferences != null) {
      String? value = sharedPreferences!.getString(key);
      return value;
    }

    return null;
  }

  @override
  Future<bool?> getBool(String key) async {
    if (sharedPreferences != null) {
      bool? value = sharedPreferences!.getBool(key);
      return value;
    }

    return false;
  }

  @override
  Future<bool> set(String key, String? value) async {
    if (sharedPreferences != null && value != null) {
      return await sharedPreferences!.setString(key, value);
    }

    return false;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    if (sharedPreferences != null) {
      return await sharedPreferences!.setBool(key, value);
    }

    return false;
  }

  @override
  Future<bool> remove(String key) async {
    if (sharedPreferences != null && await contains(key)) {
      return await sharedPreferences!.remove(key);
    }

    return false;
  }

  @override
  Future<bool> contains(String key) async {
    if (sharedPreferences != null) {
      return sharedPreferences!.containsKey(key);
    }

    return false;
  }
}
