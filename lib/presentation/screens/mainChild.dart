import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/allPosts.dart';
import 'package:log/presentation/screens/challenges_list.dart';
import 'package:log/presentation/screens/contact_admin.dart';
import 'package:log/presentation/screens/parent/OnBoardingPage.dart';
import 'package:log/presentation/screens/stories.dart';
import 'package:log/presentation/screens/users_list.dart';
import 'package:provider/provider.dart';

import 'childProfile.dart';
import 'notifications_screen.dart';
// import 'users_list.dart';
import 'videoList.dart';
import 'package:log/presentation/screens/game.dart';

Map<String, dynamic> userData = {};
TextEditingController profilePictureController = TextEditingController();
TextEditingController nameController = TextEditingController();

File? myfile;
//to fetch photo&name
Future<Map<String, dynamic>> fetchUserData(String email) async {
  final response = await http
      .get(Uri.parse('http://192.168.1.112:3000/showchildprofile/$email'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

class mainChild extends StatelessWidget {
  const mainChild({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main page',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();
    // fetchUserData(UserServices.getEmail()).then((data) {
    //   setState(() {
    //     userData = data;
    //     String baseUrl = "http://192.168.1.112:3000";
    //     String imagePath = "uploads";
    //     String imageUrl =
    //         baseUrl + "/" + imagePath + "/" + userData['profilePicture'];
    //     nameController.text =
    //         userData.containsKey('name') ? userData['name'] : '';
    //     profilePictureController.text =
    //         userData.containsKey('profilePicture') ? imageUrl : '';
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    title: Text(nameController.text,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white)),
                    subtitle: Text('W E L C O M E  ${authProvider.user.name}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white54)),
                    trailing: GestureDetector(
                      onTap: () {
                        // Navigate to the childProfile.dart page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => childProfile()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: CachedNetworkImageProvider(
                            authProvider.user.image,
                            maxHeight: 30,
                            maxWidth: 30),
                      ),
                    )),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 192, 234, 248),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  clickableItem(context, 'Videos',
                      CupertinoIcons.play_rectangle, Colors.deepOrange),
                  clickableItem(context, 'Stories', CupertinoIcons.book_circle,
                      Colors.purple),
                  clickableItem(context, 'Challenges',
                      CupertinoIcons.game_controller, Colors.indigo),
                  clickableItem(context, 'Games',
                      CupertinoIcons.gamecontroller_alt_fill, Colors.brown),
                  clickableItem(context, 'Posts', CupertinoIcons.command,
                      Colors.pinkAccent),
                  clickableItem(context, 'Notification',
                      CupertinoIcons.square_favorites, Colors.teal),
                  clickableItem(context, 'Discover',
                      CupertinoIcons.search_circle, Colors.indigo),
                  clickableItem(context, 'About',
                      CupertinoIcons.question_circle, Colors.blue),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white)),
          const SizedBox(height: 8),
          Text(title.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    );
  }

  Widget clickableItem(
      BuildContext context, String title, IconData iconData, Color background) {
    return GestureDetector(
      onTap: () {
        // Navigate to the corresponding page when an item is clicked
        if (title == 'Videos') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => videoList()));
        } else if (title == 'Stories') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StoriesList()));
        } else if (title == 'Games') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AnimalGame()));
        } else if (title == 'Posts') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PostListWidget()));
        } else if (title == 'Notification') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationsList()));
        } else if (title == 'Challenges') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChallengesList()));
        } else if (title == 'Discover') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserListPage()));
        } else if (title == 'About') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IntroScreen()));
        }
      },
      child: itemDashboard(title, iconData, background),
    );
  }
}
