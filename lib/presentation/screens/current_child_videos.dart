import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log/core/constants/app_contants.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/create_video.dart';
import 'package:provider/provider.dart';
import '../../data/models/video.dart';
import '../providers/category_provider.dart';
import '../providers/video_provider.dart';
import 'videoPlayer.dart';
import 'package:http/http.dart' as http;

class CurrentChildVideos extends StatefulWidget {
  CurrentChildVideos({Key? key}) : super(key: key);

  @override
  State<CurrentChildVideos> createState() => _CurrentChildVideosState();
}

class _CurrentChildVideosState extends State<CurrentChildVideos> {
  @override
  void initState() {
    super.initState();
    initializeVideos();
  }

  void initializeVideos() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<VideoProvider>(context, listen: false)
          .getAllCurrentUserVideos(
              userId: context.read<AuthProvider>().user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 152, 150, 150),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            /// Main Body
            Expanded(
              flex: 12,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Your videos List',
                    style: TextStyle(fontSize: 30),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CreateVideoScreen()));
                        },
                        child: Icon(
                          Icons.add,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Container(
                      child: Consumer<VideoProvider>(
                        builder: (BuildContext context,
                            VideoProvider videoProvider, Widget? child) {
                          if (videoProvider.errorState &&
                              videoProvider.errorType ==
                                  VideoProviderErrorType.errorGettingVideos) {
                            return Center(
                              child: Text(videoProvider.errorMessage),
                            );
                          }

                          if (videoProvider.currentUserVideos.isEmpty) {
                            return Center(
                              child: Text('No Videos Yet'),
                            );
                          }

                          return ListView.separated(
                              itemBuilder: (context, index) {
                                return ReadingListCard(
                                  title: videoProvider
                                          .currentUserVideos[index].title ??
                                      '',
                                  rating: videoProvider
                                      .currentUserVideos[index].rating,
                                  video: videoProvider.currentUserVideos[index],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 12,
                                );
                              },
                              itemCount:
                                  videoProvider.currentUserVideos.length);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom TabBar
  Widget _buildTabBar() {
    return Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget? child) {
        if (categoryProvider.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (categoryProvider.errorState &&
            categoryProvider.errorType ==
                CategoryProviderErrorType.errorGettingCategories) {
          return Center(
            child: Text(categoryProvider.errorMessage),
          );
        }

        if (categoryProvider.categories.isEmpty) {
          return Center(
            child: Text('No Categories yet'),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categoryProvider.categories.length,
          itemBuilder: (ctx, i) {
            return GestureDetector(
              onTap: () async {
                categoryProvider.changeSelectedCategoryIndex(i);
                Provider.of<VideoProvider>(context, listen: false)
                    .filterVideos(categoryProvider.categories[i]);
              },
              child: AnimatedContainer(
                margin: EdgeInsets.fromLTRB(i == 0 ? 15 : 5, 0, 5, 0),
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      12,
                    ),
                  ),
                  color: i == categoryProvider.selectedCategoryIndex &&
                          categoryProvider.selectedCategoryIndex != null
                      ? Color.fromARGB(228, 205, 245, 250)
                      : Color.fromARGB(255, 200, 193, 193),
                ),
                duration: const Duration(milliseconds: 200),
                child: Center(
                  child: Text(
                    categoryProvider.categories[i].name,
                    style: GoogleFonts.ubuntu(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: i == categoryProvider.selectedCategoryIndex &&
                              categoryProvider.selectedCategoryIndex != null
                          ? Color.fromARGB(255, 117, 114, 114)
                          : Color.fromARGB(255, 55, 164, 241),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

//App Bar
class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Expanded(
      flex: 2,
      child: Container(
        width: size.width,
        height: size.height / 3.5,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
            image: const AssetImage('images/videocover.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15.0),
              child: Text(
                "What will we watch\n Today?",
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(227, 175, 229, 236),
                  shadows: const [
                    Shadow(
                      color: Color.fromARGB(255, 7, 26, 63),
                      offset: Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadingListCard extends StatelessWidget {
  final String title;
  final double rating;
  final Video video;

  const ReadingListCard({
    Key? key,
    required this.title,
    required this.rating,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, bottom: 40),
      height: 245,
      width: 202,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 221,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(29),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 33,
                    color: Color(0xFFD3D3D3).withOpacity(.84),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 35,
            left: 0,
            child: Image.network(
              video.poster,
              width: 150,
              height: 120,
            ),
          ),
          Positioned(
            top: 35,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.favorite_border,
                    //     color: Colors.red,
                    //   ),
                    //   onPressed: () {},
                    // ),
                  ],
                ),
                videoRating(videoId: video.id),
                FutureBuilder<int>(
                  future: getLikesCount(video.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      int likesCount = snapshot.data ?? 0;
                      return Column(
                        children: <Widget>[
                          SizedBox(height: 30),
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '$likesCount Likes',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          IconButton(
                            icon: Icon(
                              Icons.play_circle_filled,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerPage(
                                    title: title,
                                    cover: video.poster,
                                    rating: rating,
                                    video: video,
                                    likesCount: likesCount,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                IconButton(
                  icon: Icon(
                    Icons.play_circle_filled,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => VideoPlayerPage(
                    //       title: title,
                    //       cover: video.poster,
                    //       rating: rating,
                    //       video: video,
                    //       likesCount: snapshot.data ?? 0,
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 160,
            child: Container(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 0),
                          width: 101,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        style: TextStyle(color: Color(0xFF393939)),
                        children: [
                          TextSpan(
                            text: "$title\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<int> getLikesCount(String videoId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/videos/$videoId/likes/count'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final int likesCount = data['likesCount'];
        return likesCount;
      } else {
        throw Exception('Failed to load likes count');
      }
    } catch (error) {
      print('Error getting likes count: $error');
      throw error;
    }
  }
}

//rating

class videoRating extends StatelessWidget {
  final String videoId;

  videoRating({Key? key, required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: getVideoRating(videoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          double videoRating = (snapshot.data ?? 0).toDouble();
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 7),
                  blurRadius: 20,
                  color: Color(0xFD3D3D3).withOpacity(.5),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Color(0xFFF48A37),
                  size: 15,
                ),
                SizedBox(height: 5),
                Text(
                  "$videoRating",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  static Future<double> getVideoRating(String videoId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/videos/$videoId/rating'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final double rating = double.parse(data['rating'].toString());
        return rating;
      } else {
        throw Exception('Failed to load video rating');
      }
    } catch (error) {
      print('Error getting video rating: $error');
      throw error;
    }
  }
}
