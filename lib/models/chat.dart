
// Model for a message
import 'dart:convert';

import 'package:alaa_admin/models/message.dart';

import 'user.dart';

class Chat {
  final String id;
  final User sender;
  final List<Message> messages;

  Chat({
    required this.sender,
    required this.messages,
    required this.id
  });

  factory Chat.fromJson(Map json){
    List decoded = json['messages'];
    List<Message> messages = decoded.map((e){
      return Message.fromJson(e);
    }).toList();
    print(messages);
    print(decoded);

    User sender = User.fromJson(json['sender']);
    print(sender);
    return Chat(
      id: json["_id"],
      sender: sender,
      messages: messages
    );
  }
}