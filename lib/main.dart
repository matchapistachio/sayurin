import 'package:flutter/material.dart';
import 'package:sayurin/home_page.dart';
import 'package:sayurin/core/di/injection.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sayurin App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF112028),
      ),
      home: homePage(),
    );
  }
}