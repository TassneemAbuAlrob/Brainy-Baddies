import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:log/core/constants/app_contants.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/game2.dart';
import 'package:provider/provider.dart';

Future<void> addScore(String email, int score, String gameName) async {
  final url = "$baseUrl/addscore/$email";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"score": score, "gameName": gameName}),
    );

    if (response.statusCode == 201) {
      print("Score added successfully");
      print("Response Body: ${response.body}");
    } else {
      print("Failed to add score. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error adding score: $e");
  }
}

class AnimalGame extends StatefulWidget {
  @override
  _AnimalGameState createState() => _AnimalGameState();
}

class _AnimalGameState extends State<AnimalGame> {
  late List<ItemModel> itemss;
  late List<ItemModel> itemss2;

  late int score;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    score = 0;

    initGame();
  }

  initGame() {
    score = 0;

    gameOver = false;
    itemss = [
      ItemModel(icon: FontAwesomeIcons.crow, name: "Bird", value: "Bird"),
      ItemModel(icon: FontAwesomeIcons.dog, name: "Dog", value: "dog"),
      ItemModel(icon: FontAwesomeIcons.cat, name: "Cat", value: "Cat"),
      ItemModel(icon: FontAwesomeIcons.fish, name: "Fish", value: "Fish"),
      ItemModel(icon: FontAwesomeIcons.horse, name: "Horse", value: "Horse"),
    ];
    itemss2 = List<ItemModel>.from(itemss);
    itemss.shuffle();
    itemss2.shuffle();
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
    if (itemss.length == 0) gameOver = true;
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
          "Let's match these animals:",
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
                    children: itemss.map((item) {
                      return Container(
                        margin: const EdgeInsets.all(25.0),
                        child: Draggable<ItemModel>(
                          data: item,
                          childWhenDragging: Icon(
                            item.icon,
                            color: Colors.grey,
                            size: 50.0,
                          ),
                          feedback: Icon(
                            item.icon,
                            color: Color.fromARGB(255, 55, 164, 241),
                            size: 50,
                          ),
                          child: Icon(
                            item.icon,
                            color: Color.fromARGB(255, 55, 164, 241),
                            size: 50,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  Column(
                    children: itemss2.map((item) {
                      return DragTarget<ItemModel>(
                        onAccept: (receivedItem) {
                          if (item.value == receivedItem.value) {
                            setState(() {
                              itemss.remove(receivedItem);
                              itemss2.remove(item);
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
                        primary: Color.fromARGB(255, 19, 160, 199),
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FruitGame()),
                        );
                      },
                      child: Text("Next Game"),
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
                            "AnimalGame");
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
  final IconData icon;
  bool accepting;

  ItemModel({
    required this.name,
    required this.value,
    required this.icon,
    this.accepting = false,
  });
}
