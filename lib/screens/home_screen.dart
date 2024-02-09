import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/screens/control_panel_home.dart';
import 'package:alaa_admin/screens/more_screen.dart';
import 'package:alaa_admin/screens/parent_messages.dart';
import 'package:alaa_admin/widgets/shared_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> items = [
    { 'name': 'Home', 'icon-outlined': Icons.house_outlined, 'icon': Icons.house },
    { 'name': 'Messages', 'icon-outlined': Icons.message_outlined, 'icon': Icons.message },
    // { 'name': 'More', 'icon-outlined': Icons.article_outlined, 'icon': Icons.article },

  ];

  List<Widget> screens = [
    ControlPanelHome(),
    MessagesScreen(),
    // MoreScreen(),
  ];

  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SharedDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.secondaryColor,
        elevation: 0,
        backgroundColor: screenBackgroundColor,

        unselectedItemColor: Colors.black,
        currentIndex: _activeIndex,
        type: BottomNavigationBarType.fixed,
        items: items
            .map((item) => BottomNavigationBarItem(
          icon: Icon(
            _activeIndex == items.indexOf(item) ? item['icon'] : item['icon-outlined'],
          ),
          label: item['name'],
        ))
            .toList(),
        onTap: (int index) {
          setState(() {
            _activeIndex = index;
          });
        },
      ),
      body: screens[_activeIndex],
    );
  }
}
