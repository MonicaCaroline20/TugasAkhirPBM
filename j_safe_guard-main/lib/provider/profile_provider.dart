import 'package:flutter/material.dart';

// Model untuk profil
class Profile {
  final String id;
  final String username;
  final String email;
  final String password;

  Profile({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });
}

// Provider untuk mengelola data profil
class ProfileProvider extends ChangeNotifier {
  // Daftar profil
  List<Profile> _profiles = [];

  // Fungsi untuk menambahkan profil baru
  void addProfile(Profile profile) {
    _profiles.add(profile);
    notifyListeners();
  }

  // Fungsi untuk mendapatkan daftar semua profil
  List<Profile> getProfiles() {
    return _profiles;
  }

  // Fungsi untuk memperbarui profil
  void updateProfile(Profile newProfile) {
    final index = _profiles.indexWhere((profile) => profile.id == newProfile.id);
    if (index != -1) {
      _profiles[index] = newProfile;
      notifyListeners();
    }
  }

  // Fungsi untuk menghapus profil
  void deleteProfile(String id) {
    _profiles.removeWhere((profile) => profile.id == id);
    notifyListeners();
  }
}
