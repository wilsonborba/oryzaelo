import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';
import 'package:cloud/main.dart';
import 'package:cloud/core/routes.dart';
import 'package:cloud/presentation/pages/landing_page.dart';
import 'package:cloud/presentation/widgets/benchmark_screen.dart';
import 'package:cloud/presentation/widgets/header.dart';

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
    expect(find.text('DISTRIBUIÇÃO CARTOGRÁFICA DA PRODUÇÃO DE ARROZ'), findsOneWidget);
    expect(find.text('REPERCUSSÃO CIENTÍFICA & COMUNIDADE DE BORDA'), findsOneWidget);
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
}
