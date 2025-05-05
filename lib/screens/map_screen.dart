import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'dart:async';
import '../services/websocket_service.dart';
import '../services/api_services.dart';
import '../config/constants.dart';
import '../models/device_position.dart';
import '../services/device_storage.dart';
import '../screens/add_device_screen.dart'; // Added missing import

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  maps.GoogleMapController? _mapController;
  final Set<maps.Marker> _markers = {};
  StreamSubscription? _positionSubscription;
  bool _isLoading = true;
  String _errorMessage = '';
  Timer? _reconnectTimer;
  late int _deviceId;
  DevicePosition? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  Future<void> _initializeTracking() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // 1. Get stored device ID
      _deviceId = await DeviceStorage.getDeviceId();
      if (_deviceId == 0) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AddDeviceScreen()),
          );
        }
        return;
      }

      // 2. Get initial position
      await _fetchLatestPosition();

      // 3. Connect to WebSocket
      await WebSocketService.connect();
      _positionSubscription = WebSocketService.realTimePositions.listen(
        (data) => _handleWebSocketData(data),
        onError: (e) => _handleError('WebSocket error: ${e.toString()}'),
      );

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<void> _fetchLatestPosition() async {
    try {
      final position = await ApiService.getLatestPosition(_deviceId);
      _updateMap(position);
    } catch (e) {
      _handleError('Position fetch failed: ${e.toString()}');
    }
  }

  void _handleWebSocketData(Map<String, dynamic> data) {
    if (data['deviceId'] == _deviceId) {
      final position = DevicePosition.fromJson(data);
      _updateMap(position);
    }
  }

  void _updateMap(DevicePosition position) {
    if (!mounted) return;

    setState(() {
      _currentPosition = position;
      _markers.clear();
      _markers.add(
        maps.Marker(
          markerId: const maps.MarkerId('ev-live-position'),
          position: maps.LatLng(position.latitude, position.longitude),
          icon: maps.BitmapDescriptor.defaultMarkerWithHue(
            maps.BitmapDescriptor.hueAzure,
          ),
          infoWindow: maps.InfoWindow(
            title: 'Live Position',
            snippet: 'Speed: ${position.speed} km/h\n${position.timestamp.toLocal()}',
          ),
        ),
      );
    });

    _mapController?.animateCamera(
      maps.CameraUpdate.newLatLngZoom(
        maps.LatLng(position.latitude, position.longitude),
        16,
      ),
    );
  }

  void _handleError(String error) {
    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });
    
    _reconnectTimer = Timer(const Duration(seconds: 5), _initializeTracking);
  }

  Future<void> _manualRefresh() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _fetchLatestPosition();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _reconnectTimer?.cancel();
    WebSocketService.disposeResources();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live EV Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _manualRefresh,
            tooltip: 'Refresh position',
          ),
        ],
      ),
      body: Stack(
        children: [
          maps.GoogleMap(
            initialCameraPosition: const maps.CameraPosition(
              target: maps.LatLng(Constants.initialLat, Constants.initialLng),
              zoom: Constants.initialZoom,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
          ),
          if (_isLoading) _buildLoadingIndicator(),
          if (_errorMessage.isNotEmpty) _buildErrorCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mapController?.animateCamera(
          maps.CameraUpdate.newLatLngZoom(
            maps.LatLng(
              _currentPosition?.latitude ?? Constants.initialLat,
              _currentPosition?.longitude ?? Constants.initialLng,
            ),
            16,
          ),
        ),
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorCard() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        color: Colors.red[100],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _initializeTracking,
                child: const Text('Retry Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}