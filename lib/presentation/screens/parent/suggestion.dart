import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:log/core/constants/app_contants.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

final TextEditingController suggTextController = TextEditingController();

void submitSuggestion(String email, String feedbackText, double feedbackValue,
    String suggText) async {
  final String apiUrl = '$baseUrl/addSuggestion/$email';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'feedbackText': feedbackText,
        'feedbackValue': feedbackValue,
        'suggText': suggText,
      }),
    );

    if (response.statusCode == 200) {
      print('Suggestion added successfully');
    } else {
      print('Failed to add suggestion. Error: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

//icons
class addIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/suggicon.jpg',
      width: 50,
      height: 50,
    );
  }
}

class suggestion extends StatefulWidget {
  @override
  _suggestionState createState() => _suggestionState();
}

class _suggestionState extends State<suggestion> {
  var height, width;
  var myFeedbackText = "COULD BE BETTER";
  var sliderValue = 0.0;
  IconData myFeedback = FontAwesomeIcons.sadTear;
  Color myFeedbackColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(191, 158, 158, 158),
          width: width,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(),
                height: height * 0.23,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 35,
                        left: 20,
                        right: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Color.fromARGB(255, 185, 199, 27),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              addIcon(),
                              SizedBox(width: 10),
                              Text(
                                "Your\n Suggestions",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(120),
                        bottomRight: Radius.circular(120),
                      ),
                    ),
                    // height: height * 0.75,
                    width: width,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                        width: width,
                        height: height * 0.75,
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Text(
                              myFeedbackText,
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Icon(
                              myFeedback,
                              color: myFeedbackColor,
                              size: 100.0,
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Slider(
                                min: 0.0,
                                max: 10.0,
                                divisions: 5,
                                value: sliderValue,
                                activeColor: Color.fromRGBO(207, 204, 5, 1),
                                inactiveColor: Colors.blueGrey,
                                onChanged: (newValue) {
                                  setState(() {
                                    sliderValue = newValue;
                                    if (sliderValue >= 0.0 &&
                                        sliderValue <= 2.0) {
                                      myFeedback = FontAwesomeIcons.sadTear;
                                      myFeedbackColor = Colors.red;
                                      myFeedbackText = "COULD BE BETTER";
                                    }
                                    if (sliderValue >= 2.1 &&
                                        sliderValue <= 4.0) {
                                      myFeedback = FontAwesomeIcons.frown;
                                      myFeedbackColor = Colors.yellow;
                                      myFeedbackText = "BELOW AVERAGE";
                                    }
                                    if (sliderValue >= 4.1 &&
                                        sliderValue <= 6.0) {
                                      myFeedback = FontAwesomeIcons.meh;
                                      myFeedbackColor = Colors.amber;
                                      myFeedbackText = "NORMAL";
                                    }
                                    if (sliderValue >= 6.1 &&
                                        sliderValue <= 8.0) {
                                      myFeedback = FontAwesomeIcons.smile;
                                      myFeedbackColor = Colors.green;
                                      myFeedbackText = "GOOD";
                                    }
                                    if (sliderValue >= 8.1 &&
                                        sliderValue <= 10.0) {
                                      myFeedback = FontAwesomeIcons.laugh;
                                      myFeedbackColor = Colors.pink;
                                      myFeedbackText = "EXCELLENT";
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 80.0, left: 20, right: 20),
                            child: Container(
                              child: TextField(
                                controller: suggTextController,
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: 'Enter your feedback',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey),
                                  ),
                                  contentPadding: EdgeInsets.all(40.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey,
                                padding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 40.0,
                                ),
                              ),
                              onPressed: () {
                                submitSuggestion(
                                    '${context.read<AuthProvider>().user.email}',
                                    myFeedbackText,
                                    sliderValue,
                                    suggTextController.text);
                                setState(() {
                                  suggTextController.clear();
                                  myFeedbackText = "COULD BE BETTER";
                                  sliderValue = 0.0;
                                  myFeedback = FontAwesomeIcons.sadTear;
                                  myFeedbackColor = Colors.red;
                                });
                                // Show a SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Suggestion added successfully'),
                                    backgroundColor:
                                        Color.fromARGB(213, 46, 247, 76),
                                  ),
                                );
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Color(0xffffffff), fontSize: 18),
                              ),
                            ),
                          ),
                        ]))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
