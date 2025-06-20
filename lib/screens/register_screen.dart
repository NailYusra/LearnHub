import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/prodi_model.dart'; // Impor model Prodi
// Impor widget kustom Anda
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _noTelpController = TextEditingController();

  // Hapus _prodiIdController dan ganti dengan variabel ini
  String? _selectedProdiId;
  late Future<List<Prodi>> _prodisFuture;

  final _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Ambil daftar prodi saat halaman pertama kali dimuat
    _prodisFuture = _apiService.getProdis();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Siapkan data untuk dikirim ke API
        Map<String, String> userData = {
          'nama': _namaController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'password_confirmation': _passwordController.text,
          if (_noTelpController.text.isNotEmpty) 'no_telp': _noTelpController.text,
          // Gunakan _selectedProdiId yang sudah tersimpan
          if (_selectedProdiId != null) 'prodi_id': _selectedProdiId!,
        };

        await _apiService.registerUser(userData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) Navigator.pop(context);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
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
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _noTelpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Akun Baru"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Buat Akun Anda",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _namaController,
                  label: 'Nama Lengkap',
                  validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Masukkan alamat email yang valid';
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password minimal 6 karakter';
                    if (value.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _noTelpController,
                  label: 'Nomor Telepon (Opsional)',
                ),
                const SizedBox(height: 8),

                // -- INI BAGIAN DROPDOWN BARU --
                FutureBuilder<List<Prodi>>(
                  future: _prodisFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const CustomTextField(label: 'Gagal memuat prodi');
                    }

                    final prodis = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedProdiId,
                        decoration: InputDecoration(
                          labelText: 'Program Studi (Opsional)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.blue[50],
                        ),
                        hint: const Text('Pilih Prodi'),
                        items: prodis.map((Prodi prodi) {
                          return DropdownMenuItem<String>(
                            value: prodi.id, // Nilai yang disimpan adalah ID
                            child: Text(prodi.nama), // Teks yang ditampilkan adalah Nama
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProdiId = newValue;
                          });
                        },
                      ),
                    );
                  },
                ),
                // -- AKHIR BAGIAN DROPDOWN --

                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                  text: 'Daftar',
                  onPressed: _handleRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
