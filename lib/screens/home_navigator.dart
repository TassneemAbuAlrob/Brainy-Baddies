import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import '../helpers/home_router.dart';

class HomeNavigatorScreen extends StatefulWidget {
  const HomeNavigatorScreen({super.key});

  @override
  State<HomeNavigatorScreen> createState() => _HomeNavigatorScreenState();
}

class _HomeNavigatorScreenState extends State<HomeNavigatorScreen> {
  final GlobalKey<NavigatorState> _nestedNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_nestedNavigatorKey.currentState!.canPop()) {
          _nestedNavigatorKey.currentState!.pop();
          return false;
        } else {
          // Show the exit confirmation dialog
          _showExitConfirmationDialog();
          return false;
        }
      },
      child: Scaffold(
        body: Navigator(
          key: _nestedNavigatorKey,
          onGenerateRoute: HomeRouter.generatedRoute,
        ),
      ),
    );
  }

  // Show the exit confirmation dialog
  Future<void> _showExitConfirmationDialog() async {
    await showDialog(
        context: context,
        builder: (context){
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0,sigmaY: 10.0),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.exit_to_app,
                    size: 80,
                    color: Colors.red,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Material(
                      type: MaterialType.transparency,
                      child: AutoSizeText(
                        "Are you sure you want to exit the app?",
                        style: TextStyle(fontSize: 20,color: Colors.white),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                        ),
                        child: Text("Cancel",style: TextStyle(
                            color: Colors.white
                        ),),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          SystemNavigator.pop(); // Exit the app
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: Text("Exit",style: TextStyle(
                            color: Colors.white
                        ),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
