import 'dart:convert';

import 'package:alaa_admin/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryService{
  static Future<List<Category>> getAllCategories() async{
    try{
        final uri = Uri.parse('http://10.0.2.2:4000/api/categories');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<Category> categoryList = decoded.map((e){
          return Category.fromJson(e);
        }).toList();

        return categoryList;
      }else{
        throw response.body;
      }
    }catch(error){
      rethrow;
    }
  }

    static Future<int> getCategoriesCount() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/categories/count');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        return int.parse(response.body);
        
      }else{
        throw response.body;
      }
    }catch(e){
      rethrow;
    }
  }

  static Future<void> createCategory(Category category) async{
    try{
        final uri = Uri.parse('http://10.0.2.2:4000/api/categories');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(category.toJson())
      );

      if(response.statusCode == 200){
        return;
      }else{
        throw response.body;
      }
    }catch(error){
      rethrow;
    }
  }
}