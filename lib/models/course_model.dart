// lib/models/course_model.dart
class Course {
  final String id;
  final String nama;
  final String prodiId;

  Course({required this.id, required this.nama, required this.prodiId});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['course_id'] ?? json['id'],
      nama: json['nama'],
      prodiId: json['prodi_id'],
    );
  }
}