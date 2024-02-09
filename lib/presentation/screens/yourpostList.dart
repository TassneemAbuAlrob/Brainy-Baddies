import 'dart:convert';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:log/data/services/post_service.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/providers/post_provider.dart';
import 'package:provider/provider.dart';

import '../../data/models/like.dart';
import '../../data/models/post.dart';
import 'childPost.dart';

TextEditingController profilePictureController = TextEditingController();
TextEditingController nameController = TextEditingController();

class yourpostList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _yourpostListState createState() => _yourpostListState();
}

class _yourpostListState extends State<yourpostList> {
  @override
  void initState() {
    super.initState();
    initializePosts();
  }

  void initializePosts() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<PostProvider>()
          .getCurrentUserPosts(context.read<AuthProvider>().user.id);
    });
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage('images/post.jpg'),
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
                        "Your Post :",
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
                          "Let's see What you Share :)",
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => childPost()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[800],
                  minimumSize: Size(100, 40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_circle_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Add Post', style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
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
                          child: Text('No post'),
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
                            ],
                          );
                        },
                      );
                    },
                  )))
            ],
          ),
        ),
      )),
    );
  }
}

class PostContainer extends StatefulWidget {
  final Post post;

  PostContainer({required this.post});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 250,
      width: MediaQuery.of(context).size.width,
      color: Color.fromARGB(255, 255, 252, 252),
      child: Card(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.textContent,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              if (widget.post.imageContent != null)
                Image.network(widget.post.imageContent!),
              if (widget.post.video != null)
                SizedBox(
                  height: 200,
                  child: VideoPlayer(
                    VideoPlayerController.network(widget.post.video!)
                      ..initialize().then((value) {
                        setState(() {});
                      })
                      ..play(),
                  ),
                ),
              Divider(thickness: 1),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      widget.post.likes.length.toString() + ' Likes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 145, top: 5),
                    child: Text(
                      widget.post.comments.length.toString() + ' Comments',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1),
              Row(
                children: [
                  Container(
                    child: MaterialButton(
                      onPressed: () {
                        showLikesDialog(widget.post.likes);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border, color: Colors.red),
                          SizedBox(width: 5),
                          Text(
                            "Favorite",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 70),
                    child: MaterialButton(
                      onPressed: () {
                        showCommentsDialog(widget.post);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.comment, color: Colors.blue),
                          SizedBox(width: 5),
                          Text(
                            "Comment",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 250, top: 15),
                child: MaterialButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Confirm Deletion',
                      desc: 'Are you sure you want to delete this post?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        bool deletionResult =
                            await PostService.deletePost(widget.post.id);
                        if (deletionResult) {
                          context
                              .read<PostProvider>()
                              .removePost(widget.post.id);
                          setState(() {});
                        }
                      },
                    ).show();
                  },
                  child: Icon(Icons.delete, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
