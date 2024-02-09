import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:log/core/constants/app_contants.dart';
import 'package:log/data/models/user.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'native_service.dart';

class UserServices {
  static Future<List<User>> getUsersFromAPI(
      String email, Function(List<User>) onDataLoaded) async {
    try {
      Uri uri = Uri.parse('$baseUrl/ListOfusers/$email');
      var response = await http.get(uri);

      print("Follow User API Response: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<User> users = (json.decode(response.body) as List)
            .map((data) => User.fromJson(data))
            .toList();

        onDataLoaded(users);

        return users;
      } else {
        print('${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (error) {
      print("An error occurred: $error");
      return [];
    }
  }

  static Future<void> fetchChildrenData(String parentUser,
      Function(List<Map<String, dynamic>>) updateCallback) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/fetchChildren?parentUser=$parentUser'));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> childData =
            (json.decode(response.body) as List).cast<Map<String, dynamic>>();
        updateCallback(childData);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  static Future<int> childcount(String parentUser) async {
    try {
      final uri = Uri.parse('$baseUrl/countChildUsers?parentUser=$parentUser');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['count'];
      } else {
        throw response.body;
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future addChild(User user) async {
    try {
      final uri = Uri.parse('$baseUrl/addChild');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath('image', user.image));

      request.fields.addAll(user.toJson());

      final response = await request.send();

      if (response.statusCode == 200) {
        return;
      } else {
        throw await response.stream.bytesToString();
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future registerUser(User user) async {
    try {
      final uri = Uri.parse('$baseUrl/register');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath('image', user.image));

      request.fields.addAll(user.toJson());

      final response = await request.send();

      if (response.statusCode == 200) {
        return;
      } else {
        throw await response.stream.bytesToString();
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final uri = Uri.parse('$baseUrl/login');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'email': email, 'password': password}));

      print(response.statusCode);

      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        Map decoded = jsonDecode(response.body);

        print(decoded);

        await sharedPreferences.setString('token', decoded['token']);
        await sharedPreferences.setString('email', decoded['user']['email']);
        await sharedPreferences.setString('name', decoded['user']['name']);
        await sharedPreferences.setString('role', decoded['user']['role']);
        await sharedPreferences.setString('image', decoded['user']['image']);
        await sharedPreferences.setString('id', decoded['user']['_id']);
        await sharedPreferences.setString(
            'joined_at', decoded['user']['joined_at']);

        await Provider.of<AuthProvider>(context, listen: false)
            .provideAuthenticationState(
                decoded['token'], User.fromJson(decoded['user']));

        return;
      } else if (response.statusCode == 404) {
        throw "User Not Found";
      } else if (response.statusCode == 400) {
        throw "Invalid Password";
      }
    } catch (error) {
      print('i ws here');
      throw error.toString();
    }
  }

  static Future<User> updateUserData(
      {required String userId,
      required String name,
      required String email,
      required String phone,
      XFile? image}) async {
    try {
      final uri = Uri.parse('$baseUrl/users/$userId');
      var request = http.MultipartRequest('PUT', uri);
      request.fields.addAll({'name': name, 'email': email, 'phone': phone});

      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        Map decoded = jsonDecode(await response.stream.bytesToString());
        User user = User.fromJson(decoded);
        return user;
      } else {
        throw await response.stream.bytesToString();
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<User>> getAllUsers() async {
    try {
      final uri = Uri.parse('$baseUrl/users');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List decoded = jsonDecode(response.body);
        List<User> users = decoded.map((e) {
          return User.fromJson(e);
        }).toList();

        return users;
      } else {
        throw response.body;
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<User> getUser(String? id) async {

    try {
      if(id == null){
        throw "id in invalid";
      }
      final uri = Uri.parse('$baseUrl/users/$id');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map decoded = jsonDecode(response.body);
        User user = User.fromJson(decoded);

        return user;
      } else {
        throw response.body;
      }
    } catch (error) {
      rethrow;
    }
  }
}
