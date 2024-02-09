import 'package:log/data/models/comment.dart';
import 'package:log/data/models/like.dart';
import 'package:log/data/models/user.dart';

class Post {
  final String id;
  final String textContent;
  final String? imageContent;
  final String? video;
  final User user;
  final String date;

  final List<Like> likes;
  final List<Comment> comments;

  Post(
      {required this.textContent,
      required this.imageContent,
      required this.video,
      required this.user,
      required this.date,
      required this.likes,
      required this.comments,
      required this.id});

  factory Post.fromJson(Map data) {
    return Post(
        textContent: data['text_content'],
        imageContent: data['image_content'],
        id: data['_id'],
        video: data['video'],
        user: User.fromJson(data['user']),
        date: data['date'],
        likes: (data['likes'] as List).map((e) {
          return Like.fromJson(e);
        }).toList(),
        comments: (data['comments'] as List).map((e) {
          return Comment.fromJson(e);
        }).toList());
  }
}
