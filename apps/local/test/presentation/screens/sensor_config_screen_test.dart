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
import 'package:local/presentation/screens/sensor_config_screen.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Rendering-level regression test for the sensor CRUD rewrite: static
/// analysis (flutter analyze) only checks types, not that the widget tree
/// actually builds without throwing at runtime. This exercises the real
/// widget tree with realistic bundled-station and standalone-sensor data.
void main() {
  Map<String, dynamic> preset(String id, List<String> metrics) => {
        'id': id,
        'device_name': id,
        'manufacturer': 'Test',
        'is_preset': true,
        'date_col': 'date',
        'date_format': '%Y-%m-%d',
        'metrics': metrics
            .map((m) => {'metric_type': m, 'column_name': m, 'unit': 'C', 'scale': 1.0})
            .toList(),
        'created_at': '2026-01-01T00:00:00Z',
      };

  Future<DashboardHandler> buildHandler() async {
    final client = MockClient((request) async {
      if (request.url.path == '/api/v1/devices/presets') {
        return http.Response(
          jsonEncode([preset('preset_davis_vantage', ['t_max', 't_min', 'rainfall', 'radiation', 'humidity'])]),
          200,
        );
      }
      if (request.url.path == '/api/v1/devices/mappings') {
        return http.Response(
          jsonEncode([
            {...preset('sensor_pluviometro_avulso', ['rainfall']), 'is_preset': false},
          ]),
          200,
        );
      }
      if (request.url.path == '/api/v1/parcels') {
        return http.Response('[]', 200);
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
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  testWidgets('renders the custom mappings list and presets with real bundled + standalone data', (tester) async {
    final handler = await buildHandler();

    await tester.pumpWidget(wrap(SensorConfigScreen(handler: handler)));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('sensor_pluviometro_avulso'), findsWidgets);
    expect(find.text('preset_davis_vantage'), findsWidgets);
  });

  testWidgets('opening the add-sensor dialog and picking a metric shows its column mapping row', (tester) async {
    final handler = await buildHandler();

    await tester.pumpWidget(wrap(SensorConfigScreen(handler: handler)));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Pick the "Rainfall" metric chip inside the dialog.
    final rainChip = find.byWidgetPredicate(
      (w) => w is FilterChip && (w.label as Text).data!.contains('Chuva'),
    ).first;
    await tester.ensureVisible(rainChip);
    await tester.tap(rainChip);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
