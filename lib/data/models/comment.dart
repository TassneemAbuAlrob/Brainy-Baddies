import 'package:log/data/models/user.dart';

class Comment {
  final User user;
  final DateTime date;
  final String content;

  Comment({required this.user, required this.date, required this.content});

  factory Comment.fromJson(Map<String, dynamic> data) {
    dynamic userData = data["user"];
    User user;

    if (userData is String) {
      // Handle the case where 'user' is a String (assuming it's the user ID)
      user = User(
          id: userData,
          email: '',
          name: '',
          role: '',
          image: '',
          joinedAt: '',
          phone: '',
          uniqueId: '',
          followers: [],
          followings: []);
    } else if (userData is Map<String, dynamic>) {
      // Handle the case where 'user' is a Map
      user = User.fromJson(userData);
    } else {
      // Handle other cases or throw an exception if needed
      throw Exception("Unexpected type for 'user' field");
    }

    return Comment(
      user: user,
      date: DateTime.parse(data["date"]),
      content: data["content"],
    );
  }
}
