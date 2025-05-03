
// for onelap API 
// lib/config/env.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A simple wrapper around dotenv so the rest of your app can just
/// say Env.baseUrl, Env.phone, etc.
class Env {
  static String get baseUrl {
    final v = dotenv.env['BASE_URL'];
    if (v == null) throw Exception('BASE_URL not found in .env');
    return v;
  }

  static String get phone {
    final v = dotenv.env['ONELAP_PHONE'];
    if (v == null) throw Exception('ONELAP_PHONE not found in .env');
    return v;
  }

  static String get password {
    final v = dotenv.env['ONELAP_PASSWORD'];
    if (v == null) throw Exception('ONELAP_PASSWORD not found in .env');
    return v;
  }

  static String get deviceId {
    final v = dotenv.env['DEVICE_ID'];
    if (v == null) throw Exception('DEVICE_ID not found in .env');
    return v;
  }
}
