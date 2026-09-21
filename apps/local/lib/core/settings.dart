/// Application settings and runtime environment configuration for Farmer App.
/// Following AI Agent Working Rules and all_structure_project.md.
class AppSettings {
  static const String appName = 'Oryza-Elo Farmer';
  static const String appVersion = '0.1.0';

  // Environment and logging flags
  static const bool isDevelopment = true;

  // Default edge engine endpoint (served locally by default or custom host)
  static const String defaultEngineBaseUrl = 'http://127.0.0.1:8005';
  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
