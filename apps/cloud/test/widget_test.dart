import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';
import 'package:cloud/main.dart';
import 'package:cloud/core/routes.dart';
import 'package:cloud/presentation/pages/landing_page.dart';
import 'package:cloud/presentation/widgets/benchmark_screen.dart';
import 'package:cloud/presentation/widgets/hardware_workbench_screen.dart';
import 'package:cloud/presentation/widgets/header.dart';
import 'package:cloud/presentation/widgets/system_pipeline_screen.dart';
import 'package:cloud/presentation/widgets/how_to_use_screen.dart';
import 'package:cloud/presentation/widgets/simulation_dialog.dart';

void main() {

  testWidgets('OryzaHeader renders navigation links and brand title without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: OryzaHeader(),
          ),
        ),
      ),
    );

    expect(find.byType(OryzaHeader), findsOneWidget);
    expect(find.text('ORYZA-ELO'), findsOneWidget);
    expect(find.text('Benchmark & Comparativos'), findsOneWidget);
  });

  testWidgets('OryzaCloudApp builds and renders LandingPage', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const OryzaCloudApp());
    expect(find.byType(OryzaCloudApp), findsOneWidget);

    // Verify 🇧🇷 and 🇹🇭 flags are present in cultural card titles
    expect(find.textContaining('Brasil 🇧🇷'), findsOneWidget);
    expect(find.textContaining('Tailândia 🇹🇭'), findsOneWidget);
  });

  testWidgets('flutter_math_fork renders LaTeX formulas correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Math.tex(
            r'\text{GDD} = \sum_{t=1}^{N} \max\left(0, \frac{T_{\max, t} + T_{\min, t}}{2} - T_{\text{base}}\right)',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Math), findsOneWidget);
  });

  testWidgets('BenchmarkScreen builds and renders comparison table, charts, map, and quotes', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BenchmarkScreen(isDark: false),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BenchmarkScreen), findsOneWidget);
    expect(find.text('BENCHMARKING & COMPARAÇÃO TÉCNICA'), findsOneWidget);
    expect(find.text('MATRIZ COMPARATIVA DE TECNOLOGIAS AGRONÔMICAS'), findsOneWidget);
    expect(find.text(OryzaI18n.pt.benchmarkMapHeading), findsOneWidget);
    expect(find.text(OryzaI18n.pt.benchmarkQuotesHeading), findsOneWidget);
    expect(find.text('22.4 µs'), findsWidgets);
  });

  testWidgets('OryzaCloudApp deep links to /tcc with USP MBA affiliation and no UFMS', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return MaterialApp(
              initialRoute: '/tcc',
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
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Universidade de São Paulo (USP)'), findsWidgets);
    expect(find.textContaining('MBA em Engenharia de Software'), findsWidgets);
    expect(find.textContaining('UFMS'), findsNothing);
    expect(find.textContaining('RiceGuard'), findsNothing);
  });

  testWidgets('OryzaCloudApp deep links to /benchmark with Government of Thailand source and no RiceGuard', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return MaterialApp(
              initialRoute: '/benchmark',
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
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Departamento de Arroz (Rice Department)'), findsWidgets);
    expect(find.textContaining('RiceGuard'), findsNothing);
  });

  testWidgets('SystemPipelineScreen mobile layout (375x812) renders step cards, scrollbar and navigation', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SystemPipelineScreen(isDark: false),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SystemPipelineScreen), findsOneWidget);
    expect(find.text('ETAPA 1 DE 5'), findsOneWidget);
    expect(find.text(OryzaI18n.pt.pipeActiveTag), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('02'), findsOneWidget);

    final nextBtn = find.byTooltip(OryzaI18n.pt.navNextStep);
    expect(nextBtn, findsOneWidget);
    await tester.ensureVisible(nextBtn);
    await tester.tap(nextBtn);
    await tester.pumpAndSettle();

    expect(find.text('ETAPA 2 DE 5'), findsOneWidget);
  });

  testWidgets('HardwareWorkbenchScreen mobile layout (375x812) renders device cards and controls', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HardwareWorkbenchScreen(isDark: false),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HardwareWorkbenchScreen), findsOneWidget);
    expect(find.text('DISP. 1 DE 6'), findsOneWidget);
    expect(find.text(OryzaI18n.pt.hwDevicesTag), findsOneWidget);
    expect(find.text('RPI5-DIN-001'), findsWidgets);

    final nextBtn = find.byTooltip(OryzaI18n.pt.navNextDevice);
    expect(nextBtn, findsOneWidget);
    await tester.ensureVisible(nextBtn);
    await tester.tap(nextBtn);
    await tester.pumpAndSettle();

    expect(find.text('DISP. 2 DE 6'), findsOneWidget);
  });

  testWidgets('BenchmarkScreen mobile layout (375x812) renders table and scrollbar without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BenchmarkScreen(isDark: false),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BenchmarkScreen), findsOneWidget);
    expect(find.text('Deslize horizontalmente para comparar todas as colunas e métricas'), findsOneWidget);
    expect(find.byType(DataTable), findsOneWidget);
  });

  testWidgets('BenchmarkScreen desktop widescreen (1920x1080) renders without errors', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BenchmarkScreen(isDark: false),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BenchmarkScreen), findsOneWidget);
    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text(OryzaI18n.pt.benchmarkQuotesHeading), findsOneWidget);
  });

  testWidgets('BenchmarkScreen displays verifiable scientific citations and official government data', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BenchmarkScreen(isDark: false),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verifiable quotes: Frontiers in Plant Science, Sonos Tract, SOSBAI / Embrapa, Thai Rice Dept / OAE
    expect(find.textContaining('Frontiers in Plant Science'), findsWidgets);
    expect(find.textContaining('sonos-tract'), findsWidgets);
    expect(find.textContaining('SOSBAI'), findsWidgets);
    expect(find.textContaining('Embrapa Clima Temperado'), findsWidgets);
    expect(find.textContaining('Departamento de Arroz'), findsWidgets);
    expect(find.textContaining('https://doi.org/10.3389/fpls.2021.731454'), findsOneWidget);
    expect(find.textContaining('https://github.com/sonos/tract'), findsOneWidget);

    // Official government sources: IBGE, CONAB, OAE
    expect(find.textContaining('IBGE'), findsWidgets);
    expect(find.textContaining('CONAB'), findsWidgets);
    expect(find.textContaining('https://sidra.ibge.gov.br'), findsOneWidget);
    expect(find.textContaining('https://www.oae.go.th'), findsWidgets);
  });

  testWidgets('LandingPage hero subhead contains 100% offline autonomy and optional cloud sync', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const OryzaCloudApp());
    await tester.pump();

    expect(find.textContaining('(GDD)'), findsWidgets);
    expect(find.textContaining('100% autônoma sem internet'), findsWidgets);
    expect(find.textContaining('sincronização em nuvem opcional para análise multifazenda'), findsWidgets);
  });

  testWidgets('HowToUseScreen renders installation instructions, service managers, and API routes', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HowToUseScreen(isDark: true),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Headers & Section tag
    expect(find.text(OryzaI18n.pt.howToUseSectionTag), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseTitle), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseTabLocal), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseTabCloud), findsOneWidget);

    // Local steps
    expect(find.text(OryzaI18n.pt.howToUseLocalStep1Title), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseLocalStep2Title), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseLocalStep3Title), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseLocalStep4Title), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseLocalStep5Title), findsOneWidget);

    // Install command & environment variables
    expect(find.textContaining('curl -fsSL https://oryzaelo.asodya.com/install.sh | bash'), findsOneWidget);
    expect(find.textContaining('PORT=8080'), findsWidgets);
    expect(find.textContaining('/opt/oryzaelo/.env'), findsWidgets);

    // Linux Service Managers
    expect(find.text(OryzaI18n.pt.howToUseServiceSystemd), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseServiceOpenrc), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseServiceRunit), findsOneWidget);
    expect(find.textContaining('systemd.io'), findsOneWidget);
    expect(find.textContaining('alpinelinux.org'), findsOneWidget);
    expect(find.textContaining('voidlinux.org'), findsOneWidget);

    // Engine API routes
    expect(find.text('/health'), findsOneWidget);
    expect(find.text('/api/v1/readings'), findsOneWidget);
    expect(find.text('/api/v1/phenology'), findsOneWidget);
    expect(find.text('/api/v1/inference'), findsOneWidget);

    // GitHub Issue CTA
    expect(find.text(OryzaI18n.pt.howToUseGithubCtaTitle), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseGithubBtn), findsOneWidget);
    expect(find.textContaining('wilsonborba/oryzaelo_engine'), findsWidgets);
  });

  testWidgets('HowToUseScreen tab switching toggles between Local and Cloud flows', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HowToUseScreen(isDark: false),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Initially on Local Flow
    expect(find.text(OryzaI18n.pt.howToUseLocalStep1Title), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseCloudStep2Title), findsNothing);

    // Click Cloud + AI Tab
    await tester.tap(find.text(OryzaI18n.pt.howToUseTabCloud));
    await tester.pumpAndSettle();

    // Now on Cloud Flow
    expect(find.text(OryzaI18n.pt.howToUseCloudStep1Title), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseCloudStep2Title), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseCloudStep3Title), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseCloudStep5Title), findsOneWidget);
    expect(find.textContaining('hybrid_sync'), findsWidgets);
    expect(find.textContaining('CLOUD_API_KEY'), findsWidgets);
  });

  testWidgets('OryzaCloudApp deep links to /how-to-use', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: MaterialApp(
          initialRoute: OryzaRoutes.howToUse,
          routes: {
            OryzaRoutes.howToUse: (context) => const LandingPage(activeSection: 'howToUse'),
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(OryzaI18n.pt.howToUseTitle), findsOneWidget);
    expect(find.text(OryzaI18n.pt.howToUseTabLocal), findsOneWidget);
    expect(find.text(OryzaI18n.pt.navHowToUse.toUpperCase()), findsOneWidget);
  });

  testWidgets('SimulationDialog renders Cloud AI enhancement CTA and respects mobile layout', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SimulationDialog(isDark: true),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verification of simulation content and new Cloud CTA
    expect(find.text("SIMULADOR BIOFÍSICO DE CAMPO"), findsOneWidget);
    expect(find.text(OryzaI18n.pt.simCloudCtaTitle), findsOneWidget);
    expect(find.text(OryzaI18n.pt.simCloudCtaBody), findsOneWidget);
    expect(find.text(OryzaI18n.pt.simCloudCtaBtn), findsOneWidget);
  });

  testWidgets('HowToUseScreen translates all snippets and labels in EN and TH with oryzaelo.asodya.com', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final controller = OryzaController();

    // 1. English
    controller.setLocale(const Locale('en'));
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HowToUseScreen(isDark: true),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(OryzaI18n.en.howToUseTitle), findsOneWidget);
    expect(find.text(OryzaI18n.en.howToUseBadgeOffline), findsOneWidget);
    expect(find.text(OryzaI18n.en.howToUseLocalAccessLabel), findsOneWidget);
    expect(find.text(OryzaI18n.en.howToUseServiceHeading), findsOneWidget);
    expect(find.text(OryzaI18n.en.howToUseApiHeading), findsOneWidget);
    expect(find.textContaining('Check edge engine status'), findsOneWidget);
    expect(find.textContaining('Change PORT to avoid conflicts'), findsWidgets);

    // Switch to Cloud Tab in English
    await tester.tap(find.text(OryzaI18n.en.howToUseTabCloud));
    await tester.pumpAndSettle();

    expect(find.text(OryzaI18n.en.howToUseCloudAccountTitle), findsOneWidget);
    expect(find.text(OryzaI18n.en.howToUseCloudAccessLabel), findsOneWidget);
    expect(find.text(OryzaI18n.en.howToUseCloudAiTitle), findsOneWidget);
    expect(find.text('https://oryzaelo.asodya.com'), findsOneWidget);
    expect(find.textContaining('https://cloud.oryzaelo.asodya.com'), findsNothing);

    // 2. Thai
    controller.setLocale(const Locale('th'));
    await tester.pumpWidget(
      OryzaScope(
        controller: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HowToUseScreen(isDark: false),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(OryzaI18n.th.howToUseTitle), findsOneWidget);
    expect(find.text(OryzaI18n.th.howToUseBadgeOffline), findsOneWidget);
    expect(find.text(OryzaI18n.th.howToUseServiceHeading), findsOneWidget);
    expect(find.text(OryzaI18n.th.howToUseApiHeading), findsOneWidget);
  });
}

