import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/alert_card.dart';
import '../widgets/obat_card.dart';
import '../widgets/latihan_card.dart';
import '../services/obat_service.dart';
import '../services/latihan_service.dart';
import '../services/artikel_service.dart';
import 'fall_detection_service.dart';
import 'lokasi_screen.dart';
import 'obat_screen.dart';
import 'latihan_screen.dart';
import 'artikel_screen.dart';
import 'package:intl/intl.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _BerandaContent(),
    const LokasiScreen(),
    const ObatScreen(),
    const LatihanScreen(),
    const ArtikelScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _BerandaContent extends StatefulWidget {
  const _BerandaContent();

  @override
  State<_BerandaContent> createState() => _BerandaContentState();
}

class _BerandaContentState extends State<_BerandaContent> {
  @override
  Widget build(BuildContext context) {
    // Get data from services
    final allObat = ObatService.getAllObat();
    final obatHariIni = allObat.isNotEmpty ? allObat.first : null;
    
    final allLatihan = LatihanService.getAllLatihan();
    final latihanHariIni = allLatihan.take(3).toList();
    
    final allArtikel = ArtikelService.getAllArtikel();
    final artikelTerbaru = allArtikel.isNotEmpty ? allArtikel.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeElder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotifications(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showMenu(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Alert Deteksi Jatuh - Realtime dari Firebase
                StreamBuilder<bool>(
                  stream: FallDetectionService.getFallDetectionStream(),
                  builder: (context, snapshot) {
                    // Jika ada data dan terdeteksi jatuh
                    if (snapshot.hasData && snapshot.data == true) {
                      final currentTime = DateFormat('HH:mm').format(DateTime.now());
                      
                      return AlertCard(
                        title: 'Deteksi Jatuh!',
                        subtitle: 'Terdeteksi Jatuh pada $currentTime WIB',
                        buttonText: 'Periksa Lokasi',
                        onPressed: () {
                          // Navigate to Lokasi tab
                          final berandaState = context.findAncestorStateOfType<_BerandaScreenState>();
                          berandaState?.setState(() {
                            berandaState._selectedIndex = 1;
                          });
                        },
                      );
                    }
                    
                    // Jika sedang loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Card(
                        color: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Memuat status deteksi jatuh...',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    // Jika error
                    if (snapshot.hasError) {
                      return Card(
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.orange),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tidak dapat terhubung ke sensor',
                                  style: TextStyle(
                                    color: Colors.orange.shade900,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    // Jika tidak terdeteksi jatuh, tampilkan status aman
                    return Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.success),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Status Aman - Tidak ada deteksi jatuh',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Pengingat Obat Hari Ini
                _buildSectionHeader(
                  context,
                  'Pengingat Obat Hari Ini',
                  allObat.length > 1 ? '${allObat.length - 1} lainnya' : '',
                  () {
                    final berandaState = context.findAncestorStateOfType<_BerandaScreenState>();
                    berandaState?.setState(() {
                      berandaState._selectedIndex = 2;
                    });
                  },
                ),
                
                if (obatHariIni != null)
                  ObatCard(
                    name: obatHariIni.nama,
                    time: '${obatHariIni.waktu} WIB',
                    status: obatHariIni.sudahDiminum ? 'Sudah Diminum' : 'Belum Diminum',
                    statusColor: obatHariIni.sudahDiminum ? AppColors.success : AppColors.warning,
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Belum ada jadwal obat hari ini',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                // Program Latihan Harian
                _buildSectionHeader(
                  context,
                  'Program Latihan Harian',
                  '${latihanHariIni.length} latihan',
                  () {
                    final berandaState = context.findAncestorStateOfType<_BerandaScreenState>();
                    berandaState?.setState(() {
                      berandaState._selectedIndex = 3;
                    });
                  },
                ),
                
                if (latihanHariIni.isNotEmpty)
                  ...latihanHariIni.map((latihan) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LatihanCard(
                      name: latihan.nama,
                      time: latihan.durasi,
                      duration: latihan.level,
                      status: latihan.selesai ? 'Selesai' : 'Belum',
                      statusColor: latihan.selesai ? AppColors.success : AppColors.warning,
                      iconData: latihan.icon,
                      backgroundColor: latihan.backgroundColor,
                    ),
                  ))
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'Belum ada program latihan',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                // Berita & Referensi Lansia
                _buildSectionHeader(
                  context,
                  'Berita & Referensi Lansia',
                  '',
                  () {
                    final berandaState = context.findAncestorStateOfType<_BerandaScreenState>();
                    berandaState?.setState(() {
                      berandaState._selectedIndex = 4;
                    });
                  },
                ),
                
                if (artikelTerbaru != null)
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ArtikelScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artikelTerbaru.judul,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              artikelTerbaru.deskripsi,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  artikelTerbaru.waktuBaca,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Text(
                                      'Baca Selengkapnya',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String actionText,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (actionText.isNotEmpty)
            InkWell(
              onTap: onTap,
              child: Text(
                actionText,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.medication, color: AppColors.primary),
              title: const Text('Waktunya Minum Obat'),
              subtitle: const Text('Vitamin D - 08:00 WIB'),
              trailing: const Text('5 menit lalu'),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: AppColors.success),
              title: const Text('Program Latihan'),
              subtitle: const Text('Jangan lupa latihan pagi'),
              trailing: const Text('1 jam lalu'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur profil akan datang')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur pengaturan akan datang')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Bantuan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur bantuan akan datang')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang SafeElder'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SafeElder v1.0.0'),
            SizedBox(height: 8),
            Text(
              'Aplikasi monitoring kesehatan dan keamanan lansia',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '© 2025 SafeElder Team',
              style: TextStyle(fontSize: 12),
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