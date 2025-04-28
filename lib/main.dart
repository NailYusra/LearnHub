import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/welcome_screen.dart'; // import welcome_screen.dart

void main() {
  runApp(const LearnHubApp());
}

class LearnHubApp extends StatelessWidget {
  const LearnHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      home: const WelcomeScreen(), // Home langsung ke WelcomeScreen
    );
  }
}
