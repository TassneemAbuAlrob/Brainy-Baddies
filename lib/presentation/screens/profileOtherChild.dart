import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log/data/models/user.dart';
import 'package:log/data/services/post_service.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../data/models/post.dart';

TextEditingController profilePictureController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController textFieldController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();

File? myfile;
// Dio dio = new Dio();
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
                    print("Comment or Image detected");

                    try {
                      await PostService.commentOnPost(widget.postId,
                          context.read<AuthProvider>().user.id, newComment);

                      commentController.clear();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Comment was submitted')));
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      }
                    }
                    setState(() {
                      selectedImagepath = '';
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class profileOtherChild extends StatefulWidget {
  final String name;
  final String email;
  final String profilePicture;
  final User user;

  profileOtherChild({
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.user,
  });
  @override
  _profileOtherChildState createState() => _profileOtherChildState();
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

class _profileOtherChildState extends State<profileOtherChild> {
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> posts = [];

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Color.fromARGB(255, 252, 50, 154),
          ),
        ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.profilePicture),
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
                              nameController.text,
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
                                  widget.user.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 62, 62, 62),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: const Color.fromARGB(255, 62, 62, 62),
                                  size: 15,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  widget.user.phone,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 62, 62, 62),
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
                  child: FutureBuilder(
                    future: PostService.getCurrentUserPosts(widget.user.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Post>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }

                      List<Post> posts = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          print('Post: $post');

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
                                    postId: '', email: widget.email),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
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
