import 'dart:convert';

import 'package:alaa_admin/models/message.dart';
import 'package:http/http.dart' as http;

import '../models/chat.dart';

class ChatService {
  static Future<List<Chat>> getAllChats() async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/chats');
      final response = await http.get(uri);

      if(response.statusCode == 200){
        List decoded = jsonDecode(response.body);
        List<Chat> chats = decoded.map((e){
          return Chat.fromJson(e);
        }).toList();

        return chats;
      }else{
        throw response.body;
      }
    }catch(e){
      rethrow;
    }
  }

  static Future sendMessage(String chatId,Message message) async{
    try{
      final uri = Uri.parse('http://10.0.2.2:4000/api/chats/$chatId/messages');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(message.toJson())
      );

      if(response.statusCode == 200){
        return;
      }else{
        throw response.body;
      }
    }catch(e){
      rethrow;
    }
  }
}