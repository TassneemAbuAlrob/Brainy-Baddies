import 'dart:convert';

import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/suggestion.dart';
import 'package:alaa_admin/providers/home_provider.dart';
import 'package:alaa_admin/screens/ages_list.dart';
import 'package:alaa_admin/screens/categories_list.dart';
import 'package:alaa_admin/screens/quiz_screen.dart';
import 'package:alaa_admin/screens/stories_screen.dart';
import 'package:alaa_admin/screens/users_list.dart';
import 'package:alaa_admin/screens/videos_list.dart';
import 'package:alaa_admin/widgets/shared_drawer.dart';
import 'package:alaa_admin/widgets/statistic_box.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchMonthlyJoinData() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:4000/api/monthlyJoinData'));

  if (response.statusCode == 200) {
    print('Monthly join data response body: ${response.body}');

    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load monthly join data. Unexpected response format.');
  }
}

class ControlPanelHome extends StatefulWidget {
  const ControlPanelHome({Key? key});

  @override
  State<ControlPanelHome> createState() => _ControlPanelHomeState();
}

class _ControlPanelHomeState extends State<ControlPanelHome> {
  List<SuggestionModel> suggestions = [];
  Map<String, dynamic>? monthlyJoinData;

  void fetchSuggestions() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:4000/api/getSuggestions'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        suggestions =
            jsonResponse.map((data) => SuggestionModel.fromJson(data)).toList();
      });
    } else {
      print('Failed to load suggestions');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSuggestions();

    initializeCounts();
    fetchMonthlyJoinDataFromBackend();
  }

  void initializeCounts() async {
    await Provider.of<HomeProvider>(context, listen: false).initializeCounts();
  }

  Future<void> fetchMonthlyJoinDataFromBackend() async {
    try {
      final data = await fetchMonthlyJoinData();

      // Extract labels and data from the response
      final labels = List<String>.from(data['labels']);
      final dataValues =
          List<double>.from(data['data'].map((value) => value.toDouble()));

      // Create a Map from labels and data
      final dataMap = Map<String, double>.fromIterables(labels, dataValues);

      setState(() {
        monthlyJoinData = dataMap;
      });
    } catch (error, stackTrace) {
      print('Error fetching monthly join data: $error');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SharedDrawer(),
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<HomeProvider>(
        builder:
            (BuildContext context, HomeProvider homeProvider, Widget? child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
                  color: AppColors.headerColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar.png'),
                            radius: 40,
                          ),
                          SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'John Doe',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            size: 32,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 12),
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8.0),
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatisticBox(
                            color: Color(0xFFf7a793), // Deep blue
                            text: 'Users',
                            count: homeProvider.usersCount,
                            route: UsersList(),
                            boxIcon: Icons.person,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: StatisticBox(
                            color: Color(0xFFb0cabd), // Pink
                            text: 'Stories',
                            count: homeProvider.storiesCount,
                            route: StoriesScreen(),
                            boxIcon: Icons.book,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: StatisticBox(
                            color: Color(0xFF585a6b), // Grey
                            text: 'Videos',
                            count: homeProvider.videosCount,
                            route: VideosListScreen(),
                            boxIcon: Icons.video_file,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: StatisticBox(
                            color: Color(0xFFece3de), // Grey
                            text: 'Quiz',
                            count: homeProvider.quizzesCount,
                            route: QuizScreen(),
                            boxIcon: Icons.question_mark,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: StatisticBox(
                            color: Colors.black12, // Grey
                            text: 'Categories',
                            count: homeProvider.categoriesCount,
                            route: CategoriesList(),
                            boxIcon: Icons.category,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: StatisticBox(
                            color: Colors.black12, // Grey
                            text: 'Ages',
                            count: homeProvider.agesCount,
                            route: AgesList(),
                            boxIcon: Icons.numbers,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Parent Suggestions:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 2),
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      height: 180,
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                  label: Text(
                                      ''), // Empty space for the delete icon column
                                ),
                                DataColumn(
                                  label: Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 108, 156, 61),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Feedback Text',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Feedback Value',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 108, 156, 61),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Suggestion Text',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows: suggestions.map((suggestion) {
                                return DataRow(cells: [
                                  DataCell(IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color:
                                          Color.fromRGBO(238, 135, 66, 0.996),
                                    ),
                                    onPressed: () {
                                      showDeleteConfirmationDialog(
                                          suggestion.id);
                                    },
                                  )),
                                  DataCell(Text(suggestion.email)),
                                  DataCell(Text(suggestion.feedbackText)),
                                  DataCell(Text(
                                      suggestion.feedbackValue.toString())),
                                  DataCell(Text(suggestion.suggText)),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Monthly Registration Overview:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Color(0xFFece3de),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: monthlyJoinData != null
                          ? PieChart(
                              dataMap:
                                  Map<String, double>.from(monthlyJoinData!),
                              chartRadius: 150,
                              colorList: [
                                Colors.blue,
                                Colors.green,
                                Colors.red
                              ],
                              chartType: ChartType.disc,
                              legendOptions:
                                  LegendOptions(showLegendsInRow: true),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValues: true,
                                showChartValuesInPercentage: true,
                                showChartValuesOutside: false,
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Latest Activities:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                          color: Color(0xFFece3de),
                          borderRadius: BorderRadius.circular(8.0)),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('A new user registered'),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                          color: Color(0xFFece3de),
                          borderRadius: BorderRadius.circular(8.0)),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('User commented on a post'),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                          color: Color(0xFFece3de),
                          borderRadius: BorderRadius.circular(8.0)),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('User published a story'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showDeleteConfirmationDialog(String suggestionId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: 'Confirmation',
      desc: 'Are you sure you want to delete this suggestion?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await deleteSuggestion(suggestionId);
      },
    ).show();
  }

  Future<void> deleteSuggestion(String suggestionId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:4000/api/deleteSuggestion/$suggestionId'),
    );

    if (response.statusCode == 200) {
      // Successfully deleted, update the UI
      fetchSuggestions();
      print('Suggestion deleted successfully');
    } else {
      // Failed to delete, handle error
      print('Failed to delete suggestion');
    }
  }
}
