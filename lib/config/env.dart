class Env {
  // Base URL for the API
  static const String baseUrl = 'https://api.evtracker.example.com';
  
  // Credentials for Basic Auth
  static const String phone = ''; // Set in your local development environment
  static const String password = ''; // Set in your local development environment
  
  // Google Maps API Key
  static const String mapsApiKey = ''; // Set in your local development environment
  
  // WebSocket configuration
  static const String wsUrl = 'wss://ws.evtracker.example.com';
  
  // Other configuration
  static const int connectionTimeout = 10; // Seconds
  static const bool enableDebugLogs = true;
  
  // Feature flags
  static const bool enableBackgroundTracking = true;
  static const bool enableNotifications = true;
}

// Instructions:
// 1. Create a copy of this file and name it 'env_local.dart'
// 2. Fill in your values in 'env_local.dart'
// 3. Make sure 'env_local.dart' is in your .gitignore file
// 4. Import 'env_local.dart' instead of this file in your code