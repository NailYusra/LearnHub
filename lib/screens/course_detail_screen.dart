import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

// Import semua model, service, dan halaman yang relevan
import '../services/api_service.dart';
import '../models/course_model.dart';
import '../models/tutor_model.dart';
import '../models/user_model.dart';
import 'tutor_detail_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final ApiService _apiService = ApiService();
  Future<List<Tutor>>? _tutorsFuture;

  @override
  void initState() {
    super.initState();
    _tutorsFuture = _loadTutorsForCourse();
  }

  /// Fungsi untuk mengambil semua tutor yang memiliki spesialisasi
  /// pada kursus ini.
  Future<List<Tutor>> _loadTutorsForCourse() async {
    try {
      final (allTutors, allUsers, tutorCourseLinks) = await (
      _apiService.getTutors(),
      _apiService.getUsers(),
      _apiService.getTutorCourses(),
      ).wait;

      final userMap = {for (var u in allUsers) u.id: u};

      // 1. Cari semua ID tutor yang mengajar kursus ini
      final tutorIds = tutorCourseLinks
          .where((link) => link['course_id'] == widget.course.id)
          .map((link) => link['tutor_id'] as String)
          .toSet();

      // 2. Filter daftar tutor berdasarkan ID yang ditemukan
      final filteredTutors = allTutors.where((tutor) => tutorIds.contains(tutor.id)).toList();

      // 3. "Hias" data tutor dengan nama dan foto dari data user
      final enrichedTutors = filteredTutors.map((tutor) {
        final tutorUser = userMap[tutor.userId];
        // Kita juga bisa mengisi specialties di sini, meskipun tidak ditampilkan di halaman ini
        return Tutor(
          id: tutor.id,
          userId: tutor.userId,
          ratingMean: tutor.ratingMean,
          nama: tutorUser?.nama,
          profilePicture: tutorUser?.profilePicture,
          // Specialties di sini bisa diisi jika diperlukan di halaman detail tutor
        );
      }).toList();

      return enrichedTutors;

    } catch (e) {
      print("Gagal memuat tutor untuk kursus: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.nama),
      ),
      body: CustomScrollView(
        slivers: [
          // Header untuk info kursus
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tentang Kursus", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                  Text(widget.course.nama, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    "Cari dan jadwalkan sesi dengan tutor terbaik kami untuk mata kuliah ini.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),

          // Judul bagian daftar tutor
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Tutor yang Tersedia",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20),
              ),
            ),
          ),

          // Daftar tutor
          FutureBuilder<List<Tutor>>(
            future: _tutorsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(child: Center(child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                )));
              }
              if (snapshot.hasError) {
                return SliverToBoxAdapter(child: Center(child: Text("Gagal memuat data tutor: ${snapshot.error}")));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(child: Center(child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text("Belum ada tutor untuk kursus ini."),
                )));
              }

              final tutors = snapshot.data!;
              // Gunakan SliverList untuk menampilkan daftar di dalam CustomScrollView
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: _TutorCard(tutor: tutors[index]),
                    );
                  },
                  childCount: tutors.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Widget kartu tutor (bisa dibuat file terpisah di /widgets)
class _TutorCard extends StatelessWidget {
  final Tutor tutor;
  const _TutorCard({required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      surfaceTintColor: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: tutor.profilePicture != null ? NetworkImage(tutor.profilePicture!) : null,
          child: tutor.profilePicture == null ? const Icon(Icons.person) : null,
        ),
        title: Text(tutor.nama ?? 'Nama Tutor', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(tutor.ratingMean.toStringAsFixed(1)),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorDetailScreen(tutor: tutor),
            ),
          );
        },
      ),
    );
  }
}
