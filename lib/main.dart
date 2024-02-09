import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:log/core/helpers/sqfilte_helper.dart';
import 'package:log/data/entities/notification_data.dart';
import 'package:log/data/services/notification_service.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:log/presentation/providers/challenge_provider.dart';
import 'package:log/presentation/providers/notification_provider.dart';
import 'package:log/presentation/providers/post_provider.dart';
import 'package:log/presentation/providers/user_provider.dart';
import 'package:log/presentation/wrappers/auth_wrapper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'core/constants/colors.dart';
import 'core/utils/logger.dart';
import 'data/repositories/cache_repository_impl.dart';
import 'presentation/providers/category_provider.dart';
import 'presentation/providers/story_provider.dart';
import 'presentation/providers/video_provider.dart';
import 'presentation/screens/welcome/welcome_screen.dart';

import 'package:firebase_core/firebase_core.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late AndroidNotificationChannel channel;
late AndroidNotificationChannel customIssueChannel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

bool isFlutterLocalNotificationsInitialized = false;

void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse) {
  if (notificationResponse.payload != null) {}
}

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) {
  if (notificationResponse.payload != null) {}
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'Sjekk_Channel_1', // id
    'Sjekk Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  isFlutterLocalNotificationsInitialized = true;
}

Future<void> showFlutterNotification(String title, String body) async {
  if (!kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      Random().nextInt(42949672),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            playSound: true,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.max),
      ),
    );
  }
}

Future<void> requestNotificationPermission() async {
  await Permission.notification.isDenied.then((value) async {
    if (value) {
      Permission.notification.request();
    }
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheRepositoryImpl.init();
  await DatabaseHelper.instance.initDatabase();
  await AuthProvider.instance.detectToShowIntro();
  await AuthProvider.instance.detectAuthenticationState();

  await requestNotificationPermission();
  await setupFlutterNotifications();
  try {
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: const FirebaseOptions(
              apiKey: "AIzaSyAc8lRsz_RP8TDrfo-MvfPDdX9LHRo08G0",
              appId: "1:37672179495:android:363660b8e831408fcd7b02",
              messagingSenderId: "37672179495",
              projectId: "messagesfinal-668e3",
            ),
          )
        : await Firebase.initializeApp();

    runApp(MyApp());
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  Socket socket = io(
      'http://10.0.2.2:4000',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build());

  socket.onConnect((data) {
    print('connected');
  });
  socket.onError((data) {
    print(data);
  });

  socket.connect();
  socket.onDisconnect((_) => print('disconnect'));

  socket.on('notification', (data) async {
    pinfo(data);

    await showFlutterNotification(
        data['notification']['title'], data['notification']['body']);

    try {
      NotificationData notificationData =
          NotificationData.fromJson(data['notification']);
      bool result =
          await NotificationService.storeNotification(notificationData);

      pinfo('result is $result');
    } catch (e) {}
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VideoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChallengePorvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider.instance,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'log',
        theme: ThemeData(
          primaryColor: KPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}
