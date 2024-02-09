import 'dart:convert';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log/core/constants/app_contants.dart';

import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/childStroriesList.dart';
import 'package:log/presentation/screens/childVediosList.dart';
import 'package:log/presentation/screens/childpostList.dart';
import 'package:log/presentation/screens/current_child_stories.dart';
import 'package:log/presentation/screens/current_child_videos.dart';
import 'package:log/presentation/screens/welcome/welcome_screen.dart';

import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class mainprofileotherchild extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  final String phone;

  mainprofileotherchild({
    required this.name,
    required this.email,
    required this.image,
    required this.phone,
  });

  @override
  _mainprofileotherchildState createState() => _mainprofileotherchildState();
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

class _mainprofileotherchildState extends State<mainprofileotherchild> {
  File? myfile;
  File? myfile2;
  Emoji? selectedEmoji;
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> posts = [];
  late User user;
  @override
  void initState() {
    super.initState();
    user = User(
      name: widget.name,
      email: widget.email,
      image: widget.image,
      phone: widget.phone,
      isFollowing: true, // Set the initial value
    );
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
            "BrainyBaddies",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 55, 164, 241),
              ),
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  await context.read<AuthProvider>().clearAuthenticationState();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => welcomeScreen()));
                },
                child: Icon(Icons.logout, size: 30, color: Colors.pink),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          constraints: const BoxConstraints.expand(),
          child: SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 12,
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(244, 245, 245, 0.886),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: myfile != null
                                      ? FileImage(myfile!)
                                      : widget.image.isNotEmpty
                                          ? NetworkImage(widget.image)
                                              as ImageProvider
                                          : AssetImage('images/background.gif')
                                              as ImageProvider,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height:
                                    16), // Add some spacing between the CircleAvatar and ElevatedButton
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Adjust the alignment as needed
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (user.isFollowing) {
                                      unfollowUser(user);
                                    } else {
                                      followUser(user);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: user.isFollowing
                                        ? Color.fromARGB(255, 252, 50, 154)
                                        : Color.fromARGB(255, 55, 164, 241),
                                  ),
                                  child: Text(
                                      user.isFollowing ? 'Unfollow' : 'Follow'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 114, left: 70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 55, 164, 241),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      // margin: const EdgeInsets.only(
                      //   top: 100,
                      //   right: 20,
                      // ),
                      margin: EdgeInsets.symmetric(vertical: 16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 55, 164, 241),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.email,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 62, 62, 62),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 250, // Adjust the height as needed
              child: SnappingList(email: widget.email),
            ),
          ])),
        ));
  }

  Future<void> followUser(User user) async {
    try {
      String userEmail = context.read<AuthProvider>().user.email;

      Uri uri = Uri.parse('$baseUrl/usersfollow/${userEmail ?? ''}');
      final response = await http.post(
        uri,
        body: {
          'followUserEmail': user.email,
          'follow': (!user.isFollowing).toString(),
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          user.isFollowing = !user.isFollowing;
        });
      } else {
        // Handle the error here
      }
    } catch (error) {
      print("Follow User Error: $error");
    }
  }

  Future<void> unfollowUser(User user) async {
    try {
      String userEmail = context.read<AuthProvider>().user.email;

      Uri uri = Uri.parse('$baseUrl/usersunfollow/${userEmail ?? ''}');
      final response = await http.delete(
        uri,
        body: {
          'followUserEmail': user.email,
          'follow': user.isFollowing ? 'true' : 'false',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          user.isFollowing = !user.isFollowing;
        });
      } else {
        // Handle the error here
      }
    } catch (error) {
      print("Unfollow User Error: $error");
    }
  }
}

//// Horizantal viewList

class listhorizant {
  final String imagePath;
  final String title;
  listhorizant(this.imagePath, this.title);
}

class SnappingList extends StatefulWidget {
  final String email;

  const SnappingList({required this.email, Key? key}) : super(key: key);

  @override
  _SnappingListState createState() => _SnappingListState();
}

class _SnappingListState extends State<SnappingList> {
  List<listhorizant> productList = [
    listhorizant('images/videocover.jpg', ' Videos?'),
    listhorizant('images/storiescover.jpg', ' Stories?'),
    listhorizant('images/post.jpg', ' Posts?'),
    // listhorizant('images/followers.jpg', 'Your Followers?'),
    // listhorizant('images/following.jpg', 'Who are you following?'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: 250,
      child: ScrollSnapList(
        itemBuilder: _buildListItem,
        itemCount: productList.length,
        itemSize: 150,
        onItemFocus: (index) {},
        dynamicItemSize: true,
      ),
    ));
  }

  Widget _buildListItem(BuildContext context, int index) {
    listhorizant product = productList[index];

    // Define routes for each item
    Map<String, Widget> itemRoutes = {
      ' Posts?': childpostList(email: widget.email),
      ' Videos?': childVediosList(email: widget.email),
      ' Stories?': childStroriesList(email: widget.email),
      // 'Your Followers?': followersList(),
      // 'Who are you following?': followingList(),
    };

    return GestureDetector(
      onTap: () {
        String title = product.title;
        if (itemRoutes.containsKey(title)) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => itemRoutes[title]!));
        }
      },
      child: SizedBox(
        width: 150,
        height: 300,
        child: Card(
          elevation: 12,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Column(
              children: [
                Image.asset(
                  product.imagePath,
                  fit: BoxFit.cover,
                  width: 150,
                  height: 180,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String email;
  final String image;
  bool isFollowing;
  final String? phone;

  User({
    required this.name,
    required this.email,
    required this.image,
    this.isFollowing = false,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'] ?? '',
      isFollowing: json['isFollowing'] ?? false,
    );
  }
}
