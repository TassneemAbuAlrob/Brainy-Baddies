import 'dart:convert';

import 'package:log/data/models/comment.dart';

import 'age.dart';

import 'category.dart';

class Video {
  final String link;
  final String poster;
  final String id;
  final String? title;
  final String? description;
  final String publishDate;
  final String publisher;
  final int views;
  final double rating;
  final Category? category;
  final Age? age;
  final List<Comment>? comments;

  Video(
      {required this.link,
      required this.title,
      required this.description,
      required this.publishDate,
      required this.publisher,
      required this.views,
      required this.category,
      required this.age,
      required this.poster,
      required this.rating,
      required this.id,
      this.comments});

  factory Video.fromJson(Map<String, dynamic> data) {
    print('Decoding Video: $data');
    print('Data Type: ${data.runtimeType}');

    if (data is! Map) {
      print('Error: Invalid data format for Video.fromJson');
    }

    return Video(
      id: data['_id'],
      link: data['link'],
      title: data['title'],
      description: data['description'],
      publishDate: data['publish_date'],
      publisher: data['publisher'],
      views: data['views'],
      rating: double.parse(data['rating'].toString()),
      category: data['category'] == null || data['category'] is String
          ? null
          : Category.fromJson(data['category']),
      age: data['age'] == null || data['age'] is String
          ? null
          : Age.fromJson(data['age']),
      poster: data['poster'],
    );
  }
}
