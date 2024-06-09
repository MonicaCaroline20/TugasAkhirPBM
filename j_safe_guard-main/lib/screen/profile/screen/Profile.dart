import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_j_safe_guard/provider/profile_provider.dart';
import 'package:tes_j_safe_guard/provider/user_provider.dart';
import 'package:tes_j_safe_guard/screen/login/screen/loginpage.dart';

import '../../../navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  late UserProvider _userProvider;
  late ProfileProvider _profileProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
    _profileProvider = Provider.of<ProfileProvider>(context);

    // Set data profil pengguna saat halaman diinisialisasi
    _usernameController.text = _userProvider.name;
    _emailController.text = _userProvider.email;
  }

  void _saveProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Apakah Anda yakin ingin menyimpan perubahan ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performSave();
            },
            child: Text('Ya'),
          ),
        ],
      ),
    );
  }

  void _performSave() {
    // Update data pengguna dari input TextField
    _userProvider.updateUser(
      _usernameController.text,
      _emailController.text,
    );

    // Memperbarui password jika field password tidak kosong
    if (_newPasswordController.text.isNotEmpty) {
      _userProvider.updatePassword(_newPasswordController.text);
    }

    // Bersihkan nilai TextField setelah menyimpan perubahan
    _newPasswordController.clear();

    // Membuat profil baru dari data yang diisi dalam TextField
    final newProfile = Profile(
      id: UniqueKey().toString(), // Menggunakan UniqueKey sebagai ID
      username: _usernameController.text,
      email: _emailController.text, password: '',
    );

    // Menambahkan profil baru ke dalam ProfileProvider
    _profileProvider.addProfile(newProfile);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Apakah anda yakin ingin keluar dari akun ini ?',
        onConfirm: () {
          Navigator.of(context).pop(); // Close the dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()), // Navigate to login page
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('lib/image/profile.jpg'),
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    // Add function to change profile picture
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF004AAD),
                    ),
                    child: const Text('Save Information'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 5),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;

  const CustomAlertDialog(
      {Key? key, required this.title, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF004AAD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(title),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
          child: const Text('Tidak'),
        ),
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
          child: const Text('Ya'),
        ),
      ],
    );
  }
}
