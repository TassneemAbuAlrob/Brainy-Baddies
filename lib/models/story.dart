import 'package:alaa_admin/models/category.dart';

import 'age.dart';

class Story{
  final String content;
  final String title;
  final String image;
  // final Category category;
  // final Age age;

  Story({
    required this.content, 
    required this.title, 
    required this.image
  });

  factory Story.fromJson(Map data){
    return Story(
        content: data['content'],
        title: data['content'],
        image: data['image'],
    );
  }

  Map<String,String> toJson(){
    return {
      'content': content,
      'title': title,
      'image': image
    };
  }
}


