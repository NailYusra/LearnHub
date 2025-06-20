// lib/models/certificate_model.dart

class Certificate {
  final String id;
  final String nama;
  final String mataKuliah;
  final String gambar;

  Certificate({
    required this.id,
    required this.nama,
    required this.mataKuliah,
    required this.gambar,
  });

  /// Factory constructor untuk membuat instance Certificate dari JSON.
  /// Ini akan mem-parsing data yang dikirim oleh backend Anda.
  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      // Backend Anda menambahkan 'certificate_id' dan parsing di Flutter menambahkan 'id'.
      // Kode ini akan menangani keduanya untuk fleksibilitas.
      id: json['certificate_id'] ?? json['id'] ?? '',
      nama: json['nama'] ?? 'Tanpa Nama',
      mataKuliah: json['mata_kuliah'] ?? 'Tanpa Mata Kuliah',
      gambar: json['gambar'] ?? '',
    );
  }
}