import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';
import '../widgets/header.dart';
import '../widgets/hero_screen.dart';
import '../widgets/system_pipeline_screen.dart';
import '../widgets/hardware_workbench_screen.dart';
import '../widgets/tcc_research_screen.dart';
import '../widgets/footer.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _systemKey = GlobalKey();
  final GlobalKey _hardwareKey = GlobalKey();
  final GlobalKey _tccKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheAssets();
  }

  void _precacheAssets() {
    const assets = [
      // 3D Telemetry Icons
      'assets/icons3d/clock-dynamic-color.png',
      'assets/icons3d/target-dynamic-color.png',
      'assets/icons3d/sun-dynamic-color.png',
      'assets/icons3d/wifi-dynamic-color.png',
      'assets/icons3d/file-text-dynamic-color.png',
      // Student research avatars
      'assets/student/_0028.png',
      'assets/student/_0017.png',
      'assets/student/_0040.png',
      'assets/student/_0005.png',
      // Hardware CAD & Exploded views
      'assets/blueprint/01_rpi5_blueprint.jpg',
      'assets/blueprint/02_rpi5_exploded.jpg',
      'assets/blueprint/03_rpizero2w_blueprint.jpg',
      'assets/blueprint/04_rpizero2w_exploded.jpg',
      'assets/blueprint/05_esp32_lora_blueprint.jpg',
      'assets/blueprint/06_esp32_lora_exploded.jpg',
      'assets/blueprint/07_water_sensor_blueprint.jpg',
      'assets/blueprint/08_water_sensor_exploded.jpg',
      'assets/blueprint/09_soil_probe_blueprint.jpg',
      'assets/blueprint/10_soil_probe_exploded.jpg',
      'assets/blueprint/11_solar_station_blueprint.jpg',
      'assets/blueprint/12_solar_station_exploded.jpg',
      // Botanical plant accents
      'assets/plants/Jungle_Plant_1.png',
      'assets/plants/Jungle_Plant_2.png',
      'assets/plants/Jungle_Plant_3.png',
      'assets/plants/Jungle_Plant_4.png',
      // Asodya Brand Logo
      'assets/img/logo.png',
    ];

    for (final path in assets) {
      precacheImage(AssetImage(path), context).catchError((_) {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String key) {
    GlobalKey? target;
    switch (key) {
      case 'hero':
        target = _heroKey;
        break;
      case 'system':
        target = _systemKey;
        break;
      case 'hardware':
        target = _hardwareKey;
        break;
      case 'tcc':
        target = _tccKey;
        break;
    }

    if (target?.currentContext != null) {
      Scrollable.ensureVisible(
        target!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = OryzaScope.of(context);
    final isDark = controller.isDark;

    return Scaffold(
      body: Stack(
        children: [
          // Atmospheric Spatial Background (Responsive to active style & scroll)
          Positioned.fill(
            child: OryzaAtmosphericBackground(
              isDark: isDark,
              style: controller.backgroundStyle,
              scrollController: _scrollController,
              child: const SizedBox.expand(),
            ),
          ),

          // Scrollable Content (4 Screens + Footer)
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 64),
              child: Column(
                children: [
                  // Tela 1: Hero & Simulação
                  Center(
                    child: HeroScreen(
                      key: _heroKey,
                      isDark: isDark,
                    ),
                  ),
                  _buildSectionDivider(isDark),

                  // Tela 2: Arquitetura do Sistema & Pipeline Biofísico
                  Center(
                    child: SystemPipelineScreen(
                      key: _systemKey,
                      isDark: isDark,
                    ),
                  ),
                  _buildSectionDivider(isDark),

                  // Tela 3: Bancada de Hardware IoT & Blueprints CAD
                  Center(
                    child: HardwareWorkbenchScreen(
                      key: _hardwareKey,
                      isDark: isDark,
                    ),
                  ),
                  _buildSectionDivider(isDark),

                  // Tela 4: Rigor Científico & Pesquisa de TCC (USP / ESALQ)
                  Center(
                    child: TccResearchScreen(
                      key: _tccKey,
                      isDark: isDark,
                    ),
                  ),

                  // Rodapé Asodya
                  OryzaFooter(isDark: isDark),
                ],
              ),
            ),
          ),

          // Sticky Top Header with Blur
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: OryzaHeader(
              onNavigateToSection: _scrollToSection,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(bool isDark) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1600),
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 1,
      color: isDark ? OryzaColors.darkBorder.withValues(alpha: 0.5) : OryzaColors.lightBorder.withValues(alpha: 0.2),
    );
  }
}
