import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:log/core/constants/app_contants.dart';
import 'package:log/presentation/screens/parent/perantDash.dart';
import 'package:log/presentation/screens/sumScore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;

class ShowInterest extends StatefulWidget {
  final String email;

  ShowInterest({required this.email});

  @override
  _ShowInterestState createState() => _ShowInterestState();
}

class _ShowInterestState extends State<ShowInterest> {
  Map<String, dynamic> interestData = {
    'religious': 0.0,
    'scientific': 0.0,
    'cultural': 0.0,
  };

  @override
  void initState() {
    super.initState();
    // Fetch interests when the page is opened
    fetchInterests();
  }

  Future<void> fetchInterests() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getInterests/${widget.email}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body)['interests'];

        // Parse values as doubles before updating interestData
        final Map<String, double> parsedData = {};
        responseData.forEach((key, value) {
          parsedData[key] = double.tryParse(value.toString()) ?? 0.0;
        });

        setState(() {
          interestData = parsedData;
        });
      } else {
        // Handle errors
        print('Failed to fetch interests. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error fetching interests: $error');
    }
  }

  Widget _buildCircularIndicator(String label, double percent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularPercentIndicator(
              animation: true,
              animationDuration: 10000,
              radius: 100,
              lineWidth: 40,
              percent: percent,
              progressColor: Color.fromARGB(255, 53, 202, 236),
              backgroundColor: Color.fromARGB(226, 160, 235, 245),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            Text(
              '$label: ${(percent * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 8, 125, 151),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 240),
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
          "Your child's interests :",
          style: GoogleFonts.oswald(
            textStyle: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 55, 164, 241),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularIndicator(
                    "Religious", interestData['religious'] / 100),
                SizedBox(height: 20),
                _buildCircularIndicator(
                    "Scientific", interestData['scientific'] / 100),
                SizedBox(height: 20),
                _buildCircularIndicator(
                    "Cultural", interestData['cultural'] / 100),
              ],
            ),
          ),
        ),
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
                MaterialPageRoute(builder: (context) => PerantDash()),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScoreTable(email: widget.email)),
              );
            },
            child: Text("Next"),
          ),
        ],
      ),
    );
  }
}
