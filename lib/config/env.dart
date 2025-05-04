class Env {
  // Base URL for the API
  static const String baseUrl = 'https://web.onelap.in';
  
  // Credentials for Basic Auth
   // Set in your local development environment
  static const String username = String.fromEnvironment('ONELAP_USERNAME'); // Set in your local development environment
  static const String phone = String.fromEnvironment('ONELAP_PHONE');
  static const String password = String.fromEnvironment('ONELAP_PASSWORD');
  
  // Google Maps API Key
  static const String mapsApiKey = 'AIzaSyAxdfHJHJEGrh5GkcyfJLTeuaIZyJxCjPI'; // Set in your local development environment
  
  // WebSocket configuration
  static const String wsUrl = 'wss://socket.onelapmobile.com:3000';
  
  // Other configuration
  static const int connectionTimeout = 5; // Seconds
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