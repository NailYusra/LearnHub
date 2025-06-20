// lib/models/faculty_model.dart
class Faculty {
  final String id;
  final String nama;

  Faculty({required this.id, required this.nama});

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['faculty_id'] ?? json['id'] ?? '',
      nama: json['nama'] ?? 'Tanpa Nama',
    );
  }
}