import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import semua model dan service yang relevan
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../models/forum_post_model.dart';
import '../models/answer_forum_model.dart';
// Impor widget kustom jika diperlukan, misal: CustomButton
// import '../widgets/custom_button.dart';

import 'create_forum_screen.dart';
import 'forum_detail_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final ApiService _apiService = ApiService();
  Future<List<ForumPost>>? _processedForumsFuture;

  // State untuk mengelola fungsionalitas pencarian
  List<ForumPost> _allPosts = [];
  List<ForumPost> _displayedPosts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _processedForumsFuture = _loadAndProcessForumData();
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPosts);
    _searchController.dispose();
    super.dispose();
  }

  /// Fungsi utama untuk mengambil semua data yang dibutuhkan,
  /// lalu menggabungkannya menjadi daftar objek ForumPost yang siap ditampilkan.
  Future<List<ForumPost>> _loadAndProcessForumData() async {
    try {
      final (allForumsRaw, allUsers, allAnswers) = await (
      _apiService.getForums(),
      _apiService.getUsers(),
      _apiService.getAnswerForums()
      ).wait;

      final userMap = {for (var u in allUsers) u.id: u};

      final answerCountMap = <String, int>{};
      for (var answer in allAnswers) {
        answerCountMap.update(answer.forumId, (value) => value + 1, ifAbsent: () => 1);
      }

      final processedPosts = allForumsRaw.map((post) {
        return ForumPost(
          id: post.id,
          userId: post.userId,
          headerQuestion: post.headerQuestion,
          question: post.question,
          date: post.date,
          user: userMap[post.userId],
          answerCount: answerCountMap[post.id] ?? 0,
        );
      }).toList()
        ..sort((a,b) => b.date.compareTo(a.date)); // Urutkan dari yang terbaru

      setState(() {
        _allPosts = processedPosts;
        _displayedPosts = _allPosts;
      });

      return processedPosts;
    } catch (e) {
      print("Error memuat data forum: $e");
      rethrow;
    }
  }

  /// Memfilter daftar forum yang ditampilkan berdasarkan query pencarian.
  void _filterPosts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayedPosts = _allPosts.where((post) {
        final titleMatch = post.headerQuestion.toLowerCase().contains(query);
        final userMatch = post.user?.nama.toLowerCase().contains(query) ?? false;
        return titleMatch || userMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum Diskusi", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari judul pertanyaan atau nama...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          // Daftar Forum
          Expanded(
            child: FutureBuilder<List<ForumPost>>(
              future: _processedForumsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && _allPosts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError && _allPosts.isEmpty) {
                  return Center(child: Text("Gagal memuat data.\n${snapshot.error}"));
                }
                if (_displayedPosts.isEmpty) {
                  return const Center(child: Text("Diskusi tidak ditemukan."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _displayedPosts.length,
                  itemBuilder: (context, index) {
                    return _ForumPostCard(post: _displayedPosts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi untuk membuka halaman/dialog membuat forum baru
          // AKSI BARU: Navigasi ke halaman buat forum
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateForumScreen())
          ).then((isPosted) {
            // Refresh daftar forum jika user berhasil membuat postingan baru
            if (isPosted == true) {
              setState(() {
                _processedForumsFuture = _loadAndProcessForumData();
              });
            }
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add_comment_outlined, color: Colors.white),
        tooltip: 'Buat Pertanyaan Baru',
      ),
    );
  }
}

/// Widget terpisah untuk menampilkan kartu forum dengan gaya visual baru.
class _ForumPostCard extends StatelessWidget {
  final ForumPost post;
  const _ForumPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      surfaceTintColor: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Aksi saat di-tap: Navigasi ke Halaman Detail Forum
          // AKSI BARU: Navigasi ke Halaman Detail Forum
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForumDetailScreen(post: post)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: post.user?.profilePicture != null
                        ? NetworkImage(post.user!.profilePicture!)
                        : null,
                    child: post.user?.profilePicture == null
                        ? const Icon(Icons.person, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.user?.nama ?? 'User Anonim',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(post.date.toLocal()),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Content: Judul pertanyaan
              Text(
                post.headerQuestion,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Footer: Jumlah jawaban dan tombol lihat
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.comment_outlined, size: 16, color: Colors.grey[700]),
                        const SizedBox(width: 6),
                        Text(
                          '${post.answerCount} Jawaban',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

