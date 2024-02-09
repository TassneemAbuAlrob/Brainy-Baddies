import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/colors.dart';
import 'components/containers.dart';
import 'stories.dart';
import 'videoList.dart';
import 'welcome/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            await sharedPreferences.remove('token');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => welcomeScreen())
            );
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.logout),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome ${'Child'}',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color:secondaryColor,
                          ),
                    ),
                    const SizedBox(height: 20),
                    // InkWell(
                    //   onTap: (){
                    //     // Navigator.of(context).push(
                    //     //   MaterialPageRoute(builder: (context) => TemplateWorkspace())
                    //     // );
                    //   },
                    //   child: Image.asset(AppImages.fullKontroll),
                    // ),
                    const SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        TemplateContainerCardWithIcon(
                            title: 'Videos',
                            icon: Icons.video_call,
                            
                            onTap: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => videoList())
                              );
                              // Navigator.pushNamed(context,PlacesScreen.route);
                            }),
                        TemplateContainerCardWithIcon(
                            title: 'Stories', backgroundColor:secondaryColor, icon: Icons.book, onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => StoriesList())
                              );
                              // Navigator.pushNamed(context, SavedViolationScreen.route);
                            }),
                        TemplateContainerCardWithIcon(
                            title: 'DONE VL',backgroundColor: Colors.green, icon: Icons.done_all, onTap: () {
                              // Navigator.pushNamed(context, CompletedViolationsScreen.route);
                            }),
                        TemplateContainerCardWithIcon(
                            title: 'END SHIFT', backgroundColor: Colors.red, icon: Icons.logout, onTap: () {
                              // Navigator.pushNamed(context, DoneShiftScreen.route);
                            }),
                      ],
                    ),
            
                    // Workspace()
                  ],
                ),
        ),
      ),
    );
  }
}
