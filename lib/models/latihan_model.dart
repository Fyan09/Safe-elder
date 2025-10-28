import 'package:flutter/material.dart';

class Latihan {
  final String id;
  final String nama;
  final String deskripsi;
  final String durasi;
  final String level; // 'Mudah', 'Sedang', 'Sulit'
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final List<String> manfaat;
  final List<String> langkahLangkah;
  bool selesai;

  Latihan({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.durasi,
    required this.level,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.manfaat,
    required this.langkahLangkah,
    this.selesai = false,
  });

  Latihan copyWith({
    String? id,
    String? nama,
    String? deskripsi,
    String? durasi,
    String? level,
    IconData? icon,
    Color? backgroundColor,
    Color? iconColor,
    List<String>? manfaat,
    List<String>? langkahLangkah,
    bool? selesai,
  }) {
    return Latihan(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      durasi: durasi ?? this.durasi,
      level: level ?? this.level,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      manfaat: manfaat ?? this.manfaat,
      langkahLangkah: langkahLangkah ?? this.langkahLangkah,
      selesai: selesai ?? this.selesai,
    );
  }
}