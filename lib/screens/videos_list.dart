import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../helpers/scheme.dart';
import 'create_video.dart';
import 'video_details.dart'; // Import the VideoDetailsScreen

class VideosListScreen extends StatefulWidget {
  @override
  State<VideosListScreen> createState() => _VideosListScreenState();
}

class _VideosListScreenState extends State<VideosListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,

      appBar: AppBar(
        title: Text('Videos'),

        backgroundColor: screenBackgroundColor, // Apply your color scheme
      ),
      body: VideoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateVideoScreen())).then((value){
            setState(() {

            });
          });
        },
        shape: CircleBorder(),
        child: Icon(Icons.add,size: 30,color: Colors.white,),
        backgroundColor: heavyGreen, // Apply your color scheme
      ),
    );
  }
}

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<VideoItem> videos = [];

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:4000/api/videos'));

    if (response.statusCode == 200) {
      final List<dynamic> videoData = jsonDecode(response.body);

      setState(() {
        videos = videoData.map((data) {
          return VideoItem(
            title: data['title'],
            url: 'http://10.0.2.2:4000' + data['link'].split('4000')[1],
            description: data['description'],
            id: data['_id']
          );
        }).toList();
      });
    } else {
      // Handle API request errors
      print('Failed to fetch videos: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return Center(
        child: Text('No Videos Yet',style: TextStyle(
          fontSize: 24
        ),),
      );
    } else {
      return ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoItemCard(videoItem: videos[index]);
        },
      );
    }
  }
}

class VideoItem {
  final String id;
  final String title;
  final String description;
  final String url;

  VideoItem({required this.title,required this.url,required this.description,required this.id});
}

class VideoItemCard extends StatelessWidget {
  final VideoItem videoItem;

  VideoItemCard({required this.videoItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoDetailsScreen(videoItem: videoItem)));
      },
      child: Container(
                      decoration: BoxDecoration(
                color: Color(0xFFece3de),
                borderRadius: BorderRadius.circular(12.0)
              ),
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: _generateThumbnail(videoItem.url),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      image: DecorationImage(
                        image: FileImage(File(snapshot.data!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey, // Placeholder color
                  );
                }
              },
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                videoItem.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDarkColor, // Apply your color scheme
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _generateThumbnail(String videoUrl) async {
    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: 'http://10.0.2.2:4000' + videoUrl.split('4000')[1],
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
      );

      print(thumbnailPath);
      return thumbnailPath!;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return ''; // Return an empty string as a fallback
    }
  }
}
