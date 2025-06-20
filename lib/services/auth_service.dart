// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart'; // Pastikan path ini benar

class AuthService {
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  // Menyimpan data user setelah login berhasil
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, user.id);
    await prefs.setString(_userNameKey, user.nama);
    await prefs.setString(_userEmailKey, user.email);
  }

  // Mengambil ID user yang tersimpan
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Mengecek apakah ada sesi login yang aktif
  Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    return userId != null;
  }

  // Menghapus data sesi saat logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }
}