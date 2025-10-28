class Artikel {
  final String id;
  final String judul;
  final String deskripsi;
  final String konten;
  final String waktuBaca;
  final String kategori;
  final DateTime tanggalPublish;
  final bool isFeatured;
  final String? imageUrl;

  Artikel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.konten,
    required this.waktuBaca,
    required this.kategori,
    required this.tanggalPublish,
    this.isFeatured = false,
    this.imageUrl,
  });
}