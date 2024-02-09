import 'dart:convert';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:log/core/constants/app_contants.dart';
import 'package:log/data/services/post_service.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/providers/post_provider.dart';
import 'package:provider/provider.dart';

import '../../data/models/post.dart';

File? myfile;
bool isCommentSectionVisible = false;
String? selectedImagepath;
final picker = ImagePicker();

class CommentSectionWidget extends StatefulWidget {
  final String postId;
  final String email; // Add this line

  CommentSectionWidget({required this.postId, required this.email});

  @override
  _CommentSectionWidgetState createState() => _CommentSectionWidgetState();
}

class _CommentSectionWidgetState extends State<CommentSectionWidget> {
  TextEditingController commentController = TextEditingController();

  selectimagefromGallery() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display Existing Comments
        Container(
          height: 50, // Adjust the height as needed
        ),

// Input Field for Adding New Comment
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                  ),
                  controller: commentController,
                ),
              ),

              // Input Field for Adding New Comment
              ElevatedButton(
                onPressed: () async {
                  selectedImagepath = await selectimagefromGallery();
                  print("image path");
                  print(selectedImagepath);
                  if (selectedImagepath != null) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Image selected')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('NO Image selected')),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  final newComment = commentController.text;
                  if (newComment.isNotEmpty || selectedImagepath != '') {
                    // Call the commentOnPost function
                    PostService.commentOnPost(
                      widget.postId,
                      context.read<AuthProvider>().user.id,
                      newComment,
                    );

                    commentController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Comment was submitted')),
                    );

                    setState(() {
                      selectedImagepath = '';
                    });
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

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

class childpostList extends StatefulWidget {
  final String email;

  childpostList({
    required this.email,
  });
  @override
  // ignore: library_private_types_in_public_api
  _childpostListState createState() => _childpostListState();
}

class _childpostListState extends State<childpostList> {
  @override
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
        try {
          // Call the method to update currentUserPosts
          await context.read<PostProvider>().getCurrentUserPosts(userIdFuture);

          if (context.read<PostProvider>().currentUserPosts.isNotEmpty) {
            setState(() {});
          } else {
            print('No posts available');
          }
        } catch (error) {
          print('Error getting user posts: $error');
        }
      });
    } else {
      print('User ID is null. Handle accordingly.');
    }
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
                        "The Post :",
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
                          "Let's see What HE/She Share :)",
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

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 8, // Takes 80% of the width
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      onTap: () {
                                        addLikeToPost(post.id);
                                      },
                                      child: Column(
                                        children: [
                                          Icon(Icons.favorite,
                                              color: Colors.red),
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
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isCommentSectionVisible = true;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Icon(Icons.comment,
                                              color: Colors.blue),
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
                                  ),
                                ],
                              ),

                              // Display the comment section using Visibility widget
                              Visibility(
                                visible: isCommentSectionVisible,
                                child: CommentSectionWidget(
                                    postId: post.id,
                                    email: context
                                        .read<AuthProvider>()
                                        .user
                                        .email),
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

  void addLikeToPost(String id) async {
    try {
      String userId = context.read<AuthProvider>().user.id;
      await PostService.likePost(id, userId);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Post is liked')));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

///post

class PostContainer extends StatefulWidget {
  final Post post;

  PostContainer({required this.post});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              // Align text to the left
              children: [
                Text(
                  widget.post.textContent,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                Text(
                  formatDate(widget.post.date),
                  style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(255, 90, 163, 214),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatDate(String inputDate) {
    // Assuming the input date is in the format 'yyyy-MM-ddTHH:mm:ss'
    final DateTime dateTime = DateTime.parse(inputDate);

    final String day = dateTime.day.toString().padLeft(2, '0');
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String year = dateTime.year.toString();
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');

    final formattedDate = '$day-$month-$year $hour:$minute';

    return formattedDate;
  }
}
