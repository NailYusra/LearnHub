import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/schedule_model.dart';
import '../models/user_model.dart';
import '../models/tutor_model.dart';
import '../services/api_service.dart';
import '../widgets/custom_button.dart';
import 'live_session_screen.dart';
import 'leave_review_screen.dart';

class ScheduleDetailScreen extends StatefulWidget {
  final Schedule schedule;
  const ScheduleDetailScreen({super.key, required this.schedule});

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _detailsFuture;
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;
  Tutor? _currentTutor;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadDetails() async {
    try {
      final (allUsers, allTutors) = await (
      _apiService.getUsers(),
      _apiService.getTutors()
      ).wait;

      final user = allUsers.firstWhere((u) => u.id == widget.schedule.userId);
      final tutorData = allTutors.firstWhere((t) => t.id == widget.schedule.tutorId);
      final tutorUser = allUsers.firstWhere((u) => u.id == tutorData.userId);

      _currentTutor = Tutor(
        id: tutorData.id,
        userId: tutorData.userId,
        ratingMean: tutorData.ratingMean,
        nama: tutorUser.nama,
        profilePicture: tutorUser.profilePicture,
        specialties: tutorData.specialties,
      );

      return {'user': user, 'tutorUser': tutorUser};
    } catch (e) {
      rethrow;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        _timer?.cancel();
        return;
      }
      final now = DateTime.now();
      final difference = widget.schedule.date.toLocal().isAfter(now)
          ? widget.schedule.date.toLocal().difference(now)
          : Duration.zero;
      setState(() => _timeRemaining = difference);
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds <= 0) return "Waktu sesi telah tiba atau berakhir.";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$days hari $hours jam $minutes menit $seconds detik";
  }

  void _handleCancelSchedule() async {
    final bool? shouldCancel = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Konfirmasi Pembatalan'),
        content: const Text('Apakah Anda yakin ingin membatalkan jadwal sesi ini?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Tidak'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (shouldCancel == true && mounted) {
      try {
        await _apiService.deleteSchedule(widget.schedule.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil dibatalkan'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membatalkan jadwal: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Jadwal Sesi")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat detail: ${snapshot.error}"));
          }

          final User student = snapshot.data!['user'];
          final User tutorUser = snapshot.data!['tutorUser'];

          final sessionTime = widget.schedule.date.toLocal();
          final now = DateTime.now();
          final bool canStartSession = now.isAfter(sessionTime.subtract(const Duration(minutes: 10))) &&
              now.isBefore(sessionTime.add(const Duration(minutes: 60)));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCourseHeader(widget.schedule.courseName ?? "Sesi Umum"),
                const SizedBox(height: 24),
                _buildSectionTitle("Peserta"),
                _buildParticipantCard(student, "Siswa"),
                _buildParticipantCard(tutorUser, "Tutor"),
                const Divider(height: 32),
                _buildSectionTitle("Waktu Sesi"),
                _buildTimeInfo(),
                const Spacer(),
                CustomButton(
                  text: "Mulai Sesi",
                  onPressed: canStartSession ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveSessionScreen(
                          schedule: widget.schedule,
                          student: student,
                          tutorUser: tutorUser,
                        ),
                      ),
                    ).then((sessionEnded) {
                      if (sessionEnded == true && _currentTutor != null && mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LeaveReviewScreen(tutorToReview: _currentTutor!),
                          ),
                        );
                      }
                    });
                  } : null,
                ),
                const SizedBox(height: 8),
                CustomButton(
                  text: "Batalkan Jadwal",
                  color: Theme.of(context).primaryColor,
                  onPressed: _handleCancelSchedule,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseHeader(String courseName) => Text(
    courseName,
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
  );

  Widget _buildSectionTitle(String title) => Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20));

  Widget _buildParticipantCard(User participant, String role) => Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: participant.profilePicture != null ? NetworkImage(participant.profilePicture!) : null,
        child: participant.profilePicture == null ? const Icon(Icons.person) : null,
      ),
      title: Text(participant.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(role),
    ),
  );

  Widget _buildTimeInfo() => Card(
    color: Colors.blue.shade50,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            DateFormat('EEEE, d MMMM yyyy • HH:mm', 'id_ID').format(widget.schedule.date.toLocal()),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            "Sesi akan dimulai dalam:",
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDuration(_timeRemaining),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blueAccent),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}