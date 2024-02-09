import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:log/data/services/user_services.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../welcome/welcome_screen.dart';
import 'childProfileForParent.dart';
import 'parentEdit.dart';
import 'perantDash.dart';

class parentProfile extends StatefulWidget {
  @override
  _parentProfileState createState() => _parentProfileState();
}

class _parentProfileState extends State<parentProfile> {
  Map<String, dynamic> userData = {};
  final List<Map<String, dynamic>> _listItem = [];
  File? myfile;
  void fetchDataAndUpdateUI() {
    UserServices.fetchChildrenData(context.read<AuthProvider>().user.email,
        (List<Map<String, dynamic>> childData) {
      setState(() {
        _listItem.clear();
        _listItem.addAll(childData);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDataAndUpdateUI();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(189, 224, 220, 220),
                Color.fromRGBO(205, 245, 250, 0.898),
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PerantDash(),
                            ),
                          );
                        },
                        child: Icon(
                          AntDesign.arrowleft,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => welcomeScreen(),
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () async {
                            await context
                                .read<AuthProvider>()
                                .clearAuthenticationState();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => welcomeScreen()));
                          },
                          child: Icon(
                            AntDesign.logout,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: height * 0.43,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: innerHeight * 0.72,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                      context.read<AuthProvider>().user.name,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'kanit',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 55, 164, 241),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Number of your children:',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 156, 155, 155),
                                                fontFamily: 'Nunito',
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            FutureBuilder<int>(
                                              future: UserServices.childcount(
                                                  context
                                                      .read<AuthProvider>()
                                                      .user
                                                      .email),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  return Text(
                                                    snapshot.data.toString(),
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 55, 164, 241),
                                                      fontFamily: 'Nunito',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: CircleAvatar(
                                      radius: 74.0,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 60.0,
                                        backgroundImage:
                                            CachedNetworkImageProvider(context
                                                .read<AuthProvider>()
                                                .user
                                                .image),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: height * 0.5,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => parentEdit()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 55, 164, 241),

                              // minimumSize: Size(100, 40),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.edit),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Edit Your Profile')
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2.5,
                          ),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: _listItem
                                  .map((child) => GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  childProfileForParent(
                                                name: child['name'],
                                                email: child['email'],
                                                image: child['image'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    child['image']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
