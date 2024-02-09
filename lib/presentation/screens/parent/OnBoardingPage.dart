import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:log/data/repositories/cache_repository_impl.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/screens/parent/perantDash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mainChild.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  ///Changed a little bit of buttons styling and text for the thumbnail lol
  ///Thanks for coming here :-)

  final List<PageViewModel> pages = [
    PageViewModel(
        title: 'Connect With Everyone',
        body:
            'Here you can have whatever description you would like to have, you can type it all in here',
        footer: SizedBox(
          height: 45,
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 8),
            onPressed: () {},
            child: const Text("Let's Go", style: TextStyle(fontSize: 20)),
          ),
        ),
        image: Center(
          child: Image.asset('images/img1.jpg'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ))),
    PageViewModel(
        title: 'Have Access Everywhere!',
        body:
            'Here you can have whatever description you would like to have, you can type it all in here',
        footer: SizedBox(
          height: 45,
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 8),
            onPressed: () {},
            child: const Text(
              "Why to wait!",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        image: Center(
          child: Image.asset('images/img2.jpg'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ))),
    PageViewModel(
        title: 'Here We Start!',
        body:
            'Here you can have whatever description you would like to have, you can type it all in here',
        footer: SizedBox(
          height: 45,
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 252, 50, 154),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 8),
            onPressed: () {},
            child: const Text("Let's Start", style: TextStyle(fontSize: 20)),
          ),
        ),
        image: Center(
          child: Image.asset('images/img3.jpg'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 204, 203, 204),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 80, 12, 12),
        child: IntroductionScreen(
          pages: pages,
          dotsDecorator: const DotsDecorator(
            size: Size(15, 15),
            color: Colors.blue,
            activeSize: Size.square(20),
            activeColor: Color.fromARGB(255, 252, 50, 154),
          ),
          showDoneButton: true,
          done: const Text(
            'Done',
            style: TextStyle(fontSize: 20),
          ),
          showSkipButton: true,
          skip: const Text(
            'Skip',
            style: TextStyle(fontSize: 20),
          ),
          showNextButton: true,
          next: const Icon(
            Icons.arrow_forward,
            size: 25,
          ),
          onDone: () => onDone(context),
          curve: Curves.bounceOut,
        ),
      ),
    );
  }

  void onDone(BuildContext context) async {
    final prefs = CacheRepositoryImpl.instance;
    await prefs.setBool('boarding', false);
    if(context.read<AuthProvider>().user.role == "parent"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PerantDash()),
          );
    }else{
          Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const mainChild()),
    );
    }
  }
}
