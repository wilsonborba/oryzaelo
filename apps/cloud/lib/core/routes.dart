/// Named routes for deep linking and web URL navigation across the Oryza-Elo ecosystem.
class OryzaRoutes {
  static const String home = '/';
  static const String system = '/system';
  static const String hardware = '/hardware';
  static const String tcc = '/tcc';
  static const String benchmark = '/benchmark';

  // Deep-linking aliases
  static const String pipeline = '/pipeline';
  static const String iot = '/iot';
  static const String research = '/research';

  /// Maps an internal section key to its canonical route URL path.
  static String fromSectionKey(String key) {
    switch (key) {
      case 'system':
        return system;
      case 'hardware':
        return hardware;
      case 'tcc':
        return tcc;
      case 'benchmark':
        return benchmark;
      case 'hero':
      default:
        return home;
    }
  }

  /// Maps a URL route path or alias to its corresponding section key.
  static String toSectionKey(String? routeName) {
    final clean = (routeName ?? '/').split('?').first;
    switch (clean) {
      case system:
      case pipeline:
        return 'system';
      case hardware:
      case iot:
        return 'hardware';
      case tcc:
      case research:
        return 'tcc';
      case benchmark:
        return 'benchmark';
      case home:
      case '/home':
      default:
        return 'hero';
    }
  }
}
