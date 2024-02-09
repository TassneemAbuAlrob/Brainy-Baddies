import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/create_story.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../providers/story_provider.dart';
import 'child_profile.dart';
import 'storiesView.dart';

TextEditingController profilePictureController = TextEditingController();
TextEditingController nameController = TextEditingController();

class CurrentChildStories extends StatefulWidget {
  @override
  _CurrentChildStoriesState createState() => _CurrentChildStoriesState();
}

class _CurrentChildStoriesState extends State<CurrentChildStories> {
  File? myfile;

  @override
  void initState() {
    super.initState();
    initializeStories();
  }

  void initializeStories() async {
    await Provider.of<StoryProvider>(context, listen: false)
        .getAllCurrentChildStories(
            userId: context.read<AuthProvider>().user.id);
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    var size = MediaQuery.of(context).size;

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/mainpage.jpg"),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: size.height * .1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Your Stories',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CreateStoryScreen()));
                        },
                        child: Icon(
                          Icons.add,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(height: 12),
                  Consumer<StoryProvider>(
                    builder: (BuildContext context, StoryProvider storyProvider,
                        Widget? child) {
                      if (storyProvider.errorState &&
                          storyProvider.errorType ==
                              StoryProviderErrorType.errorGettingStories) {
                        return Center(
                          child: Text(storyProvider.errorMessage),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            ...storyProvider.currentUserStories.map((story) {
                              return ReadingListCard(
                                image: story.image,
                                title: story.title,
                                rating: story.rating,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => StoryView(
                                            story: story,
                                          )));
                                },
                                pressDetails: () {},
                                pressRead: () {},
                              );
                            })
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//rating

class BookRating extends StatelessWidget {
  final double score;
  const BookRating({
    Key? key,
    required this.score,
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
          Icon(
            Icons.star,
            color: Color(0xFFF48A37),
            size: 15,
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
}

//rounded button

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final double verticalPadding;
  final double horizontalPadding;
  final double fontSize;

  RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    this.verticalPadding = 16,
    this.horizontalPadding = 30,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 15),
              blurRadius: 30,
              color: Color(0xFF666666).withOpacity(.11),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

//cardList

class ReadingListCard extends StatelessWidget {
  final String image;
  final String title;
  final double rating;
  final VoidCallback pressDetails;
  final VoidCallback pressRead;
  final VoidCallback onTap;

  const ReadingListCard(
      {Key? key,
      required this.image,
      required this.title,
      required this.rating,
      required this.pressDetails,
      required this.pressRead,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              child: Image.network(
                image,
                width: 100,
                height: 100,
              ),
            ),
            Positioned(
              top: 35,
              right: 10,
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                    ),
                    onPressed: () {},
                  ),
                  BookRating(score: rating),
                  IconButton(
                    icon: Icon(
                      Icons.info,
                    ),
                    onPressed: () {},
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
                    Row(children: <Widget>[
                      GestureDetector(
                        onTap: pressDetails,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 0),
                          width: 101,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                        ),
                      ),
                    ]),
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
      ),
    );
  }
}

/**
 ,
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        index: selectedIndex,
        color: Color.fromARGB(255, 55, 164, 241),
        backgroundColor: Color.fromRGBO(205, 245, 250, 0.898),
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.message,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications,
            size: 30,
            color: Colors.white,
          )
        ],
        onTap: (value) {
          if (value == 0) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: ChildProfile(),
              ),
            );
          } else if (value == 1) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ChildProfile(),
              ),
            );
          } else if (value == 2) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ChildProfile(),
              ),
            );
          } else if (value == 3) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ChildProfile(),
              ),
            );
          }
        },
      )
 */
