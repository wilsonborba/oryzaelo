import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/services/admin_service.dart';
import 'package:local/domain/services/device_service.dart';
import 'package:local/domain/services/parcel_service.dart';
import 'package:local/domain/services/phenology_service.dart';
import 'package:local/domain/services/telemetry_service.dart';
import 'package:local/domain/services/weather_service.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:local/presentation/screens/settings_screen.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

void main() {
  Future<DashboardHandler> buildHandler() async {
    final client = MockClient((request) async {
      if (request.url.path == '/api/v1/parcels') {
        return http.Response('[]', 200);
      }
      if (request.url.path == '/api/v1/config') {
        return http.Response(
          jsonEncode({
            'cron_target_time': '23:59',
            'edge_node_name': 'Raspberry Pi 5 Edge',
          }),
          200,
        );
      }
      if (request.url.path == '/api/v1/health') {
        return http.Response(
          jsonEncode({
            'status': 'healthy',
            'system': {
              'status': 'healthy',
              'os_name': 'Linux',
              'os_version': '6.6.20+rpt-rpi-2712',
              'hostname': 'oryza-edge-01',
              'cpu_cores': 4,
              'cpu_usage_pct': 12.5,
              'memory_total_bytes': 8589934592,
              'memory_used_bytes': 2147483648,
              'memory_usage_pct': 25.0,
              'disk_total_bytes': 64000000000,
              'disk_available_bytes': 42000000000,
              'uptime_seconds': 3600,
            },
            'app': {
              'status': 'healthy',
              'sqlite_connected': true,
              'onnx_model_loaded': true,
              'parcels_count': 4,
              'weather_records_count': 200,
              'cron_status': 'active',
              'cron_target_time': '23:59',
            },
          }),
          200,
        );
      }
      return http.Response('{}', 200);
    });

    final engineClient = EngineClient(baseUrl: 'http://edge.local:8005', client: client);
    final handler = DashboardHandler(
      parcelService: ParcelService(client: engineClient),
      weatherService: WeatherService(client: engineClient),
      phenologyService: PhenologyService(client: engineClient),
      telemetryService: TelemetryService(client: engineClient),
      adminService: AdminService(client: engineClient),
      deviceService: DeviceService(client: engineClient),
    );
    await handler.initialize();
    return handler;
  }

  Widget wrap(Widget child) {
    return OryzaScope(
      controller: OryzaController(),
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('renders settings screen on desktop and mobile without throwing', (tester) async {
    for (final width in [360.0, 1280.0]) {
      await tester.binding.setSurfaceSize(Size(width, 900));
      final handler = await buildHandler();

      await tester.pumpWidget(wrap(SettingsScreen(handler: handler)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('renders API Docs (Scalar) card with endpoint links and open button', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    final handler = await buildHandler();

    await tester.pumpWidget(wrap(SettingsScreen(handler: handler)));
    await tester.pumpAndSettle();

    // Verify card header and badge
    expect(find.textContaining('SCALAR'), findsWidgets);
    expect(find.text('OPENAPI 3.1 + SCALAR'), findsOneWidget);

    // Verify links are rendered
    expect(find.textContaining('/docs'), findsOneWidget);
    expect(find.textContaining('/api/v1/openapi.json'), findsOneWidget);

    // Verify open button exists
    final openBtn = find.byKey(const Key('settings_open_api_docs_btn'));
    expect(openBtn, findsOneWidget);
  });
}
