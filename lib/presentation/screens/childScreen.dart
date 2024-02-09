import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Story {
  final String username;
  final String imageUrl;

  Story(this.username, this.imageUrl);
}

class childScreen extends StatefulWidget {
  @override
  _childScreenState createState() => _childScreenState();
}

class _childScreenState extends State<childScreen> {
  final List<Story> stories = [
    Story("user1", "images/user1.jpg"),
    Story("user2", "images/user2.png"),
    Story("user3", "images/user3.jpg"),
    Story("user4", "images/user4.jpg"),
    Story("user5", "images/user4.jpg"),
  ];

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
            icon: Icon(Icons.arrow_back),
            color: Color.fromARGB(255, 252, 50, 154),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Color.fromARGB(255, 252, 50, 154),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: Color.fromARGB(255, 55, 164, 241),
                  ),
                ),
              ),
              child: StoriesListView(stories: stories),
            ),
          ),
        ],
      ),
    );
  }
}

//classes
class StoriesListView extends StatelessWidget {
  final List<Story> stories;

  StoriesListView(
      {required this.stories}); // Constructor to pass stories to the widget

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final story = stories[index];
        return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned.fill(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(70),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.pink,
                                width: 3.0,
                              ),
                            ),
                            child: Image.asset(
                              story.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  story.username,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 62, 62, 62),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ));
      },
      itemExtent: 90,
      scrollDirection: Axis.horizontal,
      itemCount: stories.length,
    );
  }
}
