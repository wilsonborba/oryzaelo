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
import 'package:local/presentation/screens/data_management_screen.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Rendering-level regression test for the partial-day table + CSV dialog
/// rewrite: exercises the real widget tree against a mix of a complete day
/// and a genuinely partial day (only rainfall reported).
void main() {
  Future<DashboardHandler> buildHandler() async {
    final client = MockClient((request) async {
      if (request.url.path == '/api/v1/parcels') {
        return http.Response(
          jsonEncode([
            {
              'id': 'p-1',
              'name': 'Talhão Teste',
              'rice_variety': 'RD43',
              'rice_ecosystem': 'Irrigated',
              'latitude': 14.0,
              'longitude': 100.0,
              'planting_date': '2026-04-01',
              'area_hectares': 1.0,
            },
          ]),
          200,
        );
      }
      if (request.url.path == '/api/v1/weather/records') {
        return http.Response(
          jsonEncode([
            {
              'date': '2026-06-05',
              't_max': 33.0,
              't_min': 23.0,
              'precipitation_mm': 0.0,
              'radiation_mj_m2': 18.0,
              'relative_humidity_pct': 75.0,
              't_max_sensor_id': 'preset_davis_vantage',
              'daily_gdd': 18.0,
            },
            {
              'date': '2026-06-06',
              't_max': null,
              't_min': null,
              'precipitation_mm': 5.0,
              'radiation_mj_m2': null,
              'relative_humidity_pct': null,
              'rainfall_sensor_id': 'rain-gauge-01',
              'daily_gdd': null,
            },
          ]),
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
    if (handler.parcels.isNotEmpty) {
      await handler.selectParcel(handler.parcels.first, force: true);
    }
    return handler;
  }

  Widget wrap(Widget child) {
    return OryzaScope(
      controller: OryzaController(),
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  testWidgets('renders complete and partial days side by side without throwing', (tester) async {
    // Real phone width -- 3 genuine overflow bugs on this screen (the header
    // banner, the CSV choose-file row, the pagination rows-per-page row)
    // only ever showed up between 300-1000px. The default 800x600 test
    // surface happened to sit right in the middle of that broken range.
    await tester.binding.setSurfaceSize(const Size(360, 900));
    final handler = await buildHandler();
    expect(handler.weatherRecords, hasLength(2));
    expect(handler.weatherRecords.firstWhere((r) => r.date.day == 6).isPartial, isTrue);

    await tester.pumpWidget(wrap(DataManagementScreen(handler: handler)));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // The partial day's warning icon must actually be in the tree.
    expect(find.byIcon(Icons.warning_amber_rounded), findsWidgets);
    // Missing fields render as an em dash, never a null-crash or "0.0".
    expect(find.text('—'), findsWidgets);
  });

  testWidgets('opening the CSV import dialog does not throw', (tester) async {
    // Real phone width -- a prior overflow here (the choose-file Row) only
    // ever showed up below ~300px, which the default 800x600 test surface
    // never exercises.
    await tester.binding.setSurfaceSize(const Size(360, 900));
    final handler = await buildHandler();

    await tester.pumpWidget(wrap(DataManagementScreen(handler: handler)));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.upload_file_rounded).first);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('switching between daily view and sensor history view does not throw', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 900));
    final handler = await buildHandler();

    await tester.pumpWidget(wrap(DataManagementScreen(handler: handler)));
    await tester.pumpAndSettle();

    // Tap sensor history tab icon
    final historyTab = find.byIcon(Icons.history_rounded);
    expect(historyTab, findsOneWidget);
    await tester.tap(historyTab);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    // Switch back to daily view
    final dailyTab = find.byIcon(Icons.calendar_today_rounded);
    expect(dailyTab, findsOneWidget);
    await tester.tap(dailyTab);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
