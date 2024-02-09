//p2
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log/data/models/user.dart' as DataLogUser;
import 'package:log/data/services/user_services.dart';
import 'package:log/presentation/screens/mainChild.dart';
import 'package:log/presentation/screens/welcome/welcome_screen.dart';

import '../../../../data/services/native_service.dart';
import '../../../components/rounded_button.dart';
import '../../home_screen.dart';
import 'alreadyHaveAccout.dart';
import 'background.dart';
import 'roundedPassField.dart';
import 'rounded_input_field.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController emailController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class body extends StatefulWidget {
  body({
    super.key,
  });

  @override
  State<body> createState() => _bodyState();
}

class _bodyState extends State<body> {
  XFile? myfile;
  final _auth = FirebaseAuth.instance;
  late String email = '';
  late String password = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              myfile != null
                  ? Image.file(File(myfile!.path))
                  : GestureDetector(
                      onTap: () async {
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
                                    final xfile = await ImagePicker().pickImage(
                                      source: ImageSource.gallery,
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
                                        color:
                                            Color.fromARGB(255, 55, 164, 241),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "MyCustomFont",
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final xfile = await ImagePicker().pickImage(
                                      source: ImageSource.camera,
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
                                        color:
                                            Color.fromARGB(255, 55, 164, 241),
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
                      },
                      child: Icon(
                        Icons.person,
                        size: 60,
                      ),
                    ),

              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {
                  email = value;
                },
                iconData: Icons.email,
                controller: emailController, // Pass the user object here
              ),
              RoundedInputField(
                hintText: "Your Name",
                iconData: Icons.text_fields,
                onChanged: (value) {},
                controller: nameController, // Pass the user object here
              ),
              RoundedInputField(
                hintText: "Your Phone Number",
                iconData: Icons.phone,
                onChanged: (value) {},
                controller: phoneController, // Pass the user object here
              ),

              RoundedPasswordField(
                onChanged: (value) {
                  password = value;
                },
                controller: passwordController, // Pass the user object here
              ),
//--------------------------------------------
              RoundedButton(
                text: "REGISTER",
                color: Color.fromARGB(255, 141, 199, 241),
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      if (myfile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Select Image First'),
                        ));
                        return;
                      }
                      String uniuqeId = await getUniqueId();
                      print(uniuqeId);

                      await UserServices.registerUser(DataLogUser.User(
                          email: emailController.text,
                          name: nameController.text,
                          role: 'parent',
                          image: myfile!.path,
                          followers: [],
                          followings: [],
                          joinedAt: '',
                          phone: phoneController.text,
                          password: passwordController.text,
                          id: '',
                          uniqueId: uniuqeId));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => welcomeScreen()));
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    }
                  } else {
                    print("not ok");
                  }
                  try {
                    final newuser = await _auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);
                  } catch (e) {
                    print(e);
                  }
                  print("emailllllll:${emailController.text}");
                  print("passworddddd:${passwordController.text}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
