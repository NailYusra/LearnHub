// lib/models/forum_post_model.dart
import 'user_model.dart'; // Kita akan butuh info user

class ForumPost {
  final String id;
  final String userId;
  final String headerQuestion;
  final String question;
  final DateTime date;

  // Properti ini akan diisi di sisi Flutter untuk kebutuhan UI
  final User? user;
  final int answerCount;

  ForumPost({
    required this.id,
    required this.userId,
    required this.headerQuestion,
    required this.question,
    required this.date,
    this.user,
    this.answerCount = 0,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['forum_id'] ?? json['id'] ?? '',
      userId: json['user_id'] ?? '',
      headerQuestion: json['header_question'] ?? 'Tanpa Judul',
      question: json['question'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}