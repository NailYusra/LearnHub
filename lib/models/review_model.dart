// lib/models/review_model.dart
class Review {
  final String id;
  final String userId;
  final String tutorId;
  final double ratingTutor;
  final String commentReview;

  // -- PERUBAHAN DI SINI --
  // Properti tambahan untuk menampung data nama dan foto user yang memberi ulasan.
  // Dibuat opsional (nullable) karena tidak berasal dari JSON asli.
  final String? reviewerName;
  final String? reviewerPhoto;

  Review({
    required this.id,
    required this.userId,
    required this.tutorId,
    required this.ratingTutor,
    required this.commentReview,
    // Tambahkan properti baru ke constructor
    this.reviewerName,
    this.reviewerPhoto,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['review_id'] ?? json['id'],
      userId: json['user_id'] ?? '',
      tutorId: json['tutor_id'] ?? '',
      ratingTutor: double.tryParse(json['rating_tutor']?.toString() ?? '0.0') ?? 0.0,
      commentReview: json['comment_review'] ?? '',
    );
  }
}