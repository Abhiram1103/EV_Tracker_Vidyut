import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Added for DateFormat
import '../services/device_storage.dart';
import '../services/api_services.dart';
import '../models/device_position.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Position History'),
        elevation: 2,
      ),
      body: FutureBuilder<List<DevicePosition>>(
        future: _loadHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load history: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final positions = snapshot.data!;
          if (positions.isEmpty) {
            return const Center(
              child: Text('No position history available'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: positions.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final position = positions[index];
              return _buildHistoryItem(position);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(DevicePosition position) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: const Icon(Icons.location_pin),
      title: Text(
        '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
        style: const TextStyle(fontFamily: 'Monospace'),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Speed: ${position.speed.toStringAsFixed(1)} km/h',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            DateFormat('MMM dd, yyyy - HH:mm').format(position.timestamp),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<List<DevicePosition>> _loadHistory() async {
    try {
      final deviceId = await DeviceStorage.getDeviceId();
      if (deviceId == 0) throw Exception('No registered device');
      
      return await ApiService.getPositionHistory(
        deviceId,
        from: DateTime.now().subtract(const Duration(days: 7)),
        to: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to load history: ${e.toString()}');
    }
  }
}