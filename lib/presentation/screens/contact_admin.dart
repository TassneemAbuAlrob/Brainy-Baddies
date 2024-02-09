import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

TextEditingController profilePictureController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController emailController = TextEditingController();

class contactWithAdmin extends StatefulWidget {
  @override
  _contactWithAdminState createState() => _contactWithAdminState();
}

class _contactWithAdminState extends State<contactWithAdmin> {
  var _titleTextStyle = TextStyle(
      fontSize: 22, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
  var contentTextStyle = TextStyle(
      fontSize: 18, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    nameController.text = 'John Doe';

    phoneController.text = '0597435866';
    emailController.text = 'yamakalaa01@gmail.com';
  }

  bool _isLoading = false;

  String joinedAt = " ";
  bool _isSameUser = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                    nameController.text == null
                                        ? 'Name here'
                                        : nameController.text!,
                                    style: _titleTextStyle)),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Contact Info',
                              style: _titleTextStyle,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: userInfo(
                                  title: 'Email:',
                                  content: emailController.text),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: userInfo(
                                  title: 'Phone number:',
                                  content: phoneController.text),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _isSameUser
                                ? Container()
                                : Divider(
                                    thickness: 1,
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            _isSameUser
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _contactBy(
                                        color: Colors.green,
                                        fct: () {
                                          _openWhatsAppChat();
                                        },
                                        icon: FontAwesome.whatsapp,
                                      ),
                                      _contactBy(
                                          color: Colors.red,
                                          fct: () {
                                            _mailTo();
                                          },
                                          icon: Icons.mail_outline),
                                      _contactBy(
                                          color: Colors.purple,
                                          fct: () {
                                            _callPhoneNumber();
                                          },
                                          icon: Icons.call_outlined),
                                    ],
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            !_isSameUser
                                ? Container()
                                : Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: MaterialButton(
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => UserState(),
                                          //   ),
                                          // );
                                        },
                                        color: Colors.pink.shade700,
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.logout,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                'Logout',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: AssetImage('images/avatar.png'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _openWhatsAppChat() async {
    var url = 'https://wa.me/${phoneController.text}?text=HelloWorld';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Error');
      throw 'Error occurred';
    }
  }

  void _mailTo() async {
    var mailUrl = 'mailto:${emailController.text}';
    if (await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print('Erorr');
      throw 'Error occured';
    }
  }

  void _callPhoneNumber() async {
    var url = 'tel://${phoneController.text}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured';
    }
  }

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
            ),
            onPressed: () {
              fct();
            },
          )),
    );
  }

  Widget userInfo({required String title, required String content}) {
    return Row(
      children: [
        Text(
          title,
          style: _titleTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: contentTextStyle,
          ),
        ),
      ],
    );
  }
}
