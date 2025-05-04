import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'dart:async';
import '../models/user.dart';
import '../config/constants.dart';

// Simulated WebSocket service
class WebSocketService {
  static final StreamController<Map<String, dynamic>> _controller =
  StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get realTimePositions =>
      _controller.stream;

  static Future<void> initialize() async {
    // Simulate WebSocket initialization
    await Future.delayed(Duration(seconds: 1));

    // Simulate receiving real-time data
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _controller.add({
        'positions': [
          {'latitude': 28.8161453, 'longitude': 77.1335627},
        ],
      });
    });
  }

  static void dispose() {
    _controller.close();
  }
}

class MapScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  maps.GoogleMapController? _mapController;
  final Set<maps.Marker> _markers = {};
  StreamSubscription? _wsSubscription;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  Future<void> _initWebSocket() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      await WebSocketService.initialize();

      _wsSubscription = WebSocketService.realTimePositions.listen(
            (data) {
          final positions = data['positions'];
          if (positions != null && positions.isNotEmpty) {
            final position = positions.first;
            if (position != null) {
              _updateMarker(
                maps.LatLng(
                  position['latitude'] as double,
                  position['longitude'] as double,
                ),
              );
            }
          }
        },
        onError: (error) {
          setState(() {
            _errorMessage = 'Connection error: $error';
            _isLoading = false;
          });
        },
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize connection: $e';
        _isLoading = false;
      });
    }
  }

  void _updateMarker(maps.LatLng position) {
    if (!mounted) return;

    setState(() {
      _markers.clear();
      _markers.add(
        maps.Marker(
          markerId: const maps.MarkerId('ev'),
          position: position,
          icon: maps.BitmapDescriptor.defaultMarkerWithHue(
            maps.BitmapDescriptor.hueAzure,
          ),
          infoWindow: const maps.InfoWindow(
            title: 'EV Location',
            snippet: 'Current position of your vehicle',
          ),
        ),
      );
    });

    _mapController?.animateCamera(
      maps.CameraUpdate.newLatLng(position),
    );
  }

  void _refreshConnection() async {
    _wsSubscription?.cancel();
    await _initWebSocket();
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _mapController?.dispose();
    WebSocketService.dispose();
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
            onPressed: _refreshConnection,
            tooltip: 'Refresh connection',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.of(context).pushReplacementNamed('/login');
              } else if (value == 'profile') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile option tapped')),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
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
            mapToolbarEnabled: true,
            compassEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          if (_isLoading)
            const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Connecting to vehicle...'),
                    ],
                  ),
                ),
              ),
            ),
          if (_errorMessage.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                      TextButton(
                        onPressed: _refreshConnection,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController?.animateCamera(
            maps.CameraUpdate.newLatLngZoom(
              maps.LatLng(Constants.initialLat, Constants.initialLng),
              Constants.initialZoom,
            ),
          );
        },
        tooltip: 'Return to initial position',
        child: const Icon(Icons.home),
      ),
    );
  }
}