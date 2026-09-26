import 'package:flutter/foundation.dart';

/// Application settings and runtime environment configuration for Farmer App.
/// Following AI Agent Working Rules and all_structure_project.md.
class AppSettings {
  static const String appName = 'Oryza-Elo Farmer';
  static const String appVersion = '0.1.0';

  // Environment and logging flags
  static const bool isDevelopment = true;

  // Default edge engine endpoint (served locally by default or custom host)
  static const String defaultEngineBaseUrl = 'http://127.0.0.1:8005';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Resolves the active base URL dynamically.
  /// When served from Axum ServeDir on the edge node, uses window origin.
  /// Falls back to defaultEngineBaseUrl in development or headless mode.
  static String get activeBaseUrl {
    if (kIsWeb) {
      final base = Uri.base;
      if (base.host.isNotEmpty && base.port != 0) {
        // If served from port 8005 directly (ServeDir)
        return '${base.scheme}://${base.host}:${base.port}';
      }
    }
    return defaultEngineBaseUrl;
  }
}
