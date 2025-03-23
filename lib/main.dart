import 'package:flutter/material.dart';
import 'auth_screen.dart'; // Import the AuthScreen

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: AuthScreen(), // Start with the AuthScreen
    );
  }
}