import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

// Import semua model, service, dan halaman yang relevan
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/tutor_model.dart';
import '../models/schedule_model.dart';

import 'tutor_detail_screen.dart';
import 'schedule_detail_screen.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  Future<Map<String, dynamic>>? _homeDataFuture;

  @override
  void initState() {
    super.initState();
    _homeDataFuture = _loadHomeData();
  }

  /// Fungsi utama untuk mengambil semua data dari berbagai endpoint
  Future<Map<String, dynamic>> _loadHomeData() async {
    try {
      final currentUserId = await _authService.getUserId();
      if (currentUserId == null) {
        throw Exception("Sesi tidak ditemukan. Silakan login kembali.");
      }

      final (allUsers, allCourses, allTutors, allSchedules, tutorCourseLinks) = await (
      _apiService.getUsers(),
      _apiService.getCourses(),
      _apiService.getTutors(),
      _apiService.getSchedules(),
      _apiService.getTutorCourses()
      ).wait;

      final userMap = {for (var u in allUsers) u.id: u};
      final courseMap = {for (var c in allCourses) c.id: c};
      final tutorMap = {for (var t in allTutors) t.id: t};
      final now = DateTime.now();

      final User currentUser = userMap[currentUserId] ?? User(id: '', nama: 'Guest', email: '');

      // Filter jadwal milik user DAN yang waktunya belum lewat
      final List<Schedule> mySchedules = allSchedules
          .where((s) => s.userId == currentUserId && s.date.isAfter(now)) // <-- PERUBAHAN: Hanya ambil jadwal mendatang
          .map((s) {
        final tutorUser = userMap[tutorMap[s.tutorId]?.userId];
        final course = courseMap[s.courseId];
        return Schedule(
          id: s.id, userId: s.userId, tutorId: s.tutorId, courseId: s.courseId, date: s.date,
          tutorName: tutorUser?.nama,
          courseName: course?.nama,
        );
      }).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      final List<Tutor> recommendedTutors = allTutors.map((t) {
        final tutorUser = userMap[t.userId];
        final specialties = tutorCourseLinks
            .where((link) => link['tutor_id'] == t.id)
            .map((link) => courseMap[link['course_id']])
            .whereNotNull().toList();
        return Tutor(
          id: t.id, userId: t.userId, ratingMean: t.ratingMean,
          nama: tutorUser?.nama, profilePicture: tutorUser?.profilePicture,
          specialties: specialties,
        );
      }).toList()
        ..sort((a, b) => b.ratingMean.compareTo(a.ratingMean));

      return {
        'currentUser': currentUser,
        'mySchedules': mySchedules,
        'allCourses': allCourses,
        'recommendedTutors': recommendedTutors,
      };
    } catch (e) {
      print("Error memuat data home: $e");
      rethrow;
    }
  }

  /// Fungsi untuk memuat ulang data dari server
  void _refreshHomeData() {
    setState(() {
      _homeDataFuture = _loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _homeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat data: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data untuk ditampilkan."));
          }

          final data = snapshot.data!;
          final User currentUser = data['currentUser'];
          final List<Schedule> mySchedules = data['mySchedules'];
          final List<Course> allCourses = data['allCourses'];
          final List<Tutor> recommendedTutors = data['recommendedTutors'];

          return RefreshIndicator(
            onRefresh: () async => _refreshHomeData(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  title: _buildWelcomeHeader(currentUser),
                  toolbarHeight: 80,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Jadwal Mendatang"),
                          const SizedBox(height: 12),
                          _buildScheduleList(mySchedules),
                          const SizedBox(height: 24),
                          _buildSectionTitle("Pilihan Kursus"),
                          const SizedBox(height: 12),
                          _buildCourseList(allCourses),
                          const SizedBox(height: 24),
                          _buildSectionTitle("Rekomendasi Tutor"),
                          const SizedBox(height: 12),
                          _buildTutorList(recommendedTutors),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget-widget pembangun UI di bawah ini tidak perlu diubah, KECUALI _buildTutorList dan _buildScheduleList
  Widget _buildWelcomeHeader(User user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: user.profilePicture != null ? NetworkImage(user.profilePicture!) : null,
          child: user.profilePicture == null ? const Icon(Icons.person, size: 24, color: Colors.grey) : null,
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Selamat Datang,", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
              Text(user.nama.isNotEmpty ? user.nama : 'Guest', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    // ... kode Anda yang sudah ada ...
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// ====================================================================
  /// PERBAIKAN 1: Modifikasi `_buildScheduleList` untuk menangani refresh
  /// ====================================================================
  Widget _buildScheduleList(List<Schedule> schedules) {
    if (schedules.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: const Center(child: Text("Tidak ada jadwal mendatang.", style: TextStyle(color: Colors.grey))),
      );
    }
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return InkWell(
            onTap: () async {
              // Menunggu hasil dari ScheduleDetailScreen
              final didDataChange = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScheduleDetailScreen(schedule: schedule),
                ),
              );
              // Jika ada perubahan data (misal, jadwal dibatalkan), refresh HomeScreen
              if (didDataChange == true) {
                _refreshHomeData();
              }
            },
            child: Container(
              width: 240,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_note, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          schedule.courseName ?? 'Sesi Umum',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text("dengan ${schedule.tutorName ?? 'Nama Tutor'}", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                  Text(DateFormat('EEEE, d MMM • HH:mm', 'id_ID').format(schedule.date.toLocal()), style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses) {
    if (courses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: const Center(child: Text("Belum ada kursus yang tersedia.", style: TextStyle(color: Colors.grey))),
      );
    }
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailScreen(course: course)));
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(course.nama, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ====================================================================
  /// PERBAIKAN 2: Modifikasi `_buildTutorList` untuk menangani refresh
  /// ====================================================================
  Widget _buildTutorList(List<Tutor> tutors) {
    if (tutors.isEmpty) {
      return const Text("  Tidak ada rekomendasi tutor saat ini.");
    }
    final displayedTutors = tutors.length > 5 ? tutors.sublist(0, 5) : tutors;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayedTutors.length,
      itemBuilder: (context, index) {
        final tutor = displayedTutors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.2),
          surfaceTintColor: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: tutor.profilePicture != null ? NetworkImage(tutor.profilePicture!) : null,
              child: tutor.profilePicture == null ? const Icon(Icons.person, color: Colors.grey) : null,
              backgroundColor: Colors.grey[200],
            ),
            title: Text(tutor.nama ?? 'Nama Tutor', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: tutor.specialties.isNotEmpty
                ? Text(tutor.specialties.map((c) => c.nama).join(', '), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 12))
                : Text("Belum ada spesialisasi", style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(tutor.ratingMean.toStringAsFixed(1), style: TextStyle(color: Colors.grey[600])),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            onTap: () async {
              // Menunggu hasil dari TutorDetailScreen
              final didDataChange = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorDetailScreen(tutor: tutor),
                ),
              );
              // Jika ada perubahan data, refresh HomeScreen
              if (didDataChange == true) {
                _refreshHomeData();
              }
            },
          ),
        );
      },
    );
  }
}