import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:log/core/constants/app_contants.dart';

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

class setInterst extends StatefulWidget {
  final String email;

  setInterst({required this.email});
  @override
  _setInterstState createState() => _setInterstState();
}

class _setInterstState extends State<setInterst> {
  var height, width;
  var sliderValue = 0.0;
  var sliderValue2 = 0.0;
  var sliderValue3 = 0.0;

  Future<void> addInterestToServer(String category, double value) async {
    try {
      Map<String, dynamic> requestData = {
        "percentValue": value.toString(),
        "catgName": category,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/addInterest/${widget.email}'),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Interest added successfully for $category");
      } else {
        print("Error adding interest for $category: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
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
                            addIcon(),
                            SizedBox(width: 10),
                            Text(
                              "Your child's\n \t \t \tInterests",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.grey,
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
                  child: Container(
                      width: width,
                      height: height * 0.75,
                      child: Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 50, top: 50),
                          child: Row(
                            children: [
                              Text(
                                'Religious Interest:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Container(
                                child: Text(
                                  sliderValue.toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color.fromRGBO(207, 204, 5, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Slider(
                              min: 0.0,
                              max: 100.0,
                              divisions: 10,
                              value: sliderValue,
                              activeColor: Color.fromRGBO(207, 204, 5, 1),
                              inactiveColor: Colors.blueGrey,
                              onChanged: (newValue) {
                                setState(() {
                                  sliderValue = newValue;
                                  if (sliderValue >= 0.0 &&
                                      sliderValue <= 20.0) {}
                                  if (sliderValue >= 2.1 &&
                                      sliderValue <= 40.0) {}
                                  if (sliderValue >= 4.1 &&
                                      sliderValue <= 60.0) {}
                                  if (sliderValue >= 6.1 &&
                                      sliderValue <= 80.0) {}
                                  if (sliderValue >= 8.1 &&
                                      sliderValue <= 100.0) {}
                                });
                              },
                            ),
                          ),
                        ),

                        ///second type:
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Row(
                            children: [
                              Text(
                                'Scientific Interest:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Container(
                                child: Text(
                                  sliderValue2.toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color.fromRGBO(207, 140, 5, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Slider(
                              min: 0.0,
                              max: 100.0,
                              divisions: 10,
                              value: sliderValue2,
                              activeColor: Color.fromRGBO(207, 140, 5, 1),
                              inactiveColor: Colors.blueGrey,
                              onChanged: (newValue) {
                                setState(() {
                                  sliderValue2 = newValue;
                                  if (sliderValue2 >= 0.0 &&
                                      sliderValue2 <= 20.0) {}
                                  if (sliderValue2 >= 2.1 &&
                                      sliderValue2 <= 40.0) {}
                                  if (sliderValue2 >= 4.1 &&
                                      sliderValue2 <= 60.0) {}
                                  if (sliderValue2 >= 6.1 &&
                                      sliderValue2 <= 80.0) {}
                                  if (sliderValue2 >= 8.1 &&
                                      sliderValue2 <= 100.0) {}
                                });
                              },
                            ),
                          ),
                        ),

                        ///third type:
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Row(
                            children: [
                              Text(
                                'Cultural Interest:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Container(
                                child: Text(
                                  sliderValue3.toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color.fromRGBO(158, 212, 87, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Slider(
                              min: 0.0,
                              max: 100.0,
                              divisions: 10,
                              value: sliderValue3,
                              activeColor: Color.fromRGBO(158, 212, 87, 1),
                              inactiveColor: Colors.blueGrey,
                              onChanged: (newValue) {
                                setState(() {
                                  sliderValue3 = newValue;
                                  if (sliderValue3 >= 0.0 &&
                                      sliderValue3 <= 20.0) {}
                                  if (sliderValue3 >= 2.1 &&
                                      sliderValue3 <= 40.0) {}
                                  if (sliderValue3 >= 4.1 &&
                                      sliderValue3 <= 60.0) {}
                                  if (sliderValue3 >= 6.1 &&
                                      sliderValue3 <= 80.0) {}
                                  if (sliderValue3 >= 8.1 &&
                                      sliderValue3 <= 100.0) {}
                                });
                              },
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
                              showConfirmationDialog();
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
    );
  }

  void showConfirmationDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Confirmation',
      desc: 'Are you sure you want to submit?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        addInterestToServer("Religious", sliderValue);
        addInterestToServer("Scientific", sliderValue2);
        addInterestToServer("Cultural", sliderValue3);
      },
    )..show();
  }
}
