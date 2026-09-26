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
import 'package:local/presentation/screens/simulation_calculator_screen.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Regression test for the nullable-field init fix: the simulator used to
/// seed its sliders from `records.last`, which could be a genuinely partial
/// day (nullable fields) after the sensor-fusion rewrite. It must fall back
/// to the last *complete* day instead.
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
              't_max_sensor_id': 'A',
              'daily_gdd': 18.0,
            },
            // The MOST RECENT day is genuinely partial (rain-only sensor) --
            // .last would have been null-unsafe before the fix.
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

  testWidgets(
    'does not crash when the parcel rice variety is not one of the 4 modeled cultivars',
    (tester) async {
      // A real seeded/created parcel's variety is very often something the
      // simulator's fixed 4-item dropdown doesn't know about (e.g. a Thai
      // cultivar name, or free text a farmer typed). This used to throw a
      // DropdownButton assertion and crash the whole screen.
      final handler = await buildHandler();
      expect(handler.selectedParcel!.riceVariety, 'RD43');

      await tester.pumpWidget(
        OryzaScope(
          controller: OryzaController(),
          child: MaterialApp(
            home: Scaffold(
              body: SimulationCalculatorScreen(handler: handler, onNavigateToData: () {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('renders without throwing when the most recent day is partial', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 1200));
    final handler = await buildHandler();
    expect(handler.weatherRecords.last.isPartial, isTrue, reason: 'test setup sanity check');

    await tester.pumpWidget(
      OryzaScope(
        controller: OryzaController(),
        child: MaterialApp(
          home: Scaffold(
            body: SimulationCalculatorScreen(handler: handler, onNavigateToData: () {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
