import 'package:flutter/material.dart';

enum OryzaBackgroundStyle {
  atmospheric, // Iluminação espacial difusa + névoa biofísica suave (Padrão: sem quadriculado)
  cleanStudio,  // Estúdio Minimalista 100% limpo com vinheta suave
  swissDots,    // Matriz Suíça de Micro-Pontos (48px de distância, ultra-sutil)
  topographic,  // Curvas de nível agronômicas orgânicas
}

class OryzaController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('pt', 'BR');
  OryzaBackgroundStyle _backgroundStyle = OryzaBackgroundStyle.atmospheric;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isDark => _themeMode == ThemeMode.dark;
  OryzaBackgroundStyle get backgroundStyle => _backgroundStyle;

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

  void setBackgroundStyle(OryzaBackgroundStyle style) {
    if (_backgroundStyle != style) {
      _backgroundStyle = style;
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
