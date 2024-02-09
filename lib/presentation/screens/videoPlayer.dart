import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log/data/models/video.dart';

enum Source { Asset, Network }

class VideoPlayerPage extends StatefulWidget {
  final String title;
  final double rating;
  final String cover;
  final Video video;
  final int likesCount;

  const VideoPlayerPage({
    required this.title,
    required this.rating,
    required this.cover,
    required this.video,
    required this.likesCount,
    Key? key,
  }) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late CustomVideoPlayerController _customVideoPlayerController;

  Source currentSource = Source.Network;

  late Uri videoUri;
  // String assetVideoPath = "assets/videos/whale.mp4";

  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    videoUri = Uri.parse(widget.video.link);
    setState(() {});
    initializeVideoPlayer(currentSource);
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _sourceButtons(size),
                  CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _sourceButtons(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: size.height * .0001,
                left: size.width * .1,
                right: size.width * .02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline5,
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(
                              Icons.play_circle,
                              color: Colors.orange,
                              size: 25,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: " The details ",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        TextSpan(
                          text: "of this Video :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 180,
                        width: double.infinity,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 24,
                            top: 24,
                            right: 150,
                          ),
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(29),
                            color: Color(0xFFFFF8F9),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Color(0xFF393939)),
                                  children: [
                                    TextSpan(
                                      text: "${widget.video.title}\n",
                                      style: GoogleFonts.paprika(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  // videoRating(score: widget.rating),
                                  SizedBox(width: 10),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(3, 7),
                                          blurRadius: 20,
                                          color:
                                              Color(0xFD3D3D3).withOpacity(.5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.favorite_border_rounded,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          '${widget.likesCount}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Image.network(
                          widget.cover,
                          width: 150,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          child: Card(
            child: Container(
              height: size.height * 0.17,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage("images/cover3.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "about this video:\n${widget.video.description.toString()}",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    // Add other text widgets or elements as needed
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(
          thickness: 2,
          color: Colors.blueGrey,
          indent: 16,
          endIndent: 16,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void initializeVideoPlayer(Source source) {
    setState(() {
      isLoading = true;
    });
    VideoPlayerController _videoPlayerController;
    _videoPlayerController = VideoPlayerController.network(widget.video.link)
      ..initialize().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: _videoPlayerController);
  }
}
