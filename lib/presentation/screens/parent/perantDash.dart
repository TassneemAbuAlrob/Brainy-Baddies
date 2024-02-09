import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/chat_screen.dart';
import 'package:log/presentation/screens/notifications_screen.dart';
import 'package:log/presentation/screens/parent/listChildren.dart';
import 'package:provider/provider.dart';

import '../contact_admin.dart';
import 'addChild.dart';
import 'parentProfile.dart';
import 'showInterest.dart';
import 'suggestion.dart';

Map<String, dynamic> userData = {};
TextEditingController profilePictureController = TextEditingController();
File? myfile;

List imgData = [
  "images/addchildicon.jpg",
  "images/improve.jpg",
  "images/chaticon.jpg",
  "images/suggicon.jpg",
  "images/notificationIcon.jpg",
  "images/iconContact.jpg",
];
List titles = [
  "Add Children",
  "Development",
  "Community Chat",
  "Suggestions",
  "Notifications",
  "Contact",
];

class PerantDash extends StatefulWidget {
  @override
  _PerantDashState createState() => _PerantDashState();
}

class _PerantDashState extends State<PerantDash> {
  var height, width;
  Future<void> openEmailInputDialog(BuildContext context) async {
    String enteredEmail = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Child Email:'),
          content: TextField(
            onChanged: (value) {
              enteredEmail = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter email',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                print('Entered email: $enteredEmail');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowInterest(email: enteredEmail),
                  ),
                );
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => addChild(),
          ),
        );
        break;

      case 1:
        // openEmailInputDialog(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChildrenListWidget(
                parentId: context.read<AuthProvider>().user.id),
          ),
        );

        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => suggestion(),
          ),
        );
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationsList()));
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => contactWithAdmin(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(191, 158, 158, 158),
          width: width,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(),
                height: height * 0.23,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 35,
                        left: 20,
                        right: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => parentProfile(),
                                ),
                              );
                            },
                            child: Container(
                              height: height * 0.08,
                              width: width * 0.2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => parentProfile()),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: CachedNetworkImageProvider(
                                      context.read<AuthProvider>().user.image),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 30,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "W E L C O M E",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            context.read<AuthProvider>().user.name,
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  // height: height * 0.75,
                  width: width,
                  padding: EdgeInsets.only(bottom: 20),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 25,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: imgData.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          navigateToPage(index, context);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 55, 164, 241),
                                spreadRadius: 1,
                                blurRadius: 6,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                imgData[index],
                                width: 100,
                              ),
                              Text(
                                titles[index],
                                style: GoogleFonts.abyssinicaSil(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
