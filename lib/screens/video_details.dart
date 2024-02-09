import 'package:alaa_admin/screens/videos_list.dart';
import 'package:alaa_admin/services/video_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../helpers/scheme.dart';

class VideoDetailsScreen extends StatefulWidget {
  final VideoItem videoItem;

  VideoDetailsScreen({required this.videoItem});

  @override
  _VideoDetailsScreenState createState() => _VideoDetailsScreenState();
}

class _VideoDetailsScreenState extends State<VideoDetailsScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'http://10.0.2.2:4000' + widget.videoItem.url.split('4000')[1],
    )..initialize().then((_) {
        setState(() {
          _controller.pause();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Video Details'),
        backgroundColor: AppColors.scaffoldColor, // Apply your color scheme
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            // aspectRatio: _controller.value.aspectRatio,
            aspectRatio: 3 / 4,
            child: VideoPlayer(_controller),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                      _isPlaying = !_isPlaying;
                    });
                  },
                  color: AppColors.primaryColor, // Apply your color scheme
                ),
                IconButton(
                  icon: Icon(
                    Icons.stop,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.seekTo(Duration(seconds: 0));
                      _controller.pause();
                      _isPlaying = false;
                    });
                  },
                  color: AppColors.dangerColor, // Apply your color scheme
                ),

                // IconButton(
                //   icon: Icon(Icons.delete_forever,size: 30,),
                //   onPressed: () async{
                //     try{
                //       await VideoService.deleteVideo(widget.videoItem.id);
                //       Navigator.pop(context);
                //     }catch(error){
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text(error.toString()))
                //       );
                //     }
                //   },
                //   color: AppColors.dangerColor, // Apply your color scheme
                // ),
                IconButton(
                  icon: Icon(Icons.delete_forever, size: 30),
                  onPressed: () {
                    showDeleteConfirmationDialog();
                  },
                  color: AppColors.dangerColor,
                ),
              ],
            ),
          ),
          // Video description
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.title),
                    title: Text(
                      'Title',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      widget.videoItem.title,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors
                              .textDarkColor), // Apply your color scheme
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.description),
                    title: Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      widget.videoItem.description,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors
                              .textDarkColor), // Apply your color scheme
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.scale,
      title: 'Confirm Delete',
      desc: 'Are you sure you want to delete this video?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await deleteVideo();
        Navigator.pop(context); // Navigate back to the previous screen
      },
    ).show();
  }

  Future<void> deleteVideo() async {
    try {
      await VideoService.deleteVideo(widget.videoItem.id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete video")),
      );
    }
  }
}
