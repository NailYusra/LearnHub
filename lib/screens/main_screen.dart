import 'package:flutter/material.dart';

// 1. Impor semua halaman utama Anda
import 'home_screen.dart';
import 'konsultasi_screen.dart';
import 'forum_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 2. State untuk melacak indeks tab yang sedang aktif
  int _selectedIndex = 0;

  // 3. Daftar halaman yang akan ditampilkan
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    KonsultasiScreen(),
    ForumScreen(),
    ProfileScreen(),
  ];

  // 4. Fungsi yang akan dipanggil saat sebuah tab di-tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 5. Body akan menampilkan halaman sesuai dengan indeks yang aktif
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      // 6. Definisikan BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        // Daftar item navigasi
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: 'Konsultasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            activeIcon: Icon(Icons.forum),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Indeks yang aktif saat ini
        onTap: _onItemTapped,       // Panggil fungsi saat di-tap

        // --- Styling (Opsional tapi disarankan) ---
        type: BottomNavigationBarType.fixed, // Agar semua label terlihat
        selectedItemColor: Colors.blueAccent, // Warna ikon dan label yang aktif
        unselectedItemColor: Colors.grey,     // Warna ikon dan label yang tidak aktif
        showUnselectedLabels: true,           // Tampilkan label untuk item yang tidak aktif
        elevation: 5.0,
      ),
    );
  }
}
