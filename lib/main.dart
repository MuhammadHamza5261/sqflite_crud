import 'package:flutter/material.dart';
import 'package:sqflite_crud/screens/home_page_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePageScreen(),
    );
  }
}


