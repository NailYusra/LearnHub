import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;
  String? _role;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get role => _role;

  AuthModel() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _email = prefs.getString('email');
    _role = prefs.getString('role');
    debugPrint('Loaded from prefs: isLoggedIn=$_isLoggedIn, email=$_email, role=$_role');
    notifyListeners();
  }

  Future<void> login(String email, String role) async {
    _isLoggedIn = true;
    _email = email;
    _role = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setString('email', email);
    await prefs.setString('role', role);
    debugPrint('Login: isLoggedIn=$_isLoggedIn, email=$_email, role=$_role');
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _email = null;
    _role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint('Logout: isLoggedIn=$_isLoggedIn');
    notifyListeners();
  }
}