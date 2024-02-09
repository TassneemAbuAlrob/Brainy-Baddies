import 'package:alaa_admin/providers/age_provider.dart';
import 'package:alaa_admin/providers/category_provider.dart';
import 'package:alaa_admin/providers/chat_provider.dart';
import 'package:alaa_admin/providers/create_quiz_provider.dart';
import 'package:alaa_admin/providers/home_provider.dart';
import 'package:alaa_admin/providers/notification_provider.dart';
import 'package:alaa_admin/providers/quiz_provider.dart';
import 'package:alaa_admin/screens/login.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuizProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CreateQuizProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AgeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'admin panel',
        theme: ThemeData(
          fontFamily: 'kdam'
        ),
        // theme: FlexColorScheme.light(scheme: FlexScheme.deepBlue).toTheme,
        // darkTheme: FlexColorScheme.dark(scheme: FlexScheme.deepBlue).toTheme,
        // themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
