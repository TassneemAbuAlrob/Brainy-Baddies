import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'stories.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final double rating;
  final String image;

  DetailsScreen({
    required this.title,
    required this.rating,
    required this.image,
  });

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height * .001,
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
                                  color: Colors.yellow,
                                  size: 25,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: " The details ",
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            TextSpan(
                              text: "of this story :",
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
                                      style:
                                          TextStyle(color: Color(0xFF393939)),
                                      children: [
                                        TextSpan(
                                          text: "$title\n",
                                          style: GoogleFonts.paprika(
                                            textStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        // TextSpan(
                                        //   text: "Author Name",
                                        //   style: TextStyle(
                                        //     color: Color(0xFF8F8F8F),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      BookRating(score: rating),
                                      SizedBox(width: 10),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(3, 7),
                                              blurRadius: 20,
                                              color: Color(0xFD3D3D3)
                                                  .withOpacity(.5),
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
                                              "1.0",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      // Expanded(
                                      //   child: RoundedButton(
                                      //     text: "Read",
                                      //     verticalPadding: 10,
                                      //   ),
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Image.asset(
                              image,
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
            Divider(
              thickness: 2,
              color: Colors.blueGrey,
              indent: 16,
              endIndent: 16,
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              child: Card(
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage("images/cover3.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// //

// class RoundedButton extends StatelessWidget {
//   final String text;
//   //final Function press;
//   final double verticalPadding;
//   final double horizontalPadding;
//   final double fontSize;

//   RoundedButton({
//     Key? key,
//     required this.text,
//     // required this.press,
//     this.verticalPadding = 16,
//     this.horizontalPadding = 30,
//     this.fontSize = 16,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       // onTap: press,
//       child: Container(
//         width: double.infinity,
//         alignment: Alignment.center,
//         margin: EdgeInsets.symmetric(vertical: 16),
//         padding: EdgeInsets.symmetric(
//             vertical: verticalPadding, horizontal: horizontalPadding),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               offset: Offset(0, 15),
//               blurRadius: 30,
//               color: Color(0xFF666666).withOpacity(.11),
//             ),
//           ],
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
