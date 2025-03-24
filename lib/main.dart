import 'package:flutter/material.dart';
import 'auth_screen.dart'; // Import the AuthScreen

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAEYpUdXvLrugLKmBZYz1N7rpTKiQS6vmI",
      appId: "1:725183558912:web:dbe362eeca7f90cfca2fe5",
      messagingSenderId: "725183558912",
      projectId: "flutter-news-app-76497",
      // Add other required fields from your Firebase config
    ),
  );
  runApp(NewsApp());
}

// void main() {
//   runApp(NewsApp());
// }

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