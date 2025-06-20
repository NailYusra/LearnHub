import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/tutor_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LeaveReviewScreen extends StatefulWidget {
  final Tutor tutorToReview;

  const LeaveReviewScreen({super.key, required this.tutorToReview});

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _authService = AuthService();
  final _commentController = TextEditingController();

  double _rating = 3.0;
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Fungsi untuk mengirim review ke backend
  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        throw Exception("Sesi Anda tidak valid. Silakan login kembali.");
      }

      await _apiService.createReview({
        'user_id': userId,
        'tutor_id': widget.tutorToReview.id,
        'rating_tutor': _rating.toString(),
        'comment_review': _commentController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terima kasih atas ulasan Anda!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // =========================================================
      // PERUBAHAN UTAMA: Kembali satu layar dan kirim sinyal 'true'
      // =========================================================
      if (mounted) {
        Navigator.of(context).pop(true);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim ulasan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beri Ulasan untuk ${widget.tutorToReview.nama ?? 'Tutor'}'),
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: widget.tutorToReview.profilePicture != null
                      ? NetworkImage(widget.tutorToReview.profilePicture!)
                      : null,
                  child: widget.tutorToReview.profilePicture == null ? const Icon(Icons.person, size: 40) : null,
                ),
                const SizedBox(height: 16),
                Text(
                  "Bagaimana pengalaman Anda dengan\n${widget.tutorToReview.nama ?? 'Tutor'}?",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text('Rating: $_rating', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 32),

                CustomTextField(
                  controller: _commentController,
                  label: 'Tulis komentar Anda di sini...',
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Komentar tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Kirim Ulasan',
                      onPressed: _submitReview,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}