import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class CreateForumScreen extends StatefulWidget {
  const CreateForumScreen({super.key});

  @override
  _CreateForumScreenState createState() => _CreateForumScreenState();
}

class _CreateForumScreenState extends State<CreateForumScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _questionController = TextEditingController();
  final _apiService = ApiService();
  final _authService = AuthService();
  bool _isLoading = false;

  void _submitPost() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final userId = await _authService.getUserId();
        if (userId == null) {
          throw Exception("Sesi tidak valid, silakan login ulang.");
        }

        await _apiService.createForum({
          'user_id': userId,
          'header_question': _titleController.text,
          'question': _questionController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pertanyaan berhasil diposting!'), backgroundColor: Colors.green),
        );
        // Kembali ke halaman forum dan beri sinyal untuk refresh
        if (mounted) Navigator.pop(context, true);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buat Pertanyaan Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Judul Pertanyaan',
                validator: (value) => value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _questionController,
                label: 'Jelaskan pertanyaan Anda di sini...',
                maxLines: 10,
                validator: (value) => value!.isEmpty ? 'Isi pertanyaan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                text: 'Posting Pertanyaan',
                onPressed: _submitPost,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
