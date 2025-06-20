class AnswerForum {
  final String id;
  final String forumId;
  final String userId;
  final String answer;
  final DateTime date;

  // Properti baru untuk melacak siapa saja yang vote
  List<String> likedBy;
  List<String> dislikedBy;

  // Getter untuk mendapatkan jumlah vote dari panjang list
  int get likeCount => likedBy.length;
  int get dislikeCount => dislikedBy.length;

  AnswerForum({
    required this.id,
    required this.forumId,
    required this.userId,
    required this.answer,
    required this.date,
    this.likedBy = const [],
    this.dislikedBy = const [],
  });

  factory AnswerForum.fromJson(Map<String, dynamic> json) {
    return AnswerForum(
      id: json['answer_id'] ?? json['id'] ?? '',
      forumId: json['forum_id'] ?? '',
      userId: json['user_id'] ?? '',
      answer: json['answer'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      // Ambil data array, jika tidak ada, kembalikan list kosong
      likedBy: List<String>.from(json['liked_by'] ?? []),
      dislikedBy: List<String>.from(json['disliked_by'] ?? []),
    );
  }
}
