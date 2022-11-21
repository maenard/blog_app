import 'package:blog_app/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
