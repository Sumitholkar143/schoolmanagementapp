import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:schoolmanagment/LoginScreen.dart';
import 'package:schoolmanagment/teacher/Demo.dart';
import 'package:schoolmanagment/teacher/StudentList.dart';
import 'package:schoolmanagment/teacher/TeacherDashBoardScreen.dart';

import 'DashBoardScreen.dart';
import 'Sharedpref/SharedPreferencesfile.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessBack(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessBack);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static bool isTeach = false;
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the result, show a loading indicator or splash screen
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
            debugShowCheckedModeBanner: false,
          );
        } else if (snapshot.hasError) {
          // If an error occurs during the execution, handle it here
          // You might want to show an error screen or handle it differently
          return MaterialApp(
            home: Scaffold(body: Center(child: Text('Error occurred!'))),
            debugShowCheckedModeBanner: false,
          );
        } else {
          bool isLogin = snapshot.data ?? false;
          return MaterialApp(
            title: 'School Managment',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
              useMaterial3: true,
            ),
            home: isTeach
                ? TeacherDashBoardScreen()
                : isLogin
                    ? DashBoardScreen()
                    : LoginScreen(title: ''),
          );
        }
      },
    );
  }

  static Future<bool> isLogin() async {
    isTeach = await SharedPreferencesfile.isTeacher();
    return SharedPreferencesfile.getIsLogin();
  }
}
