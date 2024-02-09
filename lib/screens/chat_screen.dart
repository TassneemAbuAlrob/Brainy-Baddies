import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/chat.dart';
import 'package:alaa_admin/models/message.dart';
import 'package:alaa_admin/providers/chat_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_text_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<ChatProvider>(
          builder: (BuildContext context, ChatProvider chatProvider, Widget? child) { 
            Chat? chat = chatProvider.currentOpenedChat;
            return Column(
          children: [
            HeaderWidget(chat: chat!,),
            Expanded(
              child: BodyWidget(chat: chat,),
            ),
            FooterWidget(chat: chat,),
          ],
        );
          },
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final Chat chat;
  const HeaderWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF5c7064),
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      height: 60,
      child: Row(
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.white,size: 24,),
          ),
          SizedBox(width: 24,),
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(chat.sender.image),
          ),

          SizedBox(width: 12.0,),

          Text(chat.sender.name,style: TextStyle(
            fontSize: 18,
            color: Colors.white
          ),)
        ],
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  final Chat chat;
  const BodyWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFe8dfda),
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: chat.messages.length,
        itemBuilder: (context,index){
          Message message = chat.messages[index];
    
          return Row(
            mainAxisAlignment: message.sender == chat.sender.id ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              MessageWidget(message: message, chat: chat,)
            ],
          );
        },
        separatorBuilder: (context,index){
          return SizedBox(height: 12.0,);
        },
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  final Chat chat;
  FooterWidget({super.key, required this.chat});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
            color: Color(0xFFe8dfda),
      height: 60,
      padding: EdgeInsets.all(8.0),

      child: Row(
        children: [
          Expanded(
            child: NormalTemplateTextField(
              hintText: 'Message',
              controller: controller,
            ),
          ),
          SizedBox(width: 12.0,),
          InkWell(
            onTap: ()async{
              Message message = Message(
                sender: 'admin', 
                message: controller.text, 
                sendDate: DateTime.now().millisecondsSinceEpoch.toString()
              );
              await Provider.of<ChatProvider>(context, listen: false).sendMessage(
                chat.id, 
                message
              );
              controller.clear();
            },
            child: Icon(Icons.send,color: Colors.blue,),
          )
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;
  final Chat chat;
  MessageWidget({super.key, required this.message, required this.chat});

  @override
  Widget build(BuildContext context) {
      final media = MediaQuery.of(context).size;
        final DateFormat dateFormat = DateFormat('dd-MM  HH:mm:ss');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: message.sender == chat.sender.id ? Color(0xFFaec8bb) : Colors.white,
      ),
      padding: EdgeInsets.all(8.0),
      width: media.width * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.message,style: TextStyle(
            color: message.sender == chat.sender.id ?Colors.white : Colors.black
          ),),
          SizedBox(height: 4.0,),
          Align(
            alignment: Alignment.centerRight,
            child: Text(dateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(message.sendDate))),style: TextStyle(
              color: message.sender == chat.sender.id ?Colors.white : Colors.black
            ),),
          )
        ],
      ),
    );
  }
}


