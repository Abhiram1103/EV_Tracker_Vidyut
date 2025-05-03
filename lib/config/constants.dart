import 'package:flutter/material.dart';

class Constants {
  // App title
  static const String appName = 'EV Tracker MVP';

  // Default Google Maps camera position (NIT Delhi)
  static const double initialLat = 28.8161453;
  static const double initialLng = 77.1335627;
  static const double initialZoom = 16.0;

  // API timeouts
  static const Duration apiTimeout = Duration(seconds: 10);

  // Common paddings
  static const double pagePadding = 16.0;
  static const EdgeInsets screenPadding = EdgeInsets.all(pagePadding);

  // Standard colors
  static const Color primaryColor = Colors.blue;
  static const Color accentColor  = Colors.orange;

  // Route names
  static const String loginRoute = '/login';
  static const String mapRoute   = '/map';
}
