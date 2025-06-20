// lib/models/user_model.dart
class User {
  final String id;
  final String nama;
  final String email;
  final String? prodiId;
  final String? profilePicture;
  final String? bio;
  final String? noTelp;

  User({
    required this.id,
    required this.nama,
    required this.email,
    this.prodiId,
    this.profilePicture,
    this.bio,
    this.noTelp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] ?? json['id'] ?? '',
      nama: json['nama'] ?? 'Tanpa Nama',
      email: json['email'] ?? '',
      prodiId: json['prodi_id'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      noTelp: json['no_telp'],
    );
  }
}