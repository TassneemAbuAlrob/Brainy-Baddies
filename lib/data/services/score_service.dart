import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:log/core/constants/app_contants.dart';

class ScoreService {
  Future<void> addScore(String token, int score, String gameName) async {
    final url = "$baseUrl/addscore";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
        body: jsonEncode({
          "score": score,
          "gameName": gameName,
        }),
      );

      if (response.statusCode == 201) {
        print("Score added successfully");
      } else {
        print("Failed to add score. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding score: $e");
    }
  }
}
