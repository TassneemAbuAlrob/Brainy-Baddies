// Message provider to manage the list of messages
import 'package:alaa_admin/services/chat_service.dart';
import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = [];
  Chat? currentOpenedChat;
  bool errorState = false;
  String errorMessage = "";

  int totalParentMessages = 0;
  int totalChildMessages = 0;

  clearErrors(){
    errorState = false;
    errorMessage = "";
  }

  setCurrentOpenedChat(Chat chat){
    currentOpenedChat = chat;
  }

  Future getAllChats() async{
    try{
      chats = await ChatService.getAllChats();
      totalChildMessages = chats.where((element) => element.sender.role == 'child',).toList().length;
      totalParentMessages = chats.where((element) => element.sender.role == 'parent',).toList().length;
      clearErrors();
    }catch(e){
      print(e.toString());
      errorState = true;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future sendMessage(String chatId, Message message) async{
    try{
      await ChatService.sendMessage(chatId, message);
      currentOpenedChat!.messages.add(message);
    }catch(e){
      errorState = true;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}
