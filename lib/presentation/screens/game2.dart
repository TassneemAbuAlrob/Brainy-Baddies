import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:log/core/constants/app_contants.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/game.dart';
import 'package:provider/provider.dart';

Future<void> addScore2(String email, int score, String gameName) async {
  final url = "$baseUrl/addscore/$email";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"score": score, "gameName": gameName}),
    );

    if (response.statusCode == 201) {
      print("Score added successfully");
    } else {
      print("Failed to add score. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error adding score: $e");
  }
}

class FruitGame extends StatefulWidget {
  @override
  _FruitGameState createState() => _FruitGameState();
}

class _FruitGameState extends State<FruitGame> {
  late List<ItemModel> items;
  late List<ItemModel> items2;

  late int score;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    score = 0;

    initGame();
  }

  initGame() {
    gameOver = false;
    score = 0;

    items = [
      ItemModel(image: 'images/appleIcon.png', name: "Apple", value: "Apple"),
      ItemModel(
          image: 'images/bananaIcon.png', name: "Banana", value: "Banana"),
      ItemModel(image: 'images/grapIcon.png', name: "Grapes", value: "Grapes"),
      ItemModel(
          image: 'images/orangeIcon.png', name: "Orange", value: "Orange"),
      ItemModel(image: 'images/melonIcon.png', name: "Melon", value: "Melon"),
    ];
    items2 = List<ItemModel>.from(items);
    items.shuffle();
    items2.shuffle();
  }

  void showAlert(int currentScore) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Keep Going!',
      desc: 'Your current score is $currentScore. Try Harder!',
      btnCancelOnPress: () {},
      btnCancelText: 'OK',
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) gameOver = true;
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
          "Let's match these Fruits:",
          style: GoogleFonts.oswald(
            textStyle: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 55, 164, 241),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Text.rich(TextSpan(children: [
              TextSpan(
                text: "Score: ",
                style: TextStyle(
                  color: Color.fromARGB(255, 242, 127, 165),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              TextSpan(
                text: "$score",
                style: TextStyle(
                  color: const Color.fromARGB(255, 231, 80, 130),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
            ])),
            if (!gameOver)
              Row(
                children: <Widget>[
                  Column(
                    children: items.map((item) {
                      return Container(
                        margin: const EdgeInsets.all(15.0),
                        child: Draggable<ItemModel>(
                          data: item,
                          childWhenDragging: Image.asset(
                            item.image,
                            color: Colors.grey,
                            width: 70.0,
                            height: 70.0,
                          ),
                          feedback: Image.asset(
                            item.image,
                            width: 70.0,
                            height: 70.0,
                          ),
                          child: Image.asset(
                            item.image,
                            width: 70.0,
                            height: 70.0,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  Column(
                    children: items2.map((item) {
                      return DragTarget<ItemModel>(
                        onAccept: (receivedItem) {
                          if (item.value == receivedItem.value) {
                            setState(() {
                              items.remove(receivedItem);
                              items2.remove(item);
                              score += 10;
                              item.accepting = false;
                              if (score % 20 == 0) {
                                showAlert(score);
                              }
                            });
                          } else {
                            setState(() {
                              score -= 5;
                              item.accepting = false;
                            });
                          }
                        },
                        onLeave: (receivedItem) {
                          setState(() {
                            item.accepting = false;
                          });
                        },
                        onWillAccept: (receivedItem) {
                          setState(() {
                            item.accepting = true;
                          });
                          return true;
                        },
                        builder: (context, acceptedItems, rejectedItem) =>
                            Container(
                          color: item.accepting
                              ? Colors.red
                              : Color.fromARGB(255, 242, 127, 165),
                          height: 50,
                          width: 100,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(25.0),
                          child: Text(
                            item.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            SizedBox(height: 100),
            if (gameOver)
              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AnimalGame()),
                        );
                      },
                      child: Text("Previous Game"),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 19, 160, 199),
                        onPrimary: Colors.white,
                      ),
                      onPressed: () async {
                        initGame();
                        setState(() {});
                      },
                      child: Text("New Game"),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 17, 133, 21),
                        onPrimary: Colors.white,
                      ),
                      onPressed: () async {
                        // Simulate delay
                        addScore(context.read<AuthProvider>().user.email, score,
                            "FruitsGame");
                        print("Current Score!!!!!!!!!!!!!!!!!: $score");
                      },
                      child: Text("Submit Score"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ItemModel {
  final String name;
  final String value;
  final String image;
  bool accepting;

  ItemModel({
    required this.name,
    required this.value,
    required this.image,
    this.accepting = false,
  });
}
