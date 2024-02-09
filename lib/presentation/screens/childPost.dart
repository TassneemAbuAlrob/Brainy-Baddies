import 'dart:convert';
import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:log/data/services/post_service.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'childProfile.dart';
import 'mainChild.dart';
import 'welcome/welcome_screen.dart';

class childPost extends StatefulWidget {
  @override
  _childPostState createState() => _childPostState();
}

Widget actionButton(
  IconData icon,
  String actionTitle,
  Color iconColor,
  VoidCallback onPressedCallback,
) {
  return Expanded(
    child: IconButton(
      onPressed: onPressedCallback,
      icon: Icon(
        icon,
        color: iconColor,
      ),
      tooltip: actionTitle,
    ),
  );
}

class _childPostState extends State<childPost> {
  TextEditingController textFieldController = TextEditingController();
  XFile? image;
  final picker = ImagePicker();
  Map<String, dynamic> userData = {};

  PlatformFile? file;
//   Dio dio = new Dio();
// // To fetch user photo
//   Future<Map<String, dynamic>> fetchUserData(String email) async {
//     final response = await http
//         .get(Uri.parse('http://192.168.1.112:3000/showchildprofile/$email'));

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load user data');
//     }
//   }

  @override
  void initState() {
    super.initState();
    // fetchUserData(UserServices.getEmail()).then((data) {
    //   setState(() {
    //     userData = data;
    //     String baseUrl = "http://192.168.1.112:3000";
    //     String imagePath = "uploads";
    //     String imageUrl =
    //         baseUrl + "/" + imagePath + "/" + userData['profilePicture'];
    //     profilePictureController.text =
    //         userData.containsKey('profilePicture') ? imageUrl : '';
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 243, 192, 218),
                Color.fromRGBO(205, 245, 250, 0.898),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
          "BrainyBaddies",
          style: GoogleFonts.oswald(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 55, 164, 241),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Color.fromARGB(255, 252, 50, 154),
          ),
        ],
      ),
      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Create the post editor
              Container(
                margin: EdgeInsets.only(top: 100),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(205, 245, 250, 0.898),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Color.fromARGB(255, 55, 164, 241),
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 40.0,
                          backgroundImage:
                              NetworkImage(authProvider.user.image)),
                      if (image != null)
                        Image.file(
                          File(image!.path),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(height: 10),
                      TextField(
                        controller: textFieldController,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          hintText: "Post something...",
                          filled: true,
                          fillColor: Color.fromRGBO(244, 245, 245, 0.886),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: Color.fromRGBO(218, 219, 219, 0.89),
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          actionButton(Icons.video_camera_front, "Video",
                              Color(0xFFF23E5C), () async {
                            FilePicker filePicker = FilePicker.platform;
                            FilePickerResult? result = await filePicker
                                .pickFiles(type: FileType.video);
                            if (result != null && result.count != 0) {
                              setState(() {
                                file = result.files.first;
                              });
                            }

                            final token = context.read<AuthProvider>().token;

                            await PostService.createPost(
                                textContent: textFieldController.text,
                                file: image,
                                type: 'video',
                                token: token ?? '');
                          }),
                          actionButton(
                              Icons.image, "Picture", Color(0xFF58C472), () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(205, 245, 250, 0.898),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 55, 164, 241),
                                    width: 2.0,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        XFile? xfile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (xfile != null) {
                                          setState(() {
                                            image = xfile;
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Choose Image From Gallery",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 55, 164, 241),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "MyCustomFont",
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        XFile? xfile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera);
                                        if (xfile != null) {
                                          setState(() {
                                            image = xfile;
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Choose Image From Camera",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 55, 164, 241),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "MyCustomFont",
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                          actionButton(Icons.insert_emoticon, "Activity",
                              Color(0xFFF8C03E), () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return EmojiPicker(
                                  onEmojiSelected: (category, emoji) {
                                    final emojiText = emoji.emoji;
                                    print("Selected emoji: $emojiText");
                                    textFieldController.text += emojiText;
                                  },
                                );
                              },
                            );
                          }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final token = context.read<AuthProvider>().token;
                          await PostService.createPost(
                              textContent: textFieldController.text,
                              video: file,
                              file: image,
                              type: 'image',
                              token: token ?? '');

                          await AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              title: 'Posting',
                              desc: 'Post was created successfully')
                            ..show();

                          Navigator.pop(context);
                        } catch (e) {
                          // await AwesomeDialog(
                          //   context: context,
                          //   dialogType: DialogType.error,
                          //   title: 'Posting',
                          //   desc: 'Failed to post ${e.toString()}'
                          // )..show();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[800],
                        minimumSize: Size(double.infinity, 40),
                      ),
                      child: Text(
                        'POST',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
