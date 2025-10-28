import '../models/obat_model.dart';

class ObatService {
  static List<Obat> _daftarObat = [];

  // Get all obat
  static List<Obat> getAllObat() {
    return _daftarObat;
  }

  // Get obat by kategori waktu
  static List<Obat> getObatByKategori(String kategori) {
    return _daftarObat.where((obat) => obat.kategoriWaktu == kategori).toList();
  }

  // Add obat
  static void addObat(Obat obat) {
    _daftarObat.add(obat);
  }

  // Update obat
  static void updateObat(Obat obat) {
    final index = _daftarObat.indexWhere((o) => o.id == obat.id);
    if (index != -1) {
      _daftarObat[index] = obat;
    }
  }

  // Delete obat
  static void deleteObat(String id) {
    _daftarObat.removeWhere((obat) => obat.id == id);
  }

  // Tandai sudah diminum
  static void tandaiSudahDiminum(String id) {
    final index = _daftarObat.indexWhere((o) => o.id == id);
    if (index != -1) {
      _daftarObat[index] = _daftarObat[index].copyWith(sudahDiminum: true);
    }
  }

  // AI: Rekomendasi waktu optimal untuk obat
  static Map<String, String> rekomendasiWaktuObat(String jenisObat) {
    // Simple AI logic berdasarkan jenis obat
    final jenisLower = jenisObat.toLowerCase();

    if (jenisLower.contains('vitamin') || jenisLower.contains('suplemen')) {
      return {
        'waktu': '08:00',
        'kategori': 'pagi',
        'instruksi': 'Sebelum Makan',
        'alasan': 'Vitamin lebih baik diserap saat perut kosong di pagi hari'
      };
    } else if (jenisLower.contains('darah') || jenisLower.contains('hipertensi')) {
      return {
        'waktu': '12:00',
        'kategori': 'siang',
        'instruksi': 'Sesudah Makan',
        'alasan': 'Obat tekanan darah optimal diminum siang hari setelah makan'
      };
    } else if (jenisLower.contains('tidur') || jenisLower.contains('insomnia')) {
      return {
        'waktu': '21:00',
        'kategori': 'malam',
        'instruksi': 'Sebelum Tidur',
        'alasan': 'Obat tidur sebaiknya diminum 1 jam sebelum tidur'
      };
    } else if (jenisLower.contains('nyeri') || jenisLower.contains('sakit')) {
      return {
        'waktu': '20:00',
        'kategori': 'malam',
        'instruksi': 'Sesudah Makan',
        'alasan': 'Obat anti nyeri sebaiknya diminum malam hari setelah makan'
      };
    } else if (jenisLower.contains('diabetes') || jenisLower.contains('gula')) {
      return {
        'waktu': '07:00',
        'kategori': 'pagi',
        'instruksi': 'Sebelum Makan',
        'alasan': 'Obat diabetes optimal diminum pagi hari sebelum sarapan'
      };
    } else if (jenisLower.contains('antibiotik')) {
      return {
        'waktu': '08:00',
        'kategori': 'pagi',
        'instruksi': 'Sesudah Makan',
        'alasan': 'Antibiotik sebaiknya diminum setelah makan untuk menghindari iritasi lambung'
      };
    } else {
      return {
        'waktu': '12:00',
        'kategori': 'siang',
        'instruksi': 'Sesudah Makan',
        'alasan': 'Rekomendasi umum untuk obat yang tidak terkategori'
      };
    }
  }

  // AI: Analisis interaksi obat (simple)
  static String cekInteraksiObat(List<String> daftarNamaObat) {
    // Simple interaction checker
    final obatLower = daftarNamaObat.map((e) => e.toLowerCase()).toList();

    if (obatLower.any((o) => o.contains('aspirin')) && 
        obatLower.any((o) => o.contains('warfarin'))) {
      return '⚠️ PERINGATAN: Aspirin dan Warfarin dapat meningkatkan risiko pendarahan. Konsultasi dokter!';
    }

    if (obatLower.where((o) => o.contains('antibiotik')).length > 1) {
      return '⚠️ PERINGATAN: Penggunaan beberapa antibiotik bersamaan memerlukan konsultasi dokter!';
    }

    if (daftarNamaObat.length > 5) {
      return 'ℹ️ INFO: Anda mengonsumsi banyak obat. Pertimbangkan untuk berkonsultasi dengan apoteker.';
    }

    return '✅ Tidak ada interaksi obat yang terdeteksi.';
  }

  // Initialize dummy data
  static void initDummyData() {
    if (_daftarObat.isEmpty) {
      _daftarObat = [
        Obat(
          id: '1',
          nama: 'Vitamin D',
          waktu: '08:00',
          instruksi: 'Sebelum Makan',
          kategoriWaktu: 'pagi',
          sudahDiminum: true,
          tanggalMulai: DateTime.now(),
        ),
        Obat(
          id: '2',
          nama: 'Obat Tekanan Darah',
          waktu: '12:00',
          instruksi: 'Sesudah Makan',
          kategoriWaktu: 'siang',
          sudahDiminum: false,
          tanggalMulai: DateTime.now(),
        ),
        Obat(
          id: '3',
          nama: 'Obat Anti Nyeri',
          waktu: '20:00',
          instruksi: 'Sesudah Makan',
          kategoriWaktu: 'malam',
          sudahDiminum: false,
          tanggalMulai: DateTime.now(),
        ),
      ];
    }
  }
}