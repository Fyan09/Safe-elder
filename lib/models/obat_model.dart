class Obat {
  final String id;
  final String nama;
  final String waktu;
  final String instruksi;
  final String kategoriWaktu; // 'pagi', 'siang', 'malam'
  bool sudahDiminum;
  final DateTime tanggalMulai;

  Obat({
    required this.id,
    required this.nama,
    required this.waktu,
    required this.instruksi,
    required this.kategoriWaktu,
    this.sudahDiminum = false,
    required this.tanggalMulai,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'waktu': waktu,
      'instruksi': instruksi,
      'kategoriWaktu': kategoriWaktu,
      'sudahDiminum': sudahDiminum,
      'tanggalMulai': tanggalMulai.toIso8601String(),
    };
  }

  // Create from JSON
  factory Obat.fromJson(Map<String, dynamic> json) {
    return Obat(
      id: json['id'],
      nama: json['nama'],
      waktu: json['waktu'],
      instruksi: json['instruksi'],
      kategoriWaktu: json['kategoriWaktu'],
      sudahDiminum: json['sudahDiminum'] ?? false,
      tanggalMulai: DateTime.parse(json['tanggalMulai']),
    );
  }

  // Copy with
  Obat copyWith({
    String? id,
    String? nama,
    String? waktu,
    String? instruksi,
    String? kategoriWaktu,
    bool? sudahDiminum,
    DateTime? tanggalMulai,
  }) {
    return Obat(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      waktu: waktu ?? this.waktu,
      instruksi: instruksi ?? this.instruksi,
      kategoriWaktu: kategoriWaktu ?? this.kategoriWaktu,
      sudahDiminum: sudahDiminum ?? this.sudahDiminum,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
    );
  }
}