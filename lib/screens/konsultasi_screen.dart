import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

// Import semua model dan service yang relevan
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/tutor_model.dart';
import '../models/prodi_model.dart'; // <-- Pastikan model prodi di-impor
import 'tutor_detail_screen.dart';

class KonsultasiScreen extends StatefulWidget {
  const KonsultasiScreen({super.key});

  @override
  _KonsultasiScreenState createState() => _KonsultasiScreenState();
}

class _KonsultasiScreenState extends State<KonsultasiScreen> {
  final ApiService _apiService = ApiService();
  Future<List<Tutor>>? _processedTutorsFuture;
  List<Tutor> _allTutors = [];
  List<Tutor> _displayedTutors = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _processedTutorsFuture = _loadAndProcessTutorData();
    _searchController.addListener(_filterTutors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Tutor>> _loadAndProcessTutorData() async {
    try {
      // --- PERUBAHAN 1: Tambahkan getProdis() ---
      final (
      allTutorsRaw,
      allUsers,
      allCourses,
      tutorCourseLinks,
      allProdis // <-- Data baru
      ) = await (
      _apiService.getTutors(),
      _apiService.getUsers(),
      _apiService.getCourses(),
      _apiService.getTutorCourses(),
      _apiService.getProdis() // <-- Panggilan API baru
      ).wait;

      // Buat "peta" untuk pencarian data yang lebih cepat
      final userMap = {for (var u in allUsers) u.id: u};
      final courseMap = {for (var c in allCourses) c.id: c};
      final prodiMap = {for (var p in allProdis) p.id: p}; // <-- Peta baru untuk prodi

      // Gabungkan data
      final processedTutors = allTutorsRaw.map((tutorRaw) {
        final user = userMap[tutorRaw.userId];

        // --- PERUBAHAN 2: Cari nama prodi dari user ---
        final prodi = prodiMap[user?.prodiId];

        final specialties = tutorCourseLinks
            .where((link) => link['tutor_id'] == tutorRaw.id)
            .map((link) => courseMap[link['course_id']])
            .whereNotNull()
            .toList();

        return Tutor(
          id: tutorRaw.id,
          userId: tutorRaw.userId,
          ratingMean: tutorRaw.ratingMean,
          nama: user?.nama,
          profilePicture: user?.profilePicture,
          prodiNama: prodi?.nama, // <-- Gunakan nama prodi yang sudah ditemukan
          specialties: specialties,
        );
      }).toList();

      // Simpan ke state untuk digunakan oleh UI dan fitur pencarian
      if (mounted) {
        setState(() {
          _allTutors = processedTutors;
          _displayedTutors = _allTutors;
        });
      }

      return processedTutors;
    } catch (e) {
      print("Error memproses data tutor: $e");
      rethrow;
    }
  }

  void _filterTutors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayedTutors = _allTutors.where((tutor) {
        final nameMatch = tutor.nama?.toLowerCase().contains(query) ?? false;
        final specialtyMatch = tutor.specialties.any((course) => course.nama.toLowerCase().contains(query));
        return nameMatch || specialtyMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cari Tutor", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)),
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama tutor atau spesialisasi...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true, fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Tutor>>(
              future: _processedTutorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && _allTutors.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError && _allTutors.isEmpty) {
                  return Center(child: Text("Gagal memuat data.\n${snapshot.error}"));
                }
                if (_displayedTutors.isEmpty) {
                  return const Center(child: Text("Tutor tidak ditemukan."));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _processedTutorsFuture = _loadAndProcessTutorData();
                    });
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _displayedTutors.length,
                    itemBuilder: (context, index) {
                      return _TutorCard(tutor: _displayedTutors[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget terpisah untuk menampilkan kartu tutor dengan gaya visual baru.
class _TutorCard extends StatelessWidget {
  final Tutor tutor;
  const _TutorCard({required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      surfaceTintColor: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TutorDetailScreen(tutor: tutor)));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: tutor.profilePicture != null
                        ? NetworkImage(tutor.profilePicture!)
                        : null,
                    child: tutor.profilePicture == null
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tutor.nama ?? 'Nama Tutor',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        // --- PERUBAHAN 3: Tampilkan data prodi yang benar ---
                        Text(
                          tutor.prodiNama ?? 'Program Studi Tidak Diketahui',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        tutor.ratingMean.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              if (tutor.specialties.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tutor.specialties.map((course) => Chip(
                    label: Text(course.nama),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    labelStyle: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    side: BorderSide(color: Colors.transparent),
                  )).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
