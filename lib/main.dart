import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fyp_firebase/constraints.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'Login_Page.dart';

List<CameraDescription> cameras;

SharedPreferences localStorage;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Active Drive',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          fillColor: mainColor,
        ),
        primarySwatch: Colors.teal,
      ),
      home: Login());
  }
}
