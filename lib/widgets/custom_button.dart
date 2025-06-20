import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  // Ubah menjadi nullable agar bisa menampung nilai null untuk menonaktifkan tombol
  final VoidCallback? onPressed;
  final Color color;

  const CustomButton({
    required this.text,
    this.onPressed, // Hapus 'required'
    this.color = const Color(0xFFD32F2F), // Anda bisa menggunakan Theme.of(context).primaryColor untuk konsistensi
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // Secara otomatis akan menjadi abu-abu jika onPressed adalah null
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(fontSize: 16),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      // Langsung teruskan nilai onPressed (bisa fungsi, bisa null)
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
