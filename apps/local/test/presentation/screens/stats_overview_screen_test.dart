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
import 'package:local/presentation/screens/stats_overview_screen.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// The default full-app smoke test (widget_test.dart) only ever boots with
/// zero parcels, so it exercises this screen's empty state, never the
/// actual chart-painting code path (GddAccumulationChart, ThermalHumidityChart,
/// etc.) that reads `AgrometeorologicalCharts.completeRecords`. This test
/// feeds real, partially-partial data through it.
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
        final records = List.generate(20, (i) {
          final date = DateTime.utc(2026, 6, 1).add(Duration(days: i));
          // Every 5th day is a genuinely partial day (rain-only sensor).
          if (i % 5 == 0) {
            return {
              'date': date.toIso8601String().split('T').first,
              't_max': null,
              't_min': null,
              'precipitation_mm': 2.0,
              'radiation_mj_m2': null,
              'relative_humidity_pct': null,
              'rainfall_sensor_id': 'rain-gauge-01',
              'daily_gdd': null,
            };
          }
          return {
            'date': date.toIso8601String().split('T').first,
            't_max': 33.0,
            't_min': 23.0,
            'precipitation_mm': 0.0,
            'radiation_mj_m2': 18.0,
            'relative_humidity_pct': 75.0,
            't_max_sensor_id': 'preset_davis_vantage',
            'daily_gdd': 18.0,
          };
        });
        return http.Response(jsonEncode(records), 200);
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
      child: MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child))),
    );
  }

  for (final width in [360.0, 800.0, 1400.0]) {
    testWidgets('renders charts with a mix of complete and partial days at ${width}px without overflow', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 1600));
      final handler = await buildHandler();
      expect(handler.weatherRecords.any((r) => r.isPartial), isTrue, reason: 'test setup sanity check');

      await tester.pumpWidget(wrap(StatsOverviewScreen(handler: handler)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}
