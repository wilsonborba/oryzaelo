import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';
import 'core/routes.dart';
import 'presentation/pages/landing_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OryzaCloudApp());
}

class OryzaCloudApp extends StatefulWidget {
  const OryzaCloudApp({super.key});

  @override
  State<OryzaCloudApp> createState() => _OryzaCloudAppState();
}

class _OryzaCloudAppState extends State<OryzaCloudApp> {
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
            title: 'Oryza-Elo • Precision Phenology & Edge Intelligence',
            debugShowCheckedModeBanner: false,
            theme: OryzaTheme.lightTheme,
            darkTheme: OryzaTheme.darkTheme,
            themeMode: _controller.themeMode,
            initialRoute: OryzaRoutes.home,
            onGenerateRoute: (settings) {
              final section = OryzaRoutes.toSectionKey(settings.name);
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => LandingPage(activeSection: section),
              );
            },
          );
        },
      ),
    );
  }
}
