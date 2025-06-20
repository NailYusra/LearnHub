import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/certificate_model.dart';
import '../models/course_model.dart';
import '../models/review_model.dart';
import '../models/schedule_model.dart';
import '../models/tutor_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import 'chat_screen.dart';
import 'schedule_detail_screen.dart';

class TutorDetailScreen extends StatefulWidget {
  final Tutor tutor;
  const TutorDetailScreen({super.key, required this.tutor});

  @override
  _TutorDetailScreenState createState() => _TutorDetailScreenState();
}

class _TutorDetailScreenState extends State<TutorDetailScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  late Future<Map<String, dynamic>> _detailsFuture;
  User? _currentUser;
  bool _isLoadingDetails = true;
  bool _didDataChange = false;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadTutorDetails();
  }

  void _refreshTutorDetails() {
    setState(() {
      _isLoadingDetails = true;
      _detailsFuture = _loadTutorDetails();
    });
  }

  Future<Map<String, dynamic>> _loadTutorDetails() async {
    try {
      final currentUserId = await _authService.getUserId();
      if (currentUserId == null) throw Exception("Sesi tidak valid");

      final (allReviews, allUsers, allCertificates, kumpulanCertificates) = await (
      _apiService.getReviews(),
      _apiService.getUsers(),
      _apiService.getCertificates(),
      _apiService.getKumpulanCertificates(),
      ).wait;

      final userMap = {for (var u in allUsers) u.id: u};
      _currentUser = userMap[currentUserId];

      final tutorReviews = allReviews
          .where((review) => review.tutorId == widget.tutor.id)
          .map((review) {
        final reviewer = userMap[review.userId];
        return Review(
            id: review.id, userId: review.userId, tutorId: review.tutorId,
            ratingTutor: review.ratingTutor, commentReview: review.commentReview,
            reviewerName: reviewer?.nama, reviewerPhoto: reviewer?.profilePicture);
      }).toList();
      // Urutkan dari yang terbaru
      tutorReviews.sort((a, b) => b.id.compareTo(a.id));

      final certificateIds = kumpulanCertificates
          .where((kc) => kc['tutor_id'] == widget.tutor.id)
          .map((kc) => kc['certificate_id'] as String).toSet();
      final tutorCertificates = allCertificates.where((cert) => certificateIds.contains(cert.id)).toList();

      return {'reviews': tutorReviews, 'certificates': tutorCertificates};
    } finally {
      if(mounted) setState(() => _isLoadingDetails = false);
    }
  }

  void _showScheduleDialog() {
    Course? selectedCourse;
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    final bool hasSpecialties = widget.tutor.specialties.isNotEmpty;

    if (hasSpecialties) {
      selectedCourse = widget.tutor.specialties.first;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            final bool canConfirm = (selectedDate != null && selectedTime != null);
            return AlertDialog(
              title: const Text("Jadwalkan Sesi"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pilih Mata Kuliah:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (hasSpecialties)
                      DropdownButtonFormField<Course>(
                        value: selectedCourse,
                        isExpanded: true,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        items: widget.tutor.specialties.map((Course course) {
                          return DropdownMenuItem<Course>(value: course, child: Text(course.nama, overflow: TextOverflow.ellipsis));
                        }).toList(),
                        onChanged: (Course? newValue) {
                          dialogSetState(() => selectedCourse = newValue);
                        },
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                        child: const Center(
                          child: Text('Tutor belum punya spesialisasi.\nSesi akan dijadwalkan secara umum.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Text("Pilih Tanggal:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
                        if (picked != null) dialogSetState(() => selectedDate = picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(selectedDate == null ? 'Pilih Tanggal' : DateFormat('EEEE, d MMM yyyy', 'id_ID').format(selectedDate!)),
                            const Icon(Icons.calendar_today_outlined, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Pilih Waktu:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (picked != null) dialogSetState(() => selectedTime = picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(selectedTime == null ? 'Pilih Waktu' : selectedTime!.format(context)),
                            const Icon(Icons.access_time_outlined, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                FilledButton(
                  onPressed: canConfirm ? () {
                    final finalDateTime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute);
                    Navigator.pop(context); // Tutup dialog dulu
                    _createSchedule(selectedCourse, finalDateTime);
                  } : null,
                  child: const Text("Konfirmasi Jadwal"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _createSchedule(Course? course, DateTime dateTime) async {
    if (course == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak bisa menjadwalkan sesi tanpa memilih mata kuliah.'), backgroundColor: Colors.red));
      return;
    }

    try {
      if (_currentUser == null) throw Exception("Gagal mendapatkan info user.");

      final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

      final newScheduleData = await _apiService.createSchedule({
        'user_id': _currentUser!.id,
        'tutor_id': widget.tutor.id,
        'course_id': course.id,
        'date': formattedDate,
      });

      final newSchedule = Schedule.fromJson(newScheduleData['data']);

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil dibuat! Langsung mulai sesi?'), backgroundColor: Colors.green, duration: Duration(seconds: 5)),
        );

        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScheduleDetailScreen(schedule: newSchedule)),
        );

        if (result == true) {
          _refreshTutorDetails();
          _didDataChange = true;
        }
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat jadwal: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _didDataChange);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: const Text("Profil Tutor"),
                  pinned: true, floating: true,
                  backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 1,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context, _didDataChange),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildTutorHeader(widget.tutor),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverTabBarDelegate(
                    const TabBar(
                      indicatorColor: Colors.blueAccent, labelColor: Colors.blueAccent,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Sertifikat"),
                        Tab(text: "Ulasan"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: _isLoadingDetails
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<Map<String, dynamic>>(
              future: _detailsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text("Gagal memuat detail: ${snapshot.error}"));
                if (!snapshot.hasData) return const Center(child: Text("Tidak ada detail."));

                final details = snapshot.data!;
                final List<Certificate> certificates = details['certificates'];
                final List<Review> reviews = details['reviews'];

                return TabBarView(
                  children: [
                    _buildCertificateList(certificates),
                    _buildReviewList(reviews),
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Mulai Chat",
                    color: Colors.grey.shade700,
                    onPressed: _currentUser == null ? null : () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(recipientTutor: widget.tutor, currentUser: _currentUser!)));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: "Jadwalkan Sesi",
                    color: Colors.blueAccent,
                    onPressed: _showScheduleDialog,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTutorHeader(Tutor tutor) => Row(
    children: [
      CircleAvatar(radius: 40, backgroundImage: tutor.profilePicture != null ? NetworkImage(tutor.profilePicture!) : null, child: tutor.profilePicture == null ? const Icon(Icons.person, size: 40) : null),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tutor.nama ?? 'Nama Tutor', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 22),
                const SizedBox(width: 4),
                Text("${tutor.ratingMean.toStringAsFixed(1)} / 5.0", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      )
    ],
  );

  Widget _buildCertificateList(List<Certificate> certificates) {
    if (certificates.isEmpty) return const Center(child: Text("Tidak ada sertifikat untuk ditampilkan.", style: TextStyle(color: Colors.grey)));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final cert = certificates[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            height: 150,
            child: Row(
              children: [
                Image.network(cert.gambar, width: 120, height: 150, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cert.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Mata Kuliah: ${cert.mataKuliah}", style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewList(List<Review> reviews) {
    if (reviews.isEmpty) return const Center(child: Text("Belum ada ulasan.", style: TextStyle(color: Colors.grey)));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 16, backgroundImage: review.reviewerPhoto != null ? NetworkImage(review.reviewerPhoto!) : null, child: review.reviewerPhoto == null ? const Icon(Icons.person, size: 16) : null),
                    const SizedBox(width: 8),
                    Expanded(child: Text(review.reviewerName ?? 'Anonim', style: const TextStyle(fontWeight: FontWeight.bold))),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(review.ratingTutor.toStringAsFixed(1)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(review.commentReview),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Material(color: Colors.white, elevation: overlapsContent ? 2.0 : 0.0, child: _tabBar);

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}