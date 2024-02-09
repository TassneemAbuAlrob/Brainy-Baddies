import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/parent/addChild.dart';
import 'package:provider/provider.dart';

import '../../../data/entities/user_update.dart';

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();

class parentEdit extends StatefulWidget {
  @override
  _parentEditState createState() => _parentEditState();
}

class _parentEditState extends State<parentEdit> {
  XFile? myfile;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    fullNameController.text = authProvider.user.name;
    emailController.text = authProvider.user.email;
    phoneNumberController.text = authProvider.user.phone;
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

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
                                  backgroundImage: myfile != null
                                      ? FileImage(File(myfile!.path))
                                      : CachedNetworkImageProvider(context
                                          .read<AuthProvider>()
                                          .user
                                          .image) as ImageProvider,
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
                                                    final xfile =
                                                        await ImagePicker()
                                                            .pickImage(
                                                      source:
                                                          ImageSource.gallery,
                                                    );
                                                    if (xfile != null) {
                                                      setState(() {
                                                        myfile = xfile;
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
                                                    final xfile =
                                                        await ImagePicker()
                                                            .pickImage(
                                                      source:
                                                          ImageSource.camera,
                                                    );
                                                    if (xfile != null) {
                                                      setState(() {
                                                        myfile = xfile;
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
                        controller: phoneNumberController,
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
                            final authProvider = context.read<AuthProvider>();
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
                                  phone: phoneNumberController.text,
                                );
                                await authProvider.updateUser(userData, myfile);

                                if (authProvider.updateUserHasError) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.scale,
                                    title: 'Error',
                                    desc: authProvider.updateUserErrorMessage,
                                  ).show();
                                }
                                // Close the dialog
                                Navigator.of(context).pop();
                              },
                            )..show();

                            context
                                .read<AuthProvider>()
                                .clearAuthenticationState();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[800],
                            minimumSize: Size(100, 40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'SAVE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            minimumSize: Size(100, 40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'CANCEL',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
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
