import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:log/core/constants/app_contants.dart';
import 'package:log/data/models/category.dart';

class CategoryService{
  static Future<List<Category>> getAllCategories() async {
    try{
      final uri = Uri.parse('$baseUrl/categories');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<Category> categories = decoded.map((e){
          return Category.fromJson(e);
        }).toList();

        return categories;
      }else{
        throw response.body;
      }
    }catch(error){
      rethrow;
    }
  }
}