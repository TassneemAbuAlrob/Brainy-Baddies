import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:log/core/constants/app_contants.dart';
import 'dart:convert';

import 'package:log/presentation/screens/parent/showInterest.dart';

class Score {
  final String gameName;
  final int sumScore;

  Score({required this.gameName, required this.sumScore});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      gameName: json['gameName'],
      sumScore: json['totalScore'],
    );
  }
}

class ScoreTable extends StatefulWidget {
  final String email;

  ScoreTable({required this.email});

  @override
  _ScoreTableState createState() => _ScoreTableState();
}

class _ScoreTableState extends State<ScoreTable> {
  List<Score> scoresAnimals = [];
  List<Score> scoresFruits = [];

  @override
  void initState() {
    super.initState();
    fetchData1();
    fetchData2();
  }

  Future<void> fetchData1() async {
    final Uri url =
        Uri.parse('$baseUrl/sumOfScoresByUser/AnimalGame/${widget.email}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      print('Response Data: $responseData');

      if (responseData.isNotEmpty) {
        // Iterate over the response data array
        for (var data in responseData) {
          // Extract values from each data object
          String gameName = 'AnimalGame'; // Hardcoded for now
          int totalScore = data['totalScore'];

          setState(() {
            scoresAnimals.add(Score(gameName: gameName, sumScore: totalScore));
          });
        }
      } else {
        print('Invalid or empty response data');
        throw Exception('Invalid or empty response data');
      }
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchData2() async {
    final Uri url =
        Uri.parse('$baseUrl/sumOfScoresByUser/FruitsGame/${widget.email}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      print('Response Data: $responseData');

      if (responseData.isNotEmpty) {
        // Iterate over the response data array
        for (var data in responseData) {
          // Extract values from each data object
          String gameName = 'FruitsGame'; // Hardcoded for now
          int totalScore = data['totalScore'];

          setState(() {
            scoresFruits.add(Score(gameName: gameName, sumScore: totalScore));
          });
        }
      } else {
        print('Invalid or empty response data');
        throw Exception('Invalid or empty response data');
      }
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Your child's Scores :",
          style: GoogleFonts.oswald(
            textStyle: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 55, 164, 241),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildDataTable('AnimalGame', scoresAnimals),
          // SizedBox(height: 40),
          _buildDataTable('FruitsGame', scoresFruits),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.pink,
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInterest(email: widget.email)),
              );
            },
            child: Text("Back"),
          ),
          SizedBox(
            width: 100,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.pink,
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => ScoreTable(email: widget.email)),
              // );
            },
            child: Text("Next"),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(String gameName, List<Score> scores) {
    return Container(
      margin: EdgeInsets.only(left: 55, top: 55),
      decoration: BoxDecoration(
        border: Border.all(
            color: Color.fromRGBO(205, 245, 250, 0.898),
            width: 5), // Add border color
      ),
      child: DataTable(
        columns: [
          DataColumn(
              label: Text(
            'Game Name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          )),
          DataColumn(
              label: Text(
            'Sum Score',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          )),
        ],
        rows: scores.map((score) {
          return DataRow(
            cells: [
              DataCell(Text(
                gameName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              )),
              DataCell(Text(
                score.sumScore.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
