import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forum_post_model.dart';
import '../models/answer_forum_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ForumDetailScreen extends StatefulWidget {
  final ForumPost post;
  const ForumDetailScreen({super.key, required this.post});

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  // Mengubah tipe Future untuk menampung data gabungan
  late Future<Map<String, dynamic>> _detailsFuture;
  // State baru untuk melacak voting
  Map<String, bool> _isVoting = {}; // Map untuk melacak status loading per jawaban

  final _formKey = GlobalKey<FormState>();
  final _answerController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  // Mengubah fungsi ini untuk memuat jawaban DAN pengguna
  Future<Map<String, dynamic>> _loadDetails() async {
    try {
      final (allAnswersRaw, allUsers) = await (
      _apiService.getAnswerForums(),
      _apiService.getUsers(),
      ).wait;

      // Filter jawaban yang sesuai dengan ID forum ini
      final answersForThisPost = allAnswersRaw
          .where((answer) => answer.forumId == widget.post.id)
          .toList();

      return {
        'answers': answersForThisPost,
        'users': allUsers,
      };
    } catch (e) {
      rethrow;
    }
  }

  void _submitAnswer() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      try {
        final userId = await _authService.getUserId();
        if (userId == null) throw Exception("Anda harus login untuk menjawab.");

        await _apiService.createAnswerForum({
          'forum_id': widget.post.id,
          'user_id': userId,
          'answer': _answerController.text,
        });

        _answerController.clear();
        FocusScope.of(context).unfocus();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jawaban berhasil dikirim!'), backgroundColor: Colors.green),
        );

        // Muat ulang data detail untuk menampilkan jawaban baru
        setState(() {
          _detailsFuture = _loadDetails();
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  /// Fungsi baru yang lebih cerdas untuk menangani voting
  void _handleVote(AnswerForum answer, bool isLiking) async {
    if (_isVoting[answer.id] == true) return;

    final currentUserId = await _authService.getUserId();
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Anda harus login untuk vote.")));
      return;
    }

    setState(() => _isVoting[answer.id] = true);

    // Tentukan status vote pengguna saat ini
    final bool alreadyLiked = answer.likedBy.contains(currentUserId);
    final bool alreadyDisliked = answer.dislikedBy.contains(currentUserId);

    // Terapkan logika vote di UI terlebih dahulu (Optimistic Update)
    if (isLiking) { // Jika tombol Like ditekan
      if (alreadyLiked) { // Jika sudah di-like -> unlike
        answer.likedBy.remove(currentUserId);
      } else { // Jika belum di-like
        answer.likedBy.add(currentUserId);
        if (alreadyDisliked) { // Jika sebelumnya di-dislike -> hapus dislike
          answer.dislikedBy.remove(currentUserId);
        }
      }
    } else { // Jika tombol Dislike ditekan
      if (alreadyDisliked) { // Jika sudah di-dislike -> un-dislike
        answer.dislikedBy.remove(currentUserId);
      } else { // Jika belum di-dislike
        answer.dislikedBy.add(currentUserId);
        if (alreadyLiked) { // Jika sebelumnya di-like -> hapus like
          answer.likedBy.remove(currentUserId);
        }
      }
    }
    // Perbarui UI secara lokal
    setState(() {});

    try {
      // Kirim state array yang baru ke backend
      await _apiService.updateAnswerForum(answer.id, {
        'liked_by': answer.likedBy,
        'disliked_by': answer.dislikedBy,
      });
    } catch (e) {
      // Jika gagal, kembalikan state ke semula
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal melakukan vote: $e')));
      setState(() {
        // Logika untuk mengembalikan state jika error (bisa diimplementasikan lebih lanjut)
        // Untuk saat ini kita muat ulang saja datanya
        _detailsFuture = _loadDetails();
      });
    } finally {
      if (mounted) setState(() => _isVoting[answer.id] = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Diskusi")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat detail: ${snapshot.error}"));
          }

          final List<AnswerForum> answers = snapshot.data?['answers'] ?? [];
          final List<User> users = snapshot.data?['users'] ?? [];
          final userMap = {for (var u in users) u.id: u};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuestionSection(widget.post),
                const Divider(height: 32, thickness: 1, color: Colors.black12),
                _buildAnswerForm(),
                const Divider(height: 32, thickness: 1, color: Colors.black12),

                Text("Jawaban (${answers.length})", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20)),
                const SizedBox(height: 16),
                if (answers.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text("Belum ada jawaban. Jadilah yang pertama!", style: TextStyle(color: Colors.grey)),
                  ))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      final answer = answers[index];
                      // Cari data user yang menjawab
                      final answerer = userMap[answer.userId];
                      return _buildAnswerCard(answer, answerer);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Widget Builder ---

  Widget _buildAnswerForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tulis Jawaban Anda", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _answerController,
            label: 'Ketik jawaban di sini...',
            maxLines: 4,
            validator: (value) => value!.isEmpty ? 'Jawaban tidak boleh kosong' : null,
          ),
          const SizedBox(height: 12),
          _isSubmitting
              ? const Center(child: CircularProgressIndicator())
              : CustomButton(
            text: 'Kirim Jawaban',
            onPressed: _submitAnswer,
          )
        ],
      ),
    );
  }

  Widget _buildQuestionSection(ForumPost post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(post.headerQuestion, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Row(children: [
          CircleAvatar(radius: 16, backgroundImage: post.user?.profilePicture != null ? NetworkImage(post.user!.profilePicture!) : null, child: post.user?.profilePicture == null ? const Icon(Icons.person, size: 16) : null),
          const SizedBox(width: 8),
          Text(post.user?.nama ?? 'Anonim', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text('• ${DateFormat('d MMM<y_bin_46>').format(post.date)}', style: const TextStyle(color: Colors.grey)),
        ]),
        const SizedBox(height: 16),
        Text(post.question, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5, fontSize: 16)),
      ],
    );
  }

  // Widget ini sekarang menerima objek User tambahan
  Widget _buildAnswerCard(AnswerForum answer, User? answerer) {
    // State untuk loading saat voting
    bool isCurrentlyVoting = _isVoting[answer.id] ?? false;
    final currentUserId = _authService.getUserId().toString();

    // Cek status vote user ini
    final bool isLiked = answer.likedBy.contains(currentUserId);
    final bool isDisliked = answer.dislikedBy.contains(currentUserId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header (Info Penjawab)
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: answerer?.profilePicture != null
                      ? NetworkImage(answerer!.profilePicture!)
                      : null,
                  child: answerer?.profilePicture == null
                      ? const Icon(Icons.person_outline, size: 18)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  answerer?.nama ?? 'User tidak dikenal',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  DateFormat('d MMM, HH:mm').format(answer.date.toLocal()),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Isi Jawaban
            Text(answer.answer, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 8),

            // --- BAGIAN LIKE & DISLIKE ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isCurrentlyVoting)
                  const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  Row(
                    children: [
                      // Tombol Like
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                          size: 18,
                          color: isLiked ? Theme.of(context).primaryColor : Colors.grey[700],
                        ),
                        onPressed: () => _handleVote(answer, true),
                      ),
                      Text(answer.likeCount.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      // Tombol Dislike
                      IconButton(
                        icon: Icon(
                          isDisliked ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined,
                          size: 18,
                          color: isDisliked ? Colors.red[700] : Colors.grey[700],
                        ),
                        onPressed: () => _handleVote(answer, false),
                      ),
                      Text(answer.dislikeCount.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
