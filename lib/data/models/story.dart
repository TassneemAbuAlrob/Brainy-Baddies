import 'package:log/data/models/age.dart';
import 'package:log/data/models/category.dart';

class Story{
  final String title;
  Category? category;
  Age? age;
  final String file;
  final String image;
  final double rating;
  final List<String> interactions;

  Story({
    required this.rating,
    required this.title, 
    this.category, 
    this.age, required this.file, required this.image, required this.interactions});

  factory Story.fromJson(Map data){
    return Story(
      title: data['title'],
      category: data['category'] == null ? null :  Category.fromJson(data['category']),
      age: data['age'] == null ? null : Age.fromJson(data['age']),
      file: data['pdf'],
      image: data['image'],
      rating: double.parse(data['rating'].toString()),
      interactions: (data['interactions'] as List<dynamic>).map((e) => e.toString()).toList()
    );
  }
}