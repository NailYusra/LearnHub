import 'dart:convert';
import 'package:http/http.dart' as http;

// Pastikan Anda mengimpor semua file model yang relevan dari direktori models Anda
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/tutor_model.dart';
import '../models/schedule_model.dart';
import '../models/review_model.dart';
import '../models/chat_message_model.dart';
import '../models/faculty_model.dart';
import '../models/prodi_model.dart';
import '../models/forum_post_model.dart';
import '../models/answer_forum_model.dart';
import '../models/certificate_model.dart'; // Asumsi Anda membuat model ini juga

class ApiConstants {
  // !!! PENTING: GANTI DENGAN ALAMAT IP LOKAL !!!
  static String baseUrl = 'http://192.168.1.108:8000/api';
}

class ApiService {
  // ======================================================================
  // METODE INTERNAL (HELPER) UNTUK MENGHINDARI DUPLIKASI KODE
  // ======================================================================

  /// Helper generik untuk melakukan request GET.
  Future<List<dynamic>> _get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/$endpoint'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal memuat data dari $endpoint - Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error jaringan saat mengakses $endpoint: $e');
    }
  }

  /// Helper generik untuk melakukan request POST.
  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseBody;
      } else {
        throw Exception('Gagal mengirim data ke $endpoint: ${responseBody['message'] ?? response.body}');
      }
    } catch (e) {
      throw Exception('Error jaringan saat mengirim ke $endpoint: $e');
    }
  }

  /// Helper generik untuk melakukan request PUT.
  Future<Map<String, dynamic>> _put(String endpoint, String id, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/$endpoint/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        throw Exception('Gagal mengupdate data di $endpoint: ${responseBody['message'] ?? response.body}');
      }
    } catch (e) {
      throw Exception('Error jaringan saat mengupdate ke $endpoint: $e');
    }
  }

  /// Helper generik untuk melakukan request DELETE.
  Future<Map<String, dynamic>> _delete(String endpoint, String id) async {
    try {
      final response = await http.delete( // Menggunakan method DELETE
        Uri.parse('${ApiConstants.baseUrl}/$endpoint/$id'),
        headers: <String, String>{
          'Accept': 'application/json',
        },
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        throw Exception('Gagal menghapus data di $endpoint: ${responseBody['message'] ?? response.body}');
      }
    } catch (e) {
      throw Exception('Error jaringan saat menghapus di $endpoint: $e');
    }
  }

  // ======================================================================
  // METODE PUBLIK (UNTUK MENGAMBIL DATA / GET)
  // ======================================================================

  Future<List<User>> getUsers() async =>
      (await _get('users')).map((data) => User.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<Faculty>> getFaculties() async =>
      (await _get('faculties')).map((data) => Faculty.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<Prodi>> getProdis() async =>
      (await _get('prodis')).map((data) => Prodi.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<Course>> getCourses() async =>
      (await _get('course')).map((data) => Course.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<Tutor>> getTutors() async =>
      (await _get('tutor')).map((data) => Tutor.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<Certificate>> getCertificates() async =>
      (await _get('certificate')).map((data) => Certificate.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<Review>> getReviews() async =>
      (await _get('review')).map((data) => Review.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<ForumPost>> getForums() async =>
      (await _get('forum')).map((data) => ForumPost.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<AnswerForum>> getAnswerForums() async =>
      (await _get('answerForum')).map((data) => AnswerForum.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<Schedule>> getSchedules() async =>
      (await _get('schedule')).map((data) => Schedule.fromJson(data as Map<String, dynamic>)).toList();

  Future<List<ChatMessage>> getChats() async =>
      (await _get('chat')).map((data) => ChatMessage.fromJson(data as Map<String, dynamic>)).toList();

  // Untuk tabel pivot, kita ambil sebagai Map mentah
  Future<List<Map<String, dynamic>>> getCourseTakens() async =>
      (await _get('courseTaken')).cast<Map<String, dynamic>>();

  Future<List<Map<String, dynamic>>> getTutorCourses() async =>
      (await _get('tutorCourse')).cast<Map<String, dynamic>>();

  Future<List<Map<String, dynamic>>> getKumpulanCertificates() async =>
      (await _get('kumpulanCertificate')).cast<Map<String, dynamic>>();

  // ======================================================================
  // METODE PUBLIK (UNTUK LOGIN & REGISTER)
  // ======================================================================

  Future<User> loginUser(String email, String password) async {
    final response = await _post('login', {'email': email, 'password': password});
    return User.fromJson(response['user']);
  }

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async =>
      await _post('register', userData);

  // ======================================================================
  // METODE PUBLIK (UNTUK MEMBUAT DATA BARU / POST)
  // ======================================================================

  Future<Map<String, dynamic>> createFaculty(Map<String, dynamic> data) async =>
      await _post('faculties', data);
  Future<Map<String, dynamic>> createProdi(Map<String, dynamic> data) async =>
      await _post('prodis', data);
  Future<Map<String, dynamic>> createCourse(Map<String, dynamic> data) async =>
      await _post('course', data);
  Future<Map<String, dynamic>> createTutor(Map<String, dynamic> data) async =>
      await _post('tutor', data);
  Future<Map<String, dynamic>> createTutorCourse(Map<String, dynamic> data) async =>
      await _post('tutorCourse', data);
  Future<Map<String, dynamic>> createCertificate(Map<String, dynamic> data) async =>
      await _post('certificate', data);
  Future<Map<String, dynamic>> createKumpulanCertificate(Map<String, dynamic> data) async =>
      await _post('kumpulanCertificate', data);
  Future<Map<String, dynamic>> createReview(Map<String, dynamic> data) async =>
      await _post('review', data);
  Future<Map<String, dynamic>> createForum(Map<String, dynamic> data) async =>
      await _post('forum', data);
  Future<Map<String, dynamic>> createAnswerForum(Map<String, dynamic> data) async =>
      await _post('answerForum', data);
  Future<Map<String, dynamic>> createCourseTaken(Map<String, dynamic> data) async =>
      await _post('courseTaken', data);
  Future<Map<String, dynamic>> createSchedule(Map<String, dynamic> data) async =>
      await _post('schedule', data);
  Future<Map<String, dynamic>> createChat(Map<String, dynamic> data) async =>
      await _post('chat', data);

  // ======================================================================
  // METODE PUBLIK (UNTUK MENGUPDATE DATA / PUT)
  // ======================================================================

  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> data) async =>
      await _put('users', id, data);
  Future<Map<String, dynamic>> updateFaculty(String id, Map<String, dynamic> data) async =>
      await _put('faculties', id, data);
  Future<Map<String, dynamic>> updateProdi(String id, Map<String, dynamic> data) async =>
      await _put('prodis', id, data);
  Future<Map<String, dynamic>> updateCourse(String id, Map<String, dynamic> data) async =>
      await _put('course', id, data);
  Future<Map<String, dynamic>> updateTutor(String id, Map<String, dynamic> data) async =>
      await _put('tutor', id, data);
  Future<Map<String, dynamic>> updateTutorCourse(String id, Map<String, dynamic> data) async =>
      await _put('tutorCourse', id, data);
  Future<Map<String, dynamic>> updateCertificate(String id, Map<String, dynamic> data) async =>
      await _put('certificate', id, data);
  Future<Map<String, dynamic>> updateKumpulanCertificate(String id, Map<String, dynamic> data) async =>
      await _put('kumpulanCertificate', id, data);
  Future<Map<String, dynamic>> updateReview(String id, Map<String, dynamic> data) async =>
      await _put('review', id, data);
  Future<Map<String, dynamic>> updateForum(String id, Map<String, dynamic> data) async =>
      await _put('forum', id, data);
  Future<Map<String, dynamic>> updateAnswerForum(String id, Map<String, dynamic> data) async =>
      await _put('answerForum', id, data);
  Future<Map<String, dynamic>> updateCourseTaken(String id, Map<String, dynamic> data) async =>
      await _put('courseTaken', id, data);
  Future<Map<String, dynamic>> updateSchedule(String id, Map<String, dynamic> data) async =>
      await _put('schedule', id, data);
  Future<Map<String, dynamic>> updateChat(String id, Map<String, dynamic> data) async =>
      await _put('chat', id, data);

  // ======================================================================
  // METODE PUBLIK BARU (UNTUK MENGHAPUS DATA / DELETE)
  // ======================================================================

  Future<Map<String, dynamic>> deleteCertificate(String id) async =>
      await _delete('certificate', id);
  Future<Map<String, dynamic>> deleteKumpulanCertificate(String id) async =>
      await _delete('kumpulanCertificate', id);
  Future<Map<String, dynamic>> deleteReview(String id) async =>
      await _delete('review', id);
  Future<Map<String, dynamic>> deleteForum(String id) async =>
      await _delete('forum', id);
  Future<Map<String, dynamic>> deleteAnswerForum(String id) async =>
      await _delete('answerForum', id);
  Future<Map<String, dynamic>> deleteCourseTaken(String id) async =>
      await _delete('courseTaken', id);
  Future<Map<String, dynamic>> deleteSchedule(String id) async =>
      await _delete('schedule', id);
  Future<Map<String, dynamic>> deleteChat(String id) async =>
      await _delete('chat', id);

}
