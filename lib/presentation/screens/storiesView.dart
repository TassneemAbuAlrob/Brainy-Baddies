import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log/data/models/story.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StoryView extends StatelessWidget {
  final Story story;
  StoryView({Key? key, required this.story}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Color.fromARGB(0, 159, 157, 157),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.black,
              ),
            ),
            const MyAppBar(),

            /// Main Body
            Expanded(
              flex: 40,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),

                  /// TapBar
                  // Expanded(flex: 1, child: _buildTabBar()),
                  const SizedBox(
                    height: 25,
                  ),

                  Expanded(
                    flex: 9,
                    child: Container(
                      child: SfPdfViewer.network(
                        story.file
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

  // /// Custom TabBar
  // Widget _buildTabBar() {
  //   return ListView.builder(
  //     physics: const BouncingScrollPhysics(),
  //     scrollDirection: Axis.horizontal,
  //     itemCount: 2,
  //     itemBuilder: (ctx, i) {
  //       return Container(

          

  //         color: Colors.red,
  //       );
  //     },
  //   );
  // }

  //story type1

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
      flex: 3,
      child: Container(
        width: size.width,
        height: size.height / 3.5,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.darken),
            image: const AssetImage('images/storiescover.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 12.0),
          child: Text(
            "What will we read Today?",
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
      ),
    );
  }
}
// controller

// class AppController extends GetxController {
//   var selectedIndex = 0.obs;
//   var flag = 0.obs;

//   List<String> orders = [
//     "Religious stories",
//     "Scientific stories",
//     "Cultural stories",
//   ];
// }

//stories
// class ReadingListCard extends StatelessWidget {
//   final String image;
//   final String title;
//   final double rating;

//   const ReadingListCard({
//     Key? key,
//     required this.image,
//     required this.title,
//     required this.rating,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: 24, bottom: 40),
//       height: 245,
//       width: 202,
//       child: Stack(
//         children: <Widget>[
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 221,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(29),
//                 boxShadow: [
//                   BoxShadow(
//                     offset: Offset(0, 10),
//                     blurRadius: 33,
//                     color: Color(0xFFD3D3D3).withOpacity(.84),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Image.asset(
//             image,
//             width: 150,
//           ),
//           Positioned(
//             top: 35,
//             right: 10,
//             child: Column(
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(
//                     Icons.favorite_border,
//                   ),
//                   onPressed: () {},
//                 ),
//                 BookRating(score: rating),
//                 IconButton(
//                   icon: Icon(
//                     Icons.info,
//                   ),
//                   onPressed: () {
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) => DetailsScreen(
//                     //       title: title,
//                     //       image: image,
//                     //       rating: rating,
//                     //     ),
//                     //   ),
//                     // );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 160,
//             child: Container(
//               height: 85,
//               width: 202,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Spacer(),
//                   Row(children: <Widget>[
//                     GestureDetector(
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 0),
//                         width: 101,
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                         alignment: Alignment.center,
//                       ),
//                     ),
//                   ]),
//                   Padding(
//                     padding: EdgeInsets.only(left: 24),
//                     child: RichText(
//                       maxLines: 2,
//                       text: TextSpan(
//                         style: TextStyle(color: Color(0xFF393939)),
//                         children: [
//                           TextSpan(
//                             text: "$title\n",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// //rating

// class BookRating extends StatelessWidget {
//   final double score;
//   const BookRating({
//     Key? key,
//     required this.score,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(3, 7),
//             blurRadius: 20,
//             color: Color(0xFD3D3D3).withOpacity(.5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: <Widget>[
//           Icon(
//             Icons.star,
//             color: Color(0xFFF48A37),
//             size: 15,
//           ),
//           SizedBox(height: 5),
//           Text(
//             "$score",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
