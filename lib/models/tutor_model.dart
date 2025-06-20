import 'course_model.dart'; // <-- PASTIKAN IMPORT INI ADA

class Tutor {
  final String id;
  final String userId;
  final double ratingMean;

  // Properti tambahan untuk UI
  final String? nama;
  final String? profilePicture;
  final String? prodiNama;

  // ======================================================
  // INI ADALAH SATU-SATUNYA SUMBER MASALAH.
  // PASTIKAN BARIS INI PERSIS SEPERTI DI BAWAH INI.
  // ======================================================
  final List<Course> specialties;

  Tutor({
    required this.id,
    required this.userId,
    required this.ratingMean,
    this.nama,
    this.profilePicture,
    this.prodiNama,
    this.specialties = const [],
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['tutor_id'] ?? json['id'] ?? '',
      userId: json['user_id'] ?? '',
      ratingMean: double.tryParse(json['rating_mean']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}
