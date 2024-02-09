import 'user.dart';

class Like{
  final String date;
  final User user;

  Like({required this.date, required this.user});
  

  factory Like.fromJson(Map data){
    return Like(
      date: data['date'],
      user: User.fromJson(data['user'])
    );
  }
}