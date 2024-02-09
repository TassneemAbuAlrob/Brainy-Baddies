import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:log/core/constants/app_contants.dart';
import 'package:log/data/models/suggestion.dart';

class SuggestionService {
  // static Future postSuggestion(Suggestion suggestion) async {
  //   try {
  //     final uri = Uri.parse('$baseUrl/addSuggestion/${suggestion.email}');
  //     final result = await http.post(uri,
  //         headers: {'Content-Type': 'application/json; charset=utf-8'},
  //         body: jsonEncode(suggestion.toJson()));

  //     if (result.statusCode == 200) {
  //       print('Suggestion Object: ${jsonEncode(suggestion.toJson())}');

  //       return;
  //     } else {
  //       throw result.body;
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static Future postSuggestion(String email, String feedbackText,
      double feedbackValue, String suggText) async {
    final String apiUrl = '$baseUrl/addSuggestion/$email';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'feedbackText': feedbackText,
          'feedbackValue': feedbackValue,
          'suggText': suggText,
        }),
      );

      if (response.statusCode == 200) {
        print('Suggestion added successfully');
      } else {
        print('Failed to add suggestion. Error: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
