import 'package:flutter/material.dart';
import 'package:log/presentation/screens/home_screen.dart';
import 'package:log/presentation/screens/login/login_screen.dart';
import 'package:log/presentation/screens/mainChild.dart';
import 'package:log/presentation/screens/parent/OnBoardingPage.dart';
import 'package:log/presentation/screens/parent/perantDash.dart';
import 'package:log/presentation/screens/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.authenticated ? 
      (authProvider.isBoarding ? IntroScreen() : (authProvider.user.role == "parent" ? PerantDash() :  mainChild()))
     : welcomeScreen();
  }
}
