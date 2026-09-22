import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';
import '../../core/routes.dart';
import '../widgets/header.dart';
import '../widgets/hero_screen.dart';
import '../widgets/system_pipeline_screen.dart';
import '../widgets/hardware_workbench_screen.dart';
import '../widgets/tcc_research_screen.dart';
import '../widgets/benchmark_screen.dart';
import '../widgets/footer.dart';

class LandingPage extends StatefulWidget {
  final String activeSection;

  const LandingPage({
    super.key,
    this.activeSection = 'hero',
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  late String _activeSection;

  @override
  void initState() {
    super.initState();
    _activeSection = widget.activeSection;
  }

  @override
  void didUpdateWidget(covariant LandingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeSection != widget.activeSection) {
      setState(() {
        _activeSection = widget.activeSection;
      });
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

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

  void _navigateToSection(String key) {
    final targetRoute = OryzaRoutes.fromSectionKey(key);
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (targetRoute == OryzaRoutes.home) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      }
    }

    if (currentRoute != targetRoute) {
      Navigator.of(context).pushNamed(targetRoute);
    } else {
      if (_activeSection != key) {
        setState(() {
          _activeSection = key;
        });
      }
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  void _navigateToHome() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      _navigateToSection('hero');
    }
  }

  String _getSectionName(OryzaStrings s, String key) {
    switch (key) {
      case 'system':
        return s.navSystem;
      case 'hardware':
        return s.navHardware;
      case 'tcc':
        return s.navTcc;
      case 'benchmark':
        return s.navBenchmark;
      default:
        return s.navHome;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = OryzaScope.of(context);
    final isDark = controller.isDark;
    final s = OryzaI18n.of(context);

    final solidBgColor = isDark ? OryzaColors.darkCanvas : OryzaColors.lightCanvas;

    return Scaffold(
      backgroundColor: solidBgColor,
      body: Stack(
        children: [
          // Scrollable Screen Content
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 64),
              child: Column(
                children: [
                  if (_activeSection == 'hero') ...[
                    // Tela 1: Hero & Jingle com Topografia de Várzea de Arroz
                    Stack(
                      children: [
                        Positioned.fill(
                          child: OryzaAtmosphericBackground(
                            isDark: isDark,
                            scrollController: _scrollController,
                            fadeBottom: true,
                            child: const SizedBox.expand(),
                          ),
                        ),
                        Center(
                          child: HeroScreen(
                            isDark: isDark,
                            onNavigateToSection: _navigateToSection,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Telas Dedicadas com Barra de Retorno
                    _buildBackBar(s, isDark),

                    if (_activeSection == 'system')
                      Center(child: SystemPipelineScreen(isDark: isDark))
                    else if (_activeSection == 'hardware')
                      Center(child: HardwareWorkbenchScreen(isDark: isDark))
                    else if (_activeSection == 'tcc')
                      Center(child: TccResearchScreen(isDark: isDark))
                    else if (_activeSection == 'benchmark')
                      Center(child: BenchmarkScreen(isDark: isDark)),
                  ],

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
              activeSection: _activeSection,
              onNavigateToSection: _navigateToSection,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackBar(OryzaStrings s, bool isDark) {
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: 0.85),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _navigateToHome,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 16, color: OryzaColors.burntOrange),
                      const SizedBox(width: 8),
                      Text(
                        s.backToHome,
                        style: TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: OryzaColors.burntOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? OryzaColors.darkCanvas : OryzaColors.lightCanvas,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  _getSectionName(s, _activeSection).toUpperCase(),
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
