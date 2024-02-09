import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/screens/story_viewer.dart';
import 'package:alaa_admin/services/story_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'create_story_screen.dart';

class Story {
  final String id;
  final String title;
  final String pdf;
  final String image;
  final List<String> interactions;
  final List<String> comments;
  final String publisher;
  final int views;
  final String publishDate;

  Story({
    required this.title,
    required this.pdf,
    required this.image,
    required this.interactions,
    required this.comments,
    required this.publisher,
    required this.views,
    required this.publishDate,
    required this.id,
  });
}

class StoriesScreen extends StatefulWidget {
  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  List<Story> stories = [];

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  Future<void> fetchStories() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:4000/api/stories'));
    if (response.statusCode == 200) {
      final List<dynamic> storyData = json.decode(response.body);
      final List<Story> storyList = storyData.map((data) {
        return Story(
          title: data['title'],
          pdf: data['pdf'] ?? '',
          image: data['image'],
          interactions: List<String>.from(data['interactions']),
          comments: List<String>.from(data['comments']),
          publisher: data['publisher'],
          views: data['views'],
          publishDate: data['publish_date'] ?? '',
          id: data['_id'],
        );
      }).toList();
      setState(() {
        stories = storyList;
      });
    }
  }

  // Function to delete a story
  Future<void> deleteStory(String id) async {
    try {
      await StoryService.deleteStory(id);
      fetchStories(); // Refresh the list after deletion
      return;
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void showDeleteConfirmationDialog(String storyId, String storyTitle) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Confirm Delete',
      desc: 'Are you sure you want to delete the story "$storyTitle"?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await deleteStory(storyId);
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        title: Text('Stories'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateStoryScreen()),
          ).then((value) {
            fetchStories();
          });
        },
        backgroundColor: heavyGreen,
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: stories.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_stories,
                    size: 50,
                    color: Colors.black26,
                  ),
                  Text(
                    'No Stories Yet',
                    style: TextStyle(fontSize: 24),
                  )
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.separated(
                itemCount: stories.length,
                separatorBuilder: ((context, index) {
                  return SizedBox(
                    height: 12.0,
                  );
                }),
                itemBuilder: (context, index) {
                  Story story = stories[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StoryViewer(story: story)));
                    },
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: story.image,
                            placeholder: (context, url) => Container(
                              height: 200,
                              color: Colors.grey,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    story.title,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDeleteConfirmationDialog(
                                      story.id, story.title);
                                },
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
