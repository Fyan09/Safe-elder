import 'package:flutter/material.dart';
import '../models/latihan_model.dart';
import '../utils/colors.dart';

class LatihanService {
  static List<Latihan> _daftarLatihan = [];

  static List<Latihan> getAllLatihan() {
    return _daftarLatihan;
  }

  static void tandaiSelesai(String id) {
    final index = _daftarLatihan.indexWhere((l) => l.id == id);
    if (index != -1) {
      _daftarLatihan[index] = _daftarLatihan[index].copyWith(selesai: true);
    }
  }

  static void initDummyData() {
    if (_daftarLatihan.isEmpty) {
      _daftarLatihan = [
        Latihan(
          id: '1',
          nama: 'Latihan Peregangan Pagi',
          deskripsi: 'Meningkatkan fleksibilitas tubuh dan mengurangi kekakuan otot',
          durasi: '15 menit',
          level: 'Mudah',
          icon: Icons.accessibility_new,
          backgroundColor: AppColors.activityMorning,
          iconColor: AppColors.success,
          manfaat: [
            'Meningkatkan fleksibilitas',
            'Mengurangi kekakuan otot',
            'Meningkatkan sirkulasi darah',
            'Mengurangi risiko cedera',
          ],
          langkahLangkah: [
            'Pemanasan: Berdiri tegak, tarik nafas dalam 5x',
            'Peregangan Leher: Putar kepala perlahan ke kanan-kiri (10x)',
            'Peregangan Bahu: Angkat bahu ke atas, tahan 5 detik (5x)',
            'Peregangan Lengan: Rentangkan tangan ke samping (10x)',
            'Peregangan Pinggang: Tekuk badan ke samping (10x setiap sisi)',
            'Pendinginan: Tarik nafas dalam dan relaksasi',
          ],
          selesai: true,
        ),
        Latihan(
          id: '2',
          nama: 'Jalan Santai',
          deskripsi: 'Meningkatkan kesehatan jantung dan stamina',
          durasi: '30 menit',
          level: 'Sedang',
          icon: Icons.directions_walk,
          backgroundColor: AppColors.activityAfternoon,
          iconColor: AppColors.warning,
          manfaat: [
            'Memperkuat jantung',
            'Meningkatkan stamina',
            'Membakar kalori',
            'Mengurangi stress',
          ],
          langkahLangkah: [
            'Gunakan sepatu yang nyaman',
            'Mulai dengan kecepatan lambat 5 menit',
            'Tingkatkan kecepatan secara bertahap',
            'Jaga postur tubuh tegak',
            'Ayunkan lengan secara alami',
            'Akhiri dengan pendinginan 5 menit',
          ],
          selesai: false,
        ),
        Latihan(
          id: '3',
          nama: 'Latihan Keseimbangan',
          deskripsi: 'Mencegah jatuh dan meningkatkan stabilitas tubuh',
          durasi: '20 menit',
          level: 'Mudah',
          icon: Icons.self_improvement,
          backgroundColor: AppColors.activityEvening,
          iconColor: AppColors.primary,
          manfaat: [
            'Mencegah jatuh',
            'Meningkatkan stabilitas',
            'Memperkuat otot kaki',
            'Meningkatkan koordinasi',
          ],
          langkahLangkah: [
            'Berdiri dengan satu kaki (tahan 10 detik)',
            'Jalan dengan tumit ke ujung kaki',
            'Berdiri dari posisi duduk (10x)',
            'Berdiri dengan mata tertutup (10 detik)',
            'Jalan mundur perlahan (10 langkah)',
          ],
          selesai: true,
        ),
        Latihan(
          id: '4',
          nama: 'Senam Pernapasan',
          deskripsi: 'Meningkatkan kapasitas paru-paru dan relaksasi',
          durasi: '10 menit',
          level: 'Mudah',
          icon: Icons.air,
          backgroundColor: AppColors.greyLight,
          iconColor: AppColors.info,
          manfaat: [
            'Meningkatkan kapasitas paru',
            'Mengurangi stress',
            'Meningkatkan fokus',
            'Menurunkan tekanan darah',
          ],
          langkahLangkah: [
            'Duduk dalam posisi nyaman',
            'Tarik nafas melalui hidung (4 hitungan)',
            'Tahan nafas (4 hitungan)',
            'Buang nafas melalui mulut (6 hitungan)',
            'Ulangi 10 kali',
            'Istirahat dan rasakan efek relaksasi',
          ],
          selesai: false,
        ),
      ];
    }
  }
}