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
import '../models/forum_post_model.dart';
import '../models/review_model.dart';
import '../models/faculty_model.dart';
import '../models/prodi_model.dart';
// Import halaman detail untuk navigasi
import 'edit_profile_screen.dart';
import 'auth_wrapper.dart';
import 'course_detail_screen.dart';
import 'schedule_detail_screen.dart';
import 'forum_detail_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  Future<Map<String, dynamic>>? _profileDataFuture;

  @override
  void initState() {
    super.initState();
    _profileDataFuture = _loadProfileData();
  }

  /// Fungsi utama untuk mengambil semua data yang dibutuhkan,
  // GANTI FUNGSI LAMA ANDA DENGAN YANG INI SECARA KESELURUHAN

  /// Fungsi utama yang telah disesuaikan dengan sistem autentikasi.
  Future<Map<String, dynamic>> _loadProfileData() async {
    try {
      final currentUserId = await _authService.getUserId();
      if (currentUserId == null) {
        throw Exception("Sesi tidak valid.");
      }

      // Ambil semua data master
      // --- PERBAIKAN SINTAKS DI SINI ---
      // Menggunakan Future.wait([...]) yang benar
      final results = await Future.wait([
        _apiService.getUsers(),
        _apiService.getProdis(),
        _apiService.getFaculties(),
        _apiService.getCourses(),
        _apiService.getTutors(),
        _apiService.getSchedules(),
        _apiService.getCourseTakens(),
        _apiService.getForums(),
        _apiService.getReviews(),
        _apiService.getTutorCourses(),
      ]);

      // Mengambil hasil dari list 'results' satu per satu
      final allUsers = results[0] as List<User>;
      final allProdis = results[1] as List<Prodi>;
      final allFaculties = results[2] as List<Faculty>;
      final allCourses = results[3] as List<Course>;
      final allTutors = results[4] as List<Tutor>;
      final allSchedules = results[5] as List<Schedule>;
      final allCourseTakens = results[6] as List<Map<String, dynamic>>;
      final allForums = results[7] as List<ForumPost>;
      final allReviews = results[8] as List<Review>;
      final tutorCourseLinks = results[9] as List<Map<String, dynamic>>;

      // Buat "peta" untuk pencarian cepat
      final userMap = {for (var u in allUsers) u.id: u};
      final courseMap = {for (var c in allCourses) c.id: c};
      final prodiMap = {for (var p in allProdis) p.id: p};
      final facultyMap = {for (var f in allFaculties) f.id: f};
      final tutorMap = {for (var t in allTutors) t.id: t};

      final User? currentUserRaw = userMap[currentUserId];
      if (currentUserRaw == null) throw Exception("User sesi tidak ditemukan di database.");

      // "Hias" data User
      final prodi = prodiMap[currentUserRaw.prodiId];
      final faculty = facultyMap[prodi?.facultyId];
      final Map<String, dynamic> enrichedUser = {
        'user': currentUserRaw,
        'prodiName': prodi?.nama ?? 'N/A',
        'facultyName': faculty?.nama ?? 'N/A',
      };

      // Filter aktivitas user

      // **PERBAIKAN 1: Logika untuk "Kursus Saya" dengan Nama Tutor**
      final myCourseIds = allCourseTakens
          .where((ct) => ct['user_id'] == currentUserId).map((ct) => ct['course_id'] as String).toSet();
      final myCoursesRaw = allCourses.where((c) => myCourseIds.contains(c.id)).toList();

      // "Hias" setiap kursus dengan nama tutor pertamanya
      final myCourses = myCoursesRaw.map((course) {
        final tutorId = tutorCourseLinks.firstWhereOrNull((link) => link['course_id'] == course.id)?['tutor_id'];
        final tutor = tutorMap[tutorId];
        final tutorUser = userMap[tutor?.userId];
        return {
          'course': course,
          'tutorName': tutorUser?.nama ?? 'Belum ada tutor',
        };
      }).toList();


      // **PERBAIKAN 2: Logika untuk "Jadwal Saya" agar tidak N/A**
      final mySchedules = allSchedules
          .where((s) => s.userId == currentUserId)
          .map((s) {
        // Pastikan data relasi ada sebelum mengambil nama
        final tutor = tutorMap[s.tutorId];
        final tutorUser = userMap[tutor?.userId];
        final course = courseMap[s.courseId];

        return Schedule(
          id: s.id, userId: s.userId, tutorId: s.tutorId, courseId: s.courseId, date: s.date,
          tutorName: tutorUser?.nama,
          courseName: course?.nama,
        );
      }).toList();

      final myForumPosts = allForums.where((f) => f.userId == currentUserId).toList();

      final Tutor? myTutorProfile = allTutors.firstWhereOrNull((t) => t.userId == currentUserId);
      Map<String, dynamic> tutorData = {'isTutor': false};
      if (myTutorProfile != null) {
        final reviewsForMe = allReviews.where((r) => r.tutorId == myTutorProfile.id).toList();
        tutorData = {'isTutor': true, 'profile': myTutorProfile, 'reviews': reviewsForMe};
      }

      return {
        'enrichedUser': enrichedUser, 'myCourses': myCourses, 'mySchedules': mySchedules,
        'myForumPosts': myForumPosts, 'tutorData': tutorData,
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Fungsi untuk menangani proses logout
  void _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat profil: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Tidak ada data."));
          }

          final data = snapshot.data!;
          final enrichedUser = data['enrichedUser'];
          final User currentUser = enrichedUser['user'];
          final bool isTutor = data['tutorData']['isTutor'];

          // Menggabungkan semua list aktivitas ke dalam satu map untuk TabBar
          final Map<String, List<dynamic>> activityTabs = {
            'Kursus Saya': data['myCourses'],
            'Jadwal Saya': data['mySchedules'],
            'Forum Saya': data['myForumPosts'],
          };

          if (isTutor) {
            activityTabs['Ulasan Diterima'] = data['tutorData']['reviews'];
          }

          return DefaultTabController(
            length: activityTabs.length,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false, pinned: true, stretch: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    iconTheme: const IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      background: _buildProfileHeader(currentUser, enrichedUser['prodiName'], enrichedUser['facultyName']),
                    ),
                    actions: [
                      IconButton(icon: const Icon(Icons.logout_outlined), tooltip: 'Logout', onPressed: _handleLogout)
                    ],
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverTabBarDelegate(
                      TabBar(
                        isScrollable: true,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: Theme.of(context).primaryColor,
                        tabs: activityTabs.keys.map((title) => Tab(text: title)).toList(),
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                // Menggunakan map untuk membuat view secara dinamis
                children: activityTabs.entries.map((entry) {
                  final title = entry.key;
                  final items = entry.value;
                  String type = 'unknown';
                  if (title == 'Kursus Saya') type = 'kursus';
                  if (title == 'Jadwal Saya') type = 'jadwal';
                  if (title == 'Forum Saya') type = 'forum';
                  if (title == 'Ulasan Diterima') type = 'ulasan';
                  return _buildActivityList(items, type);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(User user, String prodiName, String facultyName) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: user.profilePicture != null ? NetworkImage(user.profilePicture!) : null,
                    child: user.profilePicture == null ? Icon(Icons.person, size: 50, color: Theme.of(context).primaryColor) : null,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen(currentUser: user)),
                        ).then((isUpdated) {
                          if (isUpdated == true) { setState(() { _profileDataFuture = _loadProfileData(); }); }
                        });
                      },
                      child: CircleAvatar(
                        radius: 18, backgroundColor: Colors.white,
                        child: Icon(Icons.edit, color: Theme.of(context).primaryColor, size: 20),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Text(user.nama, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.9))),
              const SizedBox(height: 8),
              // PENYESUAIAN 1: Menampilkan Prodi dan Fakultas
              if (prodiName != 'N/A')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text('$prodiName • $facultyName', style: const TextStyle(fontSize: 14, color: Colors.white)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList(List<dynamic> items, String type) {
    if (items.isEmpty) {
      return const Center(child: Text("Tidak ada aktivitas untuk ditampilkan."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        IconData icon;
        String title;
        String subtitle;
        VoidCallback? onTapAction;

        switch (type) {
          case 'kursus':
          // Sekarang 'item' adalah Map, bukan objek Course langsung
            final courseData = item as Map<String, dynamic>;
            final course = courseData['course'] as Course;
            final tutorName = courseData['tutorName'] as String;

            icon = Icons.school_outlined;
            title = course.nama;
            subtitle = 'Tutor: $tutorName'; // <-- Subtitle baru
            onTapAction = () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)));
            };
            break;
          case 'jadwal':
            final schedule = item as Schedule;
            icon = Icons.calendar_today_outlined;
            title = "Konsultasi: ${schedule.courseName ?? 'Kursus Dihapus'}"; // <-- Fallback lebih baik
            subtitle = "dengan ${schedule.tutorName ?? 'Tutor Dihapus'}\npada ${DateFormat('d MMM, HH:mm').format(schedule.date.toLocal())}";
            onTapAction = () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduleDetailScreen(schedule: schedule)));
            };
            break;
          case 'forum':
            final post = item as ForumPost;
            icon = Icons.forum_outlined;
            title = post.headerQuestion;
            subtitle = 'Diposting pada ${DateFormat('d MMM, yyyy').format(post.date.toLocal())}';
            onTapAction = () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ForumDetailScreen(post: post)));
            };
            break;
          case 'ulasan':
            final review = item as Review;
            icon = Icons.star_border;
            title = 'Rating: ${review.ratingTutor} ★';
            subtitle = review.commentReview;
            onTapAction = null;
            break;
          default:
            icon = Icons.help_outline;
            title = 'Data tidak diketahui';
            subtitle = '';
            onTapAction = null;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(icon, color: Theme.of(context).primaryColor),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(subtitle),
            isThreeLine: type == 'jadwal',
            onTap: onTapAction,
            trailing: onTapAction != null ? const Icon(Icons.chevron_right, color: Colors.grey) : null,
          ),
        );
      },
    );
  }
}


// Helper class untuk membuat TabBar tetap terlihat saat di-scroll (sticky)
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      // Gunakan 'overlapsContent' yang merupakan parameter valid di sini
      elevation: overlapsContent ? 2.0 : 0.0,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
