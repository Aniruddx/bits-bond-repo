//import 'dart:ffi';

import 'package:bitsbond/Authentication/imageclass.dart';
import 'package:bitsbond/Authentication/login_screen.dart';
//import 'package:bitsbond/home/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:audioplayers/audioplayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthenticationController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //AudioPlayer audioPlayer = AudioPlayer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SPARK',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 255,179,198)
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
