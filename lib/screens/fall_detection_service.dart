import 'package:firebase_database/firebase_database.dart';

class FallDetectionService {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  // Stream untuk mendengarkan perubahan status jatuh
  static Stream<bool> getFallDetectionStream() {
    return _database
        .child('esp32/status/fallDetected')
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        return event.snapshot.value as bool;
      }
      return false;
    });
  }
  
  // Get data sekali saja (tidak realtime)
  static Future<bool> getFallDetectionStatus() async {
    try {
      final snapshot = await _database
          .child('esp32/status/fallDetected')
          .get();
      
      if (snapshot.exists) {
        return snapshot.value as bool;
      }
      return false;
    } catch (e) {
      print('Error getting fall detection status: $e');
      return false;
    }
  }
  
  // Get data sensor accelerometer (opsional, untuk info tambahan)
  static Future<Map<String, dynamic>> getSensorData() async {
    try {
      final snapshot = await _database
          .child('esp32/sensor/accel')
          .get();
      
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data;
      }
      return {};
    } catch (e) {
      print('Error getting sensor data: $e');
      return {};
    }
  }
  
  // Reset status jatuh (jika diperlukan)
  static Future<void> resetFallDetection() async {
    try {
      await _database
          .child('esp32/status/fallDetected')
          .set(false);
    } catch (e) {
      print('Error resetting fall detection: $e');
    }
  }
  
  // Get semua data ESP32 (untuk debugging)
  static Stream<Map<String, dynamic>> getEsp32DataStream() {
    return _database
        .child('esp32')
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return {};
    });
  }
}