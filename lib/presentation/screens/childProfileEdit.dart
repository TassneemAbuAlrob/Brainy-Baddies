import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:log/data/entities/user_update.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'childProfile.dart';
import 'mainChild.dart';
import 'welcome/welcome_screen.dart';



class childProfileEdit extends StatefulWidget {
  @override
  _childProfileEditState createState() => _childProfileEditState();
}

class _childProfileEditState extends State<childProfileEdit> {
  XFile? image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    nameController.text = authProvider.user.name;
    emailController.text = authProvider.user.email;
    phoneController.text = authProvider.user.phone;

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
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_back),
              color: Color.fromARGB(255, 252, 50, 154),
            ),
          ],
          title: Text(
            "Edit Your Details",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 55, 164, 241),
              ),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          constraints: const BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(244, 245, 245, 0.886),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: CircleAvatar(
                                radius: 74.0,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: image != null ?
                                    FileImage(
                                      File(image!.path)
                                    ) : NetworkImage(authProvider.user.image) as ImageProvider
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 114, left: 70),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  205, 245, 250, 0.898),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 55, 164, 241),
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    XFile? xfile =
                                                        await ImagePicker()
                                                            .pickImage(
                                                      source:
                                                          ImageSource.gallery,
                                                    );
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            "MyCustomFont",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    XFile? xfile =
                                                        await ImagePicker()
                                                            .pickImage(
                                                      source:
                                                          ImageSource.camera,
                                                    );
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            "MyCustomFont",
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color:
                                            Color.fromARGB(255, 55, 164, 241),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                        controller: nameController,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                        ),
                        controller: emailController,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                        ),
                        controller: phoneController,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.SCALE,
                              title: 'Confirmation',
                              desc: 'Are you sure you want to save the edits?',
                              btnCancelOnPress: () {
                                // Cancel action
                              },
                              btnOkOnPress: () async {
                                UserUpdate userData = UserUpdate(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                );
                                await authProvider.updateUser(
                                  userData,
                                  image
                                );

                                if(authProvider.updateUserHasError){
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.scale,
                                    title: 'Error',
                                    desc: authProvider.updateUserErrorMessage,
                                  )..show();
                                }
                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                            )..show();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[800],
                            minimumSize: Size(100, 40),
                          ),
                          child: Text('SAVE', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            minimumSize: Size(100, 40),
                          ),
                          child: Text('CANCEL', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
