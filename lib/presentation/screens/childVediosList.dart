import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log/core/constants/app_contants.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../data/models/video.dart';
import '../providers/category_provider.dart';
import '../providers/video_provider.dart';
import 'videoPlayer.dart';
import 'package:http/http.dart' as http;
import 'package:rate_my_app/rate_my_app.dart';

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

class childVediosList extends StatefulWidget {
  // childVediosList({Key? key}) : super(key: key);
  final String email;

  childVediosList({
    required this.email,
  });

  @override
  State<childVediosList> createState() => _childVediosListState();
}

class _childVediosListState extends State<childVediosList> {
  @override
  void initState() {
    super.initState();
    initializeVideos();
  }

  void initializeVideos() async {
    String? userIdFuture = await getUserIdByEmail(widget.email);
    print("userId before addPostFrameCallback: $userIdFuture");

    // Store the context in a variable
    BuildContext contextVar = context;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Use the stored contextVar here
      print("userId in addPostFrameCallback: $userIdFuture");
      await Provider.of<VideoProvider>(contextVar, listen: false)
          .getAllCurrentUserVideos(userId: userIdFuture!);
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
                    ' videos List',
                    style: TextStyle(fontSize: 30),
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

  const ReadingListCard(
      {Key? key,
      required this.title,
      required this.rating,
      required this.video})
      : super(key: key);
  void likeVideo(BuildContext context, String userId, String videoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/video/$videoId/like'),
        body: {'userId': userId},
      );

      if (response.statusCode == 200) {
        print('Video Liked Successfully');
        showSuccessDialog(context);
      } else if (response.statusCode == 400) {
        print('Video Already Liked');
        showInfoDialog(context, 'Video Already Liked');
      } else {
        print('Failed to like the video');
        showErrorDialog(context, 'Failed to like the video');
      }
    } catch (error) {
      print('Error liking the video: $error');
      showErrorDialog(context, 'Error liking the video');
    }
  }

  void showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Success',
      desc: 'Video Liked Successfully!',
      btnOkText: 'Ok',
      btnOkOnPress: () {},
    )..show();
  }

  void showInfoDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Info',
      desc: message,
      btnOkText: 'Ok',
      btnOkOnPress: () {},
    )..show();
  }

  void showErrorDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Error',
      desc: message,
      btnOkText: 'Ok',
      btnOkOnPress: () {},
    )..show();
  }

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
                videoRating(score: rating, video: video),
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
                          // SizedBox(height: 70),
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              likeVideo(
                                  context,
                                  context.read<AuthProvider>().user.id,
                                  video.id);
                              print("video ID:${video.id}");
                            },
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
  final double score;
  final Video video;
  const videoRating({
    Key? key,
    required this.score,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            onPressed: () {
              _showRatingDialog(context);
            },
          ),
          SizedBox(height: 5),
          Text(
            "$score",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showRatingDialog(BuildContext context) async {
    final _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 3,
      minLaunches: 7,
      remindDays: 2,
      remindLaunches: 5,
    );

    await _rateMyApp.init();

    _rateMyApp.showStarRateDialog(
      context,
      title: 'Did you benefit from watching this video?',
      message: 'Please leave a rating!',
      dialogStyle: DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20.0),
      ),
      starRatingOptions: StarRatingOptions(),
      actionsBuilder: (context, score) {
        return [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              rateVideo(context, video.id, score!);

              print('User gave a rating of $score stars');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            child: Text('Submit'),
          ),
        ];
      },
    );
  }

  Future<void> rateVideo(
      BuildContext context, String videoId, double rating) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/videos/$videoId/rate'),
        body: {'rating': rating.toString()},
      );

      if (response.statusCode == 200) {
        print('Video Rated Successfully');
        // showSuccessDialog(context);
      } else if (response.statusCode == 400) {
        print('Invalid rating value');
        // showInfoDialog(context, 'Invalid rating value');
      } else if (response.statusCode == 404) {
        print('Video not found');
        // showInfoDialog(context, 'Video not found');
      } else {
        print('Failed to rate the video');
        // showErrorDialog(context, 'Failed to rate the video');
      }
    } catch (error) {
      print('Error rating the video: $error');
      // showErrorDialog(context, 'Error rating the video');
    }
  }
}
