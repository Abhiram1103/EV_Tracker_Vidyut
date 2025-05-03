
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/api_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  static const _initial = LatLng(28.8161453, 77.1335627);
  Marker? _marker;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchAndMark();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchAndMark());
  }

  Future<void> _fetchAndMark() async {
    final pos = await ApiService.fetchLatestPosition();
    if (pos != null) {
      final point = LatLng(pos.latitude, pos.longitude);
      setState(() => _marker = Marker(markerId: const MarkerId('veh'), position: point));
      _mapController.animateCamera(CameraUpdate.newLatLng(point));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live EV Tracker')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: _initial, zoom: 16),
        markers: _marker != null ? {_marker!} : {},
        onMapCreated: (c) => _mapController = c,
      ),
    );
  }
}
