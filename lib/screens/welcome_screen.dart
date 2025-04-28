import 'package:flutter/material.dart';
import 'package:learn_hub/screens/register_screen.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              // Gambar
              Image.asset(
                'assets/images/welcome_logo.png', // Pastikan sudah ada gambarnya
                height: 300,
              ),
              // Judul dan Subjudul
              Column(
                children: const [
                  Text(
                    "Discover what\nyou're looking for",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Welcome to LearnHub – where learning gets easier, one step at a time!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // Tombol Login dan Register
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB71C1C),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(140, 50), // Tambahkan ini
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4E6E6),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(130, 50), // Tambahkan ini
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
