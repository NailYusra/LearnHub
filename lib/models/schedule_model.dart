// lib/models/schedule_model.dart
class Schedule {
  final String id;
  final String userId;
  final String tutorId;
  final String courseId;
  final DateTime date;
  // Untuk menampilkan info, kita butuh data lain
  final String? courseName;
  final String? tutorName;

  Schedule({
    required this.id,
    required this.userId,
    required this.tutorId,
    required this.courseId,
    required this.date,
    this.courseName,
    this.tutorName,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['schedule_id'] ?? json['id'],
      userId: json['user_id'],
      tutorId: json['tutor_id'],
      courseId: json['course_id'],
      date: DateTime.parse(json['date']),
      courseName: json['course_name'], // Akan diisi nanti
      tutorName: json['tutor_name'], // Akan diisi nanti
    );
  }
}