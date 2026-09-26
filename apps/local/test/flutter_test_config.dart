import 'dart:async';

import 'package:flutter/services.dart' show FontLoader, rootBundle;
import 'package:flutter_test/flutter_test.dart';

/// By default `flutter test` never loads real custom fonts — every widget
/// test measures text with a substituted test font instead of the app's
/// actual "Ubuntu Sans"/"Ubuntu Sans Mono". That makes any RenderFlex
/// overflow assertion in a widget test unreliable: it can flag layouts that
/// are actually fine in production, or (just as easily) miss ones that
/// genuinely overflow with the real, differently-metriced font. Loading the
/// real fonts here makes every test in this suite measure real pixels.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFont('Ubuntu Sans', 'packages/oryzaelo_ui/assets/fonts/UbuntuSans-Variable.ttf');
  await _loadFont('Ubuntu Sans Mono', 'packages/oryzaelo_ui/assets/fonts/UbuntuSansMono-Variable.ttf');
  await testMain();
}

Future<void> _loadFont(String family, String assetPath) async {
  final bytes = await rootBundle.load(assetPath);
  final loader = FontLoader(family)..addFont(Future.value(bytes));
  await loader.load();
}
