// messages_screen.dart

import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/providers/chat_provider.dart';
import 'package:alaa_admin/screens/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat.dart';

class MessagesScreen extends StatefulWidget {
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    initializeChats();
  }

  void initializeChats() async{
    await Provider.of<ChatProvider>(context, listen: false).getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe9e0db),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          List<Chat> chats = chatProvider.chats;

          return Container(
            margin: EdgeInsets.only(top: 12.0),
            child: Column(
              children: [
                SizedBox(height: 24,),
                Row(
                  
                  children: [
                    SizedBox(
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Color(0xFFb3c9bd),
                              borderRadius: BorderRadius.circular(20)
                            ),
                          ),
                          SizedBox(width: 8.0,),
                          Text('Parent'),
                          SizedBox(width:4.0),
                          Text(chatProvider.totalParentMessages.toString())
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Color(0xFFfca498),
                              borderRadius: BorderRadius.circular(20)
                            ),
                          ),
                          SizedBox(width: 8.0,),
                          Text('Child'),
                          SizedBox(width:4.0),
                          Text(chatProvider.totalChildMessages.toString())
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12.0,),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    Chat chat = chats[index];
                    return MessageTile(chat: chat);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// message_tile.dart


class MessageTile extends StatelessWidget {
  final Chat chat;

  MessageTile({required this.chat});

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () {
        Provider.of<ChatProvider>(context, listen: false).setCurrentOpenedChat(chat);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatScreen())
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          tileColor: chat.sender.role == 'parent' ? Color(0xFFb0cabf) : Color(0xFFf8a69b),
          contentPadding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
            chat.sender.image,
          ),
          ),
          title: Text(
            chat.sender.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
