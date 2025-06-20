// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User currentUser;
  const EditProfileScreen({super.key, required this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _bioController;
  late TextEditingController _noTelpController;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi form dengan data user yang sekarang
    _namaController = TextEditingController(text: widget.currentUser.nama);
    _bioController = TextEditingController(text: widget.currentUser.bio ?? '');
    _noTelpController = TextEditingController(text: widget.currentUser.noTelp ?? '');
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Siapkan data yang akan dikirim. Hanya kirim field yang berubah.
      Map<String, dynamic> dataToUpdate = {};
      if (_namaController.text != widget.currentUser.nama) {
        dataToUpdate['nama'] = _namaController.text;
      }
      if (_bioController.text != (widget.currentUser.bio ?? '')) {
        dataToUpdate['bio'] = _bioController.text;
      }
      if (_noTelpController.text != (widget.currentUser.noTelp ?? '')) {
        dataToUpdate['no_telp'] = _noTelpController.text;
      }

      if (dataToUpdate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada perubahan data.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      try {
        await _apiService.updateUser(widget.currentUser.id, dataToUpdate);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Kembali ke halaman profil dan beri sinyal untuk refresh
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noTelpController,
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
    