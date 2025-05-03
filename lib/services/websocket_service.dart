import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
// Removed unused import for status codes
import '../config/env.dart';
import '../models/device.dart';

class WebSocketService {
  static WebSocketChannel? _channel;
  static final _positionsStreamController = StreamController<Map<String, dynamic>>.broadcast();
  static final _notificationsStreamController = StreamController<Map<String, dynamic>>.broadcast();
  static bool _isConnected = false;
  
  static Timer? _heartbeatTimer;
  static Timer? _reconnectTimer;
  
  // Initialize WebSocket connection
  static Future<void> initialize() async {
    if (_isConnected) {
      return;
    }
    
    try {
      final token = await _getAuthToken();
      final wsUri = Uri.parse('${Env.wsUrl}/connect?token=$token');
      
      _channel = WebSocketChannel.connect(wsUri);
      
      _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
      
      _startHeartbeat();
      _isConnected = true;
    } catch (e) {
      _isConnected = false;
      _scheduleReconnect();
      rethrow;
    }
  }
  
  // Process incoming WebSocket data
  static void _onData(dynamic data) {
    try {
      final jsonData = jsonDecode(data as String) as Map<String, dynamic>;
      final type = jsonData['type'] as String?;
      
      switch (type) {
        case 'positions':
          _positionsStreamController.add(jsonData);
          break;
        case 'notification':
          _notificationsStreamController.add(jsonData);
          break;
        case 'pong':
          // Heartbeat response, do nothing
          break;
        default:
          // Unknown message type
          break;
      }
    } catch (e) {
      // Handle parsing error
      if (Env.enableDebugLogs) {
        print('WebSocket parsing error: $e');
      }
    }
  }
  
  // Handle WebSocket errors
  static void _onError(dynamic error) {
    _isConnected = false;
    if (Env.enableDebugLogs) {
      print('WebSocket error: $error');
    }
    _scheduleReconnect();
  }
  
  // Handle WebSocket connection close
  static void _onDone() {
    _isConnected = false;
    if (Env.enableDebugLogs) {
      print('WebSocket connection closed');
    }
    _scheduleReconnect();
  }
  
  // Access to real-time position data stream
  static Stream<Map<String, dynamic>> get realTimePositions {
    return _positionsStreamController.stream;
  }
  
  // Access to notifications stream
  static Stream<Map<String, dynamic>> get notifications {
    return _notificationsStreamController.stream;
  }
  
  // Send a command through the WebSocket
  static Future<void> sendCommand(String deviceId, String command, Map<String, dynamic> parameters) async {
    if (!_isConnected || _channel == null) {
      await initialize();
    }
    
    final message = jsonEncode({
      'type': 'command',
      'deviceId': deviceId,
      'command': command,
      'parameters': parameters,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    _channel!.sink.add(message);
  }
  
  // Start heartbeat to keep connection alive
  static void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected && _channel != null) {
        _channel!.sink.add(jsonEncode({'type': 'ping'}));
      }
    });
  }
  
  // Schedule reconnection after failure
  static void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      initialize();
    });
  }
  
  // Get authentication token for WebSocket
  static Future<String> _getAuthToken() async {
    // Implementation depends on your authentication mechanism
    // Here's a placeholder implementation
    return 'temp_auth_token';
  }
  
  // Clean up resources
  static void dispose() {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    
    _channel?.sink.close(1001); // 1001 is the WebSocket close code for 'going away'
    _channel = null;
    
    _isConnected = false;
  }
  
  // Check connection status
  static bool get isConnected => _isConnected;
  
  // For testing and demo purposes
  static Stream<Map<String, dynamic>> get mockRealTimePositions async* {
    // Starting position (San Francisco area)
    double lat = 37.7749;
    double lng = -122.4194;
    
    // Continuously emit positions with slight movement
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate small movement
      lat += (0.0001 * (Random().nextDouble() * 2 - 1));
      lng += (0.0001 * (Random().nextDouble() * 2 - 1));
      
      yield {
        'type': 'positions',
        'positions': [
          {
            'deviceId': 'demo-device-1',
            'latitude': lat,
            'longitude': lng,
            'speed': 15 + (Random().nextInt(15)),
            'heading': Random().nextInt(360),
            'timestamp': DateTime.now().toIso8601String(),
          }
        ]
      };
    }
  }
}