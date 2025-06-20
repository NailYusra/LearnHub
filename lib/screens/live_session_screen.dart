import 'dart:async';
import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../models/user_model.dart';

class LiveSessionScreen extends StatefulWidget {
  final Schedule schedule;
  final User student;
  final User tutorUser;

  const LiveSessionScreen({
    super.key,
    required this.schedule,
    required this.student,
    required this.tutorUser,
  });

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  Timer? _timer;
  // Sesi default 60 menit, kita akan hitung mundur dari sini
  Duration _sessionDuration = const Duration(minutes: 60);

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Memulai timer hitung mundur untuk sesi
  void _startSessionTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Pastikan widget masih ada di tree sebelum memanggil setState
      if (mounted) {
        if (_sessionDuration.inSeconds > 0) {
          setState(() {
            _sessionDuration -= const Duration(seconds: 1);
          });
        } else {
          _timer?.cancel();
          // Jika waktu habis, bisa secara otomatis pop atau tampilkan dialog
          // Untuk sekarang, kita hentikan timer saja
        }
      } else {
        // Jika widget sudah di-dispose, batalkan timer untuk mencegah memory leak
        _timer?.cancel();
      }
    });
  }

  /// Helper untuk memformat durasi menjadi teks "MM:SS"
  String _formatSessionTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sesi Berlangsung"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Sembunyikan tombol back
      ),
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            // Timer Sesi
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.black,
              child: Center(
                child: Text(
                  "Sisa Waktu: ${_formatSessionTime(_sessionDuration)}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Tampilan "Video Feed" (simulasi)
            Expanded(
              child: Stack(
                children: [
                  // Tampilan lawan bicara (Tutor) - Memenuhi layar
                  _buildParticipantView(
                    context,
                    name: widget.tutorUser.nama,
                    isLarge: true,
                    profilePicture: widget.tutorUser.profilePicture,
                  ),

                  // Tampilan diri sendiri (Siswa) - di pojok kanan atas
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _buildParticipantView(
                      context,
                      name: "Anda (${widget.student.nama})",
                      isLarge: false,
                      profilePicture: widget.student.profilePicture,
                    ),
                  )
                ],
              ),
            ),

            // Tombol Kontrol Sesi
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan frame peserta (simulasi video)
  Widget _buildParticipantView(BuildContext context,
      {required String name,
        bool isLarge = true,
        String? profilePicture}) {
    final size = isLarge ? MediaQuery.of(context).size.width : 100.0;

    return Container(
      width: size,
      height: isLarge ? null : 140, // Tinggi untuk frame kecil
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border.all(color: Colors.grey.shade700, width: 2),
        borderRadius: isLarge ? null : BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: isLarge ? 50 : 25,
            backgroundImage: profilePicture != null ? NetworkImage(profilePicture) : null,
            child: profilePicture == null ? Icon(Icons.person, size: isLarge ? 50 : 25) : null,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk tombol kontrol di bagian bawah layar
  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Tombol Mute (simulasi)
          IconButton(
            onPressed: () {
              // Tambahkan logika mute di sini
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mic dimatikan (simulasi)')));
            },
            icon: const Icon(Icons.mic_off_outlined,
                color: Colors.white, size: 30),
          ),

          // Tombol Stop Video (simulasi)
          IconButton(
            onPressed: () {
              // Tambahkan logika stop video di sini
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video dimatikan (simulasi)')));
            },
            icon: const Icon(Icons.videocam_off_outlined,
                color: Colors.white, size: 30),
          ),

          // Tombol Akhiri Panggilan
          ElevatedButton(
            onPressed: () {
              // =========================================================
              // INI ADALAH SATU-SATUNYA PERUBAHAN PENTING PADA FILE INI
              // Mengirimkan nilai `true` kembali ke layar sebelumnya
              // untuk menandakan bahwa sesi telah berakhir.
              // =========================================================
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor, // Warna merah
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
            ),
            child: const Icon(Icons.call_end, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}