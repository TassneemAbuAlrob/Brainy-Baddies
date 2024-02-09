import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log/core/constants/app_contants.dart';
import 'package:log/data/models/like.dart';
import 'package:log/data/models/post.dart';
import 'package:log/data/services/post_service.dart';

import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/providers/post_provider.dart';
import 'package:http/http.dart' as http;

import 'package:log/presentation/screens/childpostList.dart';

import 'package:log/presentation/screens/welcome/welcome_screen.dart';

import 'package:provider/provider.dart';

Future<String?> getUserIdByEmail(String email) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/userID/$email'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['userId'];
    } else if (response.statusCode == 404) {
      return null; // User not found
    } else {
      throw Exception('Failed to get user ID');
    }
  } catch (error) {
    print('Error getting user ID by email: $error');
    return null;
  }
}

class childProfileForParent extends StatefulWidget {
  final String name;
  final String email;
  final String image;

  childProfileForParent({
    required this.name,
    required this.email,
    required this.image,
  });

  @override
  _childProfileForParentState createState() => _childProfileForParentState();
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

class _childProfileForParentState extends State<childProfileForParent> {
  void initState() {
    super.initState();
    initializePosts();
  }

  void initializePosts() async {
    String? userIdFuture = await getUserIdByEmail(widget.email);
    print("id for:$userIdFuture");
    print("email for:${widget.email}");

    if (userIdFuture != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await context.read<PostProvider>().getCurrentUserPosts(userIdFuture);
        // clear();
      });
    } else {
      // Handle the case when userIdFuture is null
      print('User ID is null. Handle accordingly.');
    }
  }

  //fetch likes
  Future<void> showLikesDialog(List<Like> likes) async {
    TextStyle titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.pink),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('images/cover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 25, top: 7),
                child: likes!.isEmpty
                    ? Text(
                        '\n \t \t\t\t \t\t\t\t\t\t\t No one \n\n \t\t\t\t\thas liked this post yet!!',
                        style: titleStyle,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: likes.map((like) {
                          return Column(
                            children: [
                              Text('👤 ${like.user.name}'),
                              SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ),
          ),
          title: Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 4),
              Text(
                'Likes List:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  //show comments
  Future<void> showCommentsDialog(Post post) async {
    // Fetch comments for the selected post
    final comments = post.comments;

    TextStyle titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.pink),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('images/cover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 25, top: 7),
                child: comments.isEmpty
                    ? Text(
                        '\n \t \t\t\t \t\t\t\t\t\t\t No comments \n\n \t\t\t\t\thave been posted for this post yet!!',
                        style: titleStyle,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: comments.map((comment) {
                          return Column(
                            children: [
                              Text('👤 ${comment.user.name}'),
                              Text(
                                comment.content,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                              // else if (comment['commentType'] == 'image')
                              //   Container(
                              //     width: 150,
                              //     height: 150,
                              //     decoration: BoxDecoration(
                              //       image: DecorationImage(
                              //         image:
                              //             FileImage(File(comment['comment'])),
                              //         fit: BoxFit.cover,
                              //       ),
                              //     ),
                              //   ),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ),
          ),
          title: Row(
            children: [
              Icon(Icons.comment, color: Colors.blue),
              SizedBox(width: 4),
              Text(
                'Comments List:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // int selectedIndex = 0;
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
                      margin: const EdgeInsets.only(
                        top: 100,
                        right: 20,
                      ),
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
                              Icon(
                                Icons.mail,
                                color: const Color.fromARGB(255, 62, 62, 62),
                                size: 15,
                              ),
                              SizedBox(width: 8),
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
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 40, 40, 41),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(child: Consumer<PostProvider>(
                  builder: (BuildContext context, PostProvider postProvider,
                      Widget? child) {
                    if (postProvider.errorState &&
                        postProvider.errorType ==
                            PostProviderErrorType
                                .errorGettingCurrentUserPosts) {
                      return Center(
                        child: Text('Failed to get posts'),
                      );
                    }

                    if (postProvider.currentUserPosts.isEmpty) {
                      return Center(
                        child: Text('No posts'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: postProvider.currentUserPosts.length,
                      itemBuilder: (context, index) {
                        Post post = postProvider.currentUserPosts[index];

                        return Row(
                          children: [
                            Expanded(
                              flex: 8, // Takes 80% of the width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PostContainer(
                                    post: post,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.WARNING,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Confirm Deletion',
                                    desc:
                                        'Are you sure you want to delete this post?',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async {
                                      bool deletionResult =
                                          await PostService.deletePost(post.id);
                                      if (deletionResult) {
                                        context
                                            .read<PostProvider>()
                                            .removePost(post.id);
                                        setState(() {});
                                      }
                                    },
                                  ).show();
                                },
                                child: Icon(Icons.delete, color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  showLikesDialog(post.likes);
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.favorite, color: Colors.red),
                                    Text(
                                      post.likes.length.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1, // Takes 10% of the width
                              child: InkWell(
                                onTap: () {
                                  showCommentsDialog(post);
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.comment, color: Colors.blue),
                                    Text(
                                      post.comments.length.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                )))
          ])),
        ));
  }
}
