import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../utils/colors.dart';
import 'fall_detection_service.dart';

class LokasiScreen extends StatefulWidget {
  const LokasiScreen({super.key});

  @override
  State<LokasiScreen> createState() => _LokasiScreenState();
}

class _LokasiScreenState extends State<LokasiScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoading = true;
  String? _alamat;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ================== AMBIL LOKASI SAAT INI ==================
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Layanan lokasi belum aktif')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final lokasi = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = lokasi;
      _isLoading = false;
    });

    _mapController.move(lokasi, 17);
    _getAddressFromLatLng(lokasi);
  }

  // ================== AMBIL ALAMAT DARI KOORDINAT ==================
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _alamat =
              "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}";
        });
      } else {
        setState(() {
          _alamat = "Alamat tidak ditemukan";
        });
      }
    } catch (e) {
      setState(() {
        _alamat = "Gagal memuat alamat";
      });
    }
  }

  // ================== HELPER: GET COLOR BY STATUS ==================
  Color _getColorByStatus(String status) {
    switch (status.toLowerCase()) {
      case "berjalan":
        return Colors.green;
      case "berdiri":
        return AppColors.success;
      case "duduk":
        return Colors.orange;
      case "diam":
        return Colors.grey;
      case "jatuh":
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  // ================== UI / TAMPILAN ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Lansia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Fokus ke Lokasi Saya',
            onPressed: () {
              if (_currentLocation != null) {
                _mapController.move(_currentLocation!, 17);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation ?? LatLng(0, 0),
                    initialZoom: 17,
                    maxZoom: 19,
                    minZoom: 3,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                      pinchZoomThreshold: 0.5,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.safe_elder',
                    ),
                    if (_currentLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocation!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.person_pin_circle,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

          // 🧭 KARTU INFORMASI DI BAWAH - DENGAN STREAM DARI FIREBASE
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lokasi Lansia',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 🏠 Alamat lokasi
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _alamat ?? "Memuat alamat...",
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    
                    // 🟢 Status Gerakan - REALTIME SINKRON DENGAN BERANDA
                    StreamBuilder<bool>(
                      stream: FallDetectionService.getFallDetectionStream(),
                      builder: (context, fallSnapshot) {
                        return StreamBuilder<Map<String, dynamic>>(
                          stream: FallDetectionService.getElderlyStatusStream(),
                          builder: (context, statusSnapshot) {
                            final isFalling = fallSnapshot.data ?? false;
                            String status = "Berdiri";
                            String durasi = "0 Menit";
                            String lastUpdate = "Belum ada data";
                            
                            if (statusSnapshot.hasData && statusSnapshot.data != null) {
                              final data = statusSnapshot.data!;
                              status = data['status'] ?? "Berdiri";
                              durasi = data['duration'] ?? "0 Menit";
                              
                              if (data['lastUpdate'] != null) {
                                try {
                                  final dateTime = DateTime.parse(data['lastUpdate']);
                                  final difference = DateTime.now().difference(dateTime);
                                  
                                  if (difference.inMinutes < 1) {
                                    lastUpdate = "Baru saja";
                                  } else if (difference.inHours < 1) {
                                    lastUpdate = "${difference.inMinutes} menit lalu";
                                  } else if (difference.inDays < 1) {
                                    lastUpdate = "${difference.inHours} jam lalu";
                                  } else {
                                    lastUpdate = "${difference.inDays} hari lalu";
                                  }
                                } catch (e) {
                                  lastUpdate = "Baru saja";
                                }
                              }
                            }
                            
                            // 🔴 PRIORITAS: Jika fallDetected = true, override status jadi "Jatuh"
                            if (isFalling || status.toLowerCase() == "jatuh") {
                              status = "Jatuh";
                            }
                            
                            final color = _getColorByStatus(status);
                            
                            return Column(
                              children: [
                                _buildInfoRow(
                                  Icons.accessibility_new,
                                  'Status Gerakan',
                                  status,
                                  color,
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.timer,
                                  'Durasi di Lokasi',
                                  durasi,
                                  AppColors.textSecondary,
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.update,
                                  'Terakhir Update',
                                  lastUpdate,
                                  AppColors.textSecondary,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    
                    // Tombol Hubungi Sekarang
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showContactDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Hubungi Sekarang',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color valueColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.grey),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hubungi Lansia'),
        content: const Text('Apakah Anda ingin menghubungi lansia sekarang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Hubungi'),
          ),
        ],
      ),
    );
  }
}