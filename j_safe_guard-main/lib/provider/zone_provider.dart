import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _subDistricts = [];
  String _selectedSubDistrict = '';
  List<String> _villages = [];

  List<String> get subDistricts => _subDistricts;
  String get selectedSubDistrict => _selectedSubDistrict;
  List<String> get villages => _villages;

  ZoneProvider() {
    fetchSubDistricts();
  }

  Future<void> fetchSubDistricts() async {
  try {
    QuerySnapshot kecamatanSnapshot =
        await _firestore.collection('kecamatan').get();

    _subDistricts.clear();

    for (QueryDocumentSnapshot doc in kecamatanSnapshot.docs) {
      // Ambil nama kecamatan dari ID dokumen
      String kecamatan = doc.id;

      // Tambahkan kecamatan ke dalam list jika belum ada
      if (!_subDistricts.contains(kecamatan)) {
        _subDistricts.add(kecamatan);
      }

      // Ambil koleksi Desa dari kecamatan saat ini
      QuerySnapshot desaSnapshot = await doc.reference.collection('Desa').get();

      // Iterasi melalui setiap dokumen Desa
      desaSnapshot.docs.forEach((desaDoc) {
        String desa = desaDoc.id;

        // Tambahkan desa ke dalam list jika belum ada
        if (!_villages.contains(desa)) {
          _villages.add(desa);
        }
      });
    }

    // Jika ada kecamatan yang berhasil diambil, atur kecamatan pertama sebagai selectedSubDistrict
    if (_subDistricts.isNotEmpty) {
      _selectedSubDistrict = _subDistricts[0];
    }

    notifyListeners();
  } catch (e) {
    print('Error fetching sub-districts: $e');
  }
}
void setSelectedSubDistrict(String subDistrict) {
  _selectedSubDistrict = subDistrict;
  notifyListeners(); // Notifikasi perubahan pada selectedSubDistrict
}
}
