import 'package:flutter/material.dart';

class OryzaController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('pt', 'BR');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

}

class OryzaScope extends InheritedNotifier<OryzaController> {
  const OryzaScope({
    super.key,
    required OryzaController controller,
    required super.child,
  }) : super(notifier: controller);

  static OryzaController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<OryzaScope>();
    assert(scope != null, 'No OryzaScope found in context');
    return scope!.notifier!;
  }
}
