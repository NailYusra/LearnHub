import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/auth_wrapper.dart'; // Impor AuthWrapper untuk pengecekan login

void main() {
  // Inisialisasi locale untuk package intl (misal: format tanggal Indonesia)
  // Pastikan Anda sudah menambahkan package `intl` di pubspec.yaml
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnHub',
      debugShowCheckedModeBanner: false,
      // Terapkan ThemeData kustom yang sudah Anda buat
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFFD32F2F, // Warna utama (merah tua)
          <int, Color>{
            50: Color(0xFFFFEBEE),
            100: Color(0xFFFFCDD2),
            200: Color(0xFFEF9A9A),
            300: Color(0xFFE57373),
            400: Color(0xFFEF5350),
            500: Color(0xFFD32F2F),
            600: Color(0xFFE53935),
            700: Color(0xFFD81B60),
            800: Color(0xFFC2185B),
            900: Color(0xFFB71C1C),
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      // Aplikasi akan dimulai dari AuthWrapper untuk mengecek status login
      home: const AuthWrapper(),
    );
  }
}