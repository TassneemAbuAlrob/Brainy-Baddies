import 'dart:convert';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart' as http;
import 'package:http/http.dart' as http;
import 'package:log/core/constants/app_contants.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/mainprofileotherchild.dart';
import 'package:provider/provider.dart';

class rainbowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/followers.jpg',
      width: 30,
      height: 30,
    );
  }
}

class FollowerDetails extends StatelessWidget {
  final String name;
  final String email;
  final String image;
  final String phone;

  FollowerDetails({
    required this.name,
    required this.email,
    required this.image,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            name,
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontSize: 26,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        body: Center(
          child: ClayContainer(
            borderRadius: 20,
            color: Color.fromARGB(255, 225, 218, 218),
            emboss: false,
            spread: 9,
            depth: 50,
            child: ClayContainer(
              borderRadius: 300,
              color: Colors.white,
              emboss: true,
              spread: 2,
              depth: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(image),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rainbowIcon(),
                      SizedBox(width: 10),
                      Text(
                        "Name: $name",
                        style: GoogleFonts.oswald(
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rainbowIcon(),
                      SizedBox(width: 10),
                      Text(
                        "Email: $email",
                        style: GoogleFonts.oswald(
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rainbowIcon(),
                      SizedBox(width: 10),
                      Text(
                        "Phone Number: ${phone ?? 'N/A'}",
                        style: GoogleFonts.oswald(
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 18),
                  Padding(
                    padding: EdgeInsets.only(left: 150),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => mainprofileotherchild(
                              name: name,
                              email: email,
                              image: image,
                              phone: phone,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Go To His/Her Profile",
                        style: GoogleFonts.oswald(
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 251, 249, 249),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class followersList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _followersListState createState() => _followersListState();
}

class _followersListState extends State<followersList> {
  final List<Map<String, dynamic>> _listItem = [];

  Future<void> fetchFollowers(String email) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/followers/$email'));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> followerData =
            (json.decode(response.body) as List).cast<Map<String, dynamic>>();
        setState(() {
          _listItem.clear();
          _listItem.addAll(followerData);
        });
      } else {}
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
    fetchFollowers(context.read<AuthProvider>().user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 218, 218),
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage('images/followers.jpg'),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "YOUR FOLLOWERS :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Center(
                            child: Text(
                          "Let's see who follows you :)",
                          style: TextStyle(
                              color: Color.fromARGB(255, 55, 164, 241),
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: _listItem
                      .map((follower) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowerDetails(
                                    name: follower['name'] ?? 'N/A',
                                    email: follower['email'] ?? 'N/A',
                                    phone: follower['phone'] ?? 'N/A',
                                    image: follower['image'] ?? 'N/A',
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(follower['image']),
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
      ),
    );
  }
}
