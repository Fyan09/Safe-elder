import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../models/obat_model.dart';
import '../services/obat_service.dart';

class ObatScreen extends StatefulWidget {
  const ObatScreen({super.key});

  @override
  State<ObatScreen> createState() => _ObatScreenState();
}

class _ObatScreenState extends State<ObatScreen> {
  @override
  Widget build(BuildContext context) {
    final obatPagi = ObatService.getObatByKategori('pagi');
    final obatSiang = ObatService.getObatByKategori('siang');
    final obatMalam = ObatService.getObatByKategori('malam');
    final totalObat = ObatService.getAllObat().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Obat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInteraksiObat(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Jadwal Obat Hari Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalObat obat perlu diminum hari ini',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Obat Pagi
              if (obatPagi.isNotEmpty) ...[
                _buildSectionHeader('Pagi (06:00 - 10:00)'),
                ...obatPagi.map((obat) => _buildObatItem(obat)),
                const SizedBox(height: 20),
              ],
              
              // Obat Siang
              if (obatSiang.isNotEmpty) ...[
                _buildSectionHeader('Siang (11:00 - 15:00)'),
                ...obatSiang.map((obat) => _buildObatItem(obat)),
                const SizedBox(height: 20),
              ],
              
              // Obat Malam
              if (obatMalam.isNotEmpty) ...[
                _buildSectionHeader('Malam (18:00 - 22:00)'),
                ...obatMalam.map((obat) => _buildObatItem(obat)),
              ],

              if (totalObat == 0)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.medication_outlined,
                          size: 80,
                          color: AppColors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada jadwal obat',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap tombol + untuk menambah',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTambahObatDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Obat'),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildObatItem(Obat obat) {
    final statusColor = obat.sudahDiminum ? AppColors.success : AppColors.warning;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                obat.sudahDiminum ? Icons.check_circle : Icons.medication_rounded,
                color: statusColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    obat.nama,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${obat.waktu} WIB',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    obat.instruksi,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                if (!obat.sudahDiminum)
                  const PopupMenuItem(
                    value: 'tandai',
                    child: Text('Tandai Sudah Minum'),
                  ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'hapus',
                  child: Text('Hapus'),
                ),
              ],
              onSelected: (value) {
                if (value == 'tandai') {
                  setState(() {
                    ObatService.tandaiSudahDiminum(obat.id);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Obat ditandai sudah diminum')),
                  );
                } else if (value == 'edit') {
                  _showEditObatDialog(context, obat);
                } else if (value == 'hapus') {
                  _showHapusDialog(context, obat.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTambahObatDialog(BuildContext context) {
    final namaController = TextEditingController();
    String? kategoriWaktu = 'pagi';
    String? instruksi = 'Sebelum Makan';
    bool useAI = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tambah Obat Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Obat',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // AI Toggle
                SwitchListTile(
                  title: const Text('Gunakan Rekomendasi AI'),
                  subtitle: const Text('AI akan menyarankan waktu optimal'),
                  value: useAI,
                  onChanged: (value) {
                    setDialogState(() {
                      useAI = value;
                    });
                  },
                ),
                
                if (!useAI) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: kategoriWaktu,
                    decoration: const InputDecoration(
                      labelText: 'Waktu',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'pagi', child: Text('Pagi')),
                      DropdownMenuItem(value: 'siang', child: Text('Siang')),
                      DropdownMenuItem(value: 'malam', child: Text('Malam')),
                    ],
                    onChanged: (value) {
                      kategoriWaktu = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: instruksi,
                    decoration: const InputDecoration(
                      labelText: 'Instruksi',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Sebelum Makan', child: Text('Sebelum Makan')),
                      DropdownMenuItem(value: 'Sesudah Makan', child: Text('Sesudah Makan')),
                      DropdownMenuItem(value: 'Sebelum Tidur', child: Text('Sebelum Tidur')),
                    ],
                    onChanged: (value) {
                      instruksi = value;
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama obat harus diisi')),
                  );
                  return;
                }

                String waktu;
                String finalKategori = kategoriWaktu!;
                String finalInstruksi = instruksi!;

                // Gunakan AI jika diaktifkan
                if (useAI) {
                  final rekomendasi = ObatService.rekomendasiWaktuObat(namaController.text);
                  waktu = rekomendasi['waktu']!;
                  finalKategori = rekomendasi['kategori']!;
                  finalInstruksi = rekomendasi['instruksi']!;
                  
                  // Show AI recommendation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🤖 AI Rekomendasi: ${rekomendasi['alasan']}'),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                } else {
                  waktu = finalKategori == 'pagi' ? '08:00' : 
                          finalKategori == 'siang' ? '12:00' : '20:00';
                }

                final obatBaru = Obat(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  nama: namaController.text,
                  waktu: waktu,
                  instruksi: finalInstruksi,
                  kategoriWaktu: finalKategori,
                  tanggalMulai: DateTime.now(),
                );

                setState(() {
                  ObatService.addObat(obatBaru);
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Obat berhasil ditambahkan')),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditObatDialog(BuildContext context, Obat obat) {
    final namaController = TextEditingController(text: obat.nama);
    String? kategoriWaktu = obat.kategoriWaktu;
    String? instruksi = obat.instruksi;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Obat'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Obat',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: kategoriWaktu,
                decoration: const InputDecoration(
                  labelText: 'Waktu',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'pagi', child: Text('Pagi')),
                  DropdownMenuItem(value: 'siang', child: Text('Siang')),
                  DropdownMenuItem(value: 'malam', child: Text('Malam')),
                ],
                onChanged: (value) {
                  kategoriWaktu = value;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: instruksi,
                decoration: const InputDecoration(
                  labelText: 'Instruksi',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Sebelum Makan', child: Text('Sebelum Makan')),
                  DropdownMenuItem(value: 'Sesudah Makan', child: Text('Sesudah Makan')),
                  DropdownMenuItem(value: 'Sebelum Tidur', child: Text('Sebelum Tidur')),
                ],
                onChanged: (value) {
                  instruksi = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final waktu = kategoriWaktu == 'pagi' ? '08:00' : 
                           kategoriWaktu == 'siang' ? '12:00' : '20:00';

              final obatUpdate = obat.copyWith(
                nama: namaController.text,
                waktu: waktu,
                instruksi: instruksi,
                kategoriWaktu: kategoriWaktu,
              );

              setState(() {
                ObatService.updateObat(obatUpdate);
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Obat berhasil diupdate')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showHapusDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Obat'),
        content: const Text('Apakah Anda yakin ingin menghapus obat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                ObatService.deleteObat(id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Obat berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showInteraksiObat(BuildContext context) {
    final daftarNama = ObatService.getAllObat().map((o) => o.nama).toList();
    final hasil = ObatService.cekInteraksiObat(daftarNama);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cek Interaksi Obat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasil,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Catatan: Ini adalah sistem deteksi dasar. Selalu konsultasi dengan dokter atau apoteker untuk informasi lengkap.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}