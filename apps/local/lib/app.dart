import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:local/core/settings.dart';
import 'package:local/presentation/screens/dashboard_screen.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class OryzaScrollBehavior extends MaterialScrollBehavior {
  const OryzaScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class FarmerApp extends StatefulWidget {
  const FarmerApp({super.key});

  @override
  State<FarmerApp> createState() => _FarmerAppState();
}

class _FarmerAppState extends State<FarmerApp> {
  final OryzaController _controller = OryzaController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OryzaScope(
      controller: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return MaterialApp(
            title: '${AppSettings.appName} • Edge Terminal',
            debugShowCheckedModeBanner: false,
            scrollBehavior: const OryzaScrollBehavior(),
            theme: OryzaTheme.lightTheme,
            darkTheme: OryzaTheme.darkTheme,
            themeMode: _controller.themeMode,
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}
