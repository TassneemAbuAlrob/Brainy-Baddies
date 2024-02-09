import 'package:flutter/material.dart';
import 'package:log/data/models/post.dart';
import 'package:log/data/services/post_service.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class PostListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        backgroundColor: Colors.grey,
        title: Text(
          'All Posts',
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: PostService.getAllPosts(authProvider.user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PostWidget(post: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Post post;

  PostWidget({required this.post});

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
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.user.image),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 100),
                        child: Text(
                          post.user.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 50, top: 5),
                        child: Text(
                          post.date,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 75, bottom: 10),
                    child: IconButton(
                      icon: Icon(
                        Icons.share,
                        size: 15,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 12,
                  top: 14,
                  bottom: 14,
                ),
                child: Text(
                  post.textContent,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      post.likes.length.toString() + ' Likes',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 145, top: 5),
                    child: Text(
                      post.comments.length.toString() + ' Comments',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1),
              Row(
                children: [
                  Container(
                    child: MaterialButton(
                      onPressed: () {},
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
                    padding: EdgeInsets.only(
                      left: 80,
                    ),
                    child: MaterialButton(
                      onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}

void addLikeToPost(BuildContext context, String id) async {
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
