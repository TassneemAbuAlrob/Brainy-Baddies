import 'dart:convert';

class User{
  final String id;
  final String email;
  final String name;
  final String role;
  final String image;

  User({required this.email, required this.name, required this.role, required this.image,required this.id});

  factory User.fromJson(Map data){
    print(json);
    User user = User(
      email: data['email'],
      role: data['role'],
      name: data['name'],
      image: data['image'],
      id: data['_id'],
    );
    print(user);
    return user;
  }
}