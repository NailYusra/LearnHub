import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol Back
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.01),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke WelcomeScreen
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  'Login here',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFB71C1C),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Center(
                child: Text(
                  'Welcome back you’ve\nbeen missed!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              // Email Field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: Colors.black45),
                  filled: true,
                  fillColor: const Color(0xFFF4F6FA),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFB71C1C),
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Password Field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.black45),
                  filled: true,
                  fillColor: const Color(0xFFF4F6FA),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFB71C1C),
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    // Aksi lupa password
                  },
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(
                      color: const Color(0xFFB71C1C),
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black26,
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Create new account
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Create new account',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Or continue with
              Center(
                child: Text(
                  'Or continue with',
                  style: TextStyle(
                    color: const Color(0xFFB71C1C),
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Google Sign In Button
              Center(
                child: Container(
                  width: screenWidth * 0.14,
                  height: screenWidth * 0.14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Text(
                      'G',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    onPressed: () {
                      // Aksi login Google
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
