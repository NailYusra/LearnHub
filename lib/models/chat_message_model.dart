// lib/models/chat_message_model.dart

class ChatMessage {
  final String id;
  final String userId; // User dalam sesi chat
  final String tutorId; // Tutor dalam sesi chat
  final String senderId; // Siapa yang mengirim pesan ini (bisa user_id atau tutor_id)
  final String text;
  final DateTime date;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.tutorId,
    required this.senderId,
    required this.text,
    required this.date,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['chat_id'] ?? json['id'],
      userId: json['user_id'] ?? '',
      tutorId: json['tutor_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      text: json['text'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}