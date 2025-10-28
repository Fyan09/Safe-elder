import '../models/artikel_model.dart';

class ArtikelService {
  static List<Artikel> _daftarArtikel = [];

  static List<Artikel> getAllArtikel() {
    return _daftarArtikel;
  }

  static Artikel? getArtikelById(String id) {
    try {
      return _daftarArtikel.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  static void initDummyData() {
    if (_daftarArtikel.isEmpty) {
      _daftarArtikel = [
        Artikel(
          id: '1',
          judul: 'Tips Menjaga Kesehatan Sendi di Usia Senja',
          deskripsi: 'Ketahui rahasia yang bisa menjaga sendi tetap fleksibel dan bebas nyeri di usia lanjut.',
          konten: '''
# Tips Menjaga Kesehatan Sendi di Usia Senja

Seiring bertambahnya usia, kesehatan sendi menjadi hal yang sangat penting untuk diperhatikan. Berikut adalah tips untuk menjaga kesehatan sendi Anda:

## 1. Olahraga Teratur
- Lakukan peregangan setiap pagi
- Jalan santai 30 menit sehari
- Berenang untuk mengurangi beban sendi

## 2. Nutrisi yang Tepat
- Konsumsi makanan kaya omega-3
- Perbanyak sayuran hijau
- Minum air putih minimal 8 gelas sehari

## 3. Jaga Berat Badan Ideal
Kelebihan berat badan memberikan tekanan ekstra pada sendi, terutama lutut dan pinggul.

## 4. Hindari Aktivitas Berat
- Jangan mengangkat beban terlalu berat
- Hindari gerakan yang terlalu cepat
- Gunakan alat bantu jika diperlukan

## 5. Istirahat Cukup
Tidur 7-8 jam sehari membantu proses regenerasi sendi.

**Kesimpulan:** Dengan perawatan yang tepat, Anda bisa menjaga sendi tetap sehat dan aktif di usia senja.
          ''',
          waktuBaca: '5 min read',
          kategori: 'Kesehatan',
          tanggalPublish: DateTime.now().subtract(const Duration(days: 2)),
          isFeatured: true,
        ),
        Artikel(
          id: '2',
          judul: 'Program Pemeriksaan untuk Lansia 2025',
          deskripsi: 'Informasi lengkap tentang program pemeriksaan kesehatan gratis untuk lansia.',
          konten: '''
# Program Pemeriksaan untuk Lansia 2025

Pemerintah menyediakan berbagai program pemeriksaan kesehatan gratis untuk lansia di tahun 2025.

## Program yang Tersedia:
1. Medical Check-up Lengkap
2. Skrining Diabetes dan Hipertensi
3. Pemeriksaan Mata dan Pendengaran
4. Konsultasi Gizi Gratis

## Cara Mendaftar:
- Datang ke Puskesmas terdekat
- Bawa KTP dan Kartu BPJS
- Daftar online melalui website resmi

**Info lebih lanjut:** Hubungi Puskesmas terdekat.
          ''',
          waktuBaca: '3 min read',
          kategori: 'Program',
          tanggalPublish: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Artikel(
          id: '3',
          judul: 'Aktivitas Sosial di Komunitas Lansia',
          deskripsi: 'Pentingnya menjaga kesehatan mental melalui interaksi sosial.',
          konten: '''
# Aktivitas Sosial di Komunitas Lansia

Kesehatan mental sama pentingnya dengan kesehatan fisik. Berikut manfaat aktivitas sosial:

## Manfaat:
- Mengurangi risiko depresi
- Meningkatkan kualitas hidup
- Menjaga fungsi kognitif
- Membuat hidup lebih bermakna

## Kegiatan yang Bisa Dilakukan:
1. Senam bersama
2. Arisan kelompok
3. Kelas kerajinan tangan
4. Kegiatan keagamaan
5. Volunteer di lingkungan

Mari aktif bersosialisasi untuk hidup yang lebih bahagia!
          ''',
          waktuBaca: '4 min read',
          kategori: 'Sosial',
          tanggalPublish: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Artikel(
          id: '4',
          judul: 'Manfaat Latihan Peregangan Pagi',
          deskripsi: 'Bagaimana latihan sederhana dapat meningkatkan kualitas hidup.',
          konten: '''
# Manfaat Latihan Peregangan Pagi

Mulai hari dengan peregangan memberikan banyak manfaat:

## Manfaat Utama:
- Meningkatkan fleksibilitas
- Mengurangi kekakuan otot
- Meningkatkan sirkulasi darah
- Mencegah cedera
- Meningkatkan mood

## Gerakan Dasar:
1. Peregangan leher
2. Putaran bahu
3. Peregangan lengan
4. Peregangan pinggang
5. Peregangan kaki

Lakukan rutin setiap pagi selama 10-15 menit!
          ''',
          waktuBaca: '6 min read',
          kategori: 'Olahraga',
          tanggalPublish: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Artikel(
          id: '5',
          judul: 'Tips Menghindari Jatuh di Rumah',
          deskripsi: 'Panduan lengkap mencegah kecelakaan jatuh untuk lansia.',
          konten: '''
# Tips Menghindari Jatuh di Rumah

Jatuh adalah salah satu risiko terbesar bagi lansia. Berikut cara mencegahnya:

## Modifikasi Rumah:
- Pasang pegangan di kamar mandi
- Gunakan lampu yang cukup terang
- Hilangkan karpet yang licin
- Pastikan lantai tidak licin

## Peralatan Bantu:
- Tongkat penyangga
- Walker
- Kursi mandi
- Pegangan tangga

## Perilaku Aman:
- Jangan terburu-buru
- Gunakan alas kaki anti-slip
- Hindari naik tangga sendirian

Keselamatan adalah prioritas utama!
          ''',
          waktuBaca: '7 min read',
          kategori: 'Keselamatan',
          tanggalPublish: DateTime.now().subtract(const Duration(days: 12)),
        ),
      ];
    }
  }
}