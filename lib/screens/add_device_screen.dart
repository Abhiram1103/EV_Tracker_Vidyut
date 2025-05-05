import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../services/device_storage.dart';
import '../screens/map_screen.dart';
import '../models/device.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController _imeiController = TextEditingController();
  bool _isLoading = false;

  Future<void> _registerDevice() async {
    setState(() => _isLoading = true);

    try {
      // Validate IMEI input
      if (_imeiController.text.trim().isEmpty) {
        throw Exception('Please enter an IMEI number');
      }

      // Call API to add device
      final Device newDevice = await ApiService.addDevice(
        _imeiController.text.trim(),
      );

      // Save the device ID to local storage
      await DeviceStorage.saveDeviceId(newDevice.id);

      // Navigate to tracking screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _imeiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Device')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _imeiController,
              decoration: const InputDecoration(
                labelText: 'IMEI Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sim_card),
              ),
              keyboardType: TextInputType.number,
              maxLength: 15,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isLoading ? null : _registerDevice,
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text(
                          'Register Device',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
