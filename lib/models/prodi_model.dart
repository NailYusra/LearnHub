// lib/models/prodi_model.dart
class Prodi {
  final String id;
  final String nama;
  final String facultyId;

  Prodi({required this.id, required this.nama, required this.facultyId});

  factory Prodi.fromJson(Map<String, dynamic> json) {
    return Prodi(
      id: json['prodi_id'] ?? json['id'] ?? '',
      nama: json['nama'] ?? 'Tanpa Nama',
      facultyId: json['faculty_id'] ?? '',
    );
  }
}