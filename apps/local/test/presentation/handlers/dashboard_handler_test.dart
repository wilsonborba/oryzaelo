import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/parcel.dart';
import 'package:local/domain/services/admin_service.dart';
import 'package:local/domain/services/parcel_service.dart';
import 'package:local/domain/services/phenology_service.dart';
import 'package:local/domain/services/telemetry_service.dart';
import 'package:local/domain/services/weather_service.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';

FarmParcel _parcel(String id, {DateTime? sowingDate}) => FarmParcel(
      id: id,
      name: 'Parcel $id',
      areaHectares: 1.0,
      latitude: 14.0,
      longitude: 100.0,
      riceEcosystem: 'Irrigated',
      riceVariety: 'RD43',
      sowingDate: sowingDate ?? DateTime.utc(2026, 4, 1),
    );

/// Counts how many requests hit each endpoint, and returns minimal-but-valid
/// responses for the 3 endpoints selectParcel fires in parallel.
class _CountingTransport {
  final Map<String, int> hits = {};

  http.Client build() => MockClient((request) async {
        final path = request.url.path;
        hits[path] = (hits[path] ?? 0) + 1;

        if (path == '/api/v1/phenology/latest') {
          // No prediction yet is a completely normal, valid state — the
          // service treats a non-200 as "null", which is what we want here.
          return http.Response('', 404);
        }
        if (path == '/api/v1/weather/records') {
          return http.Response(jsonEncode([]), 200);
        }
        if (path == '/api/v1/weather/analytics') {
          return http.Response('', 404);
        }
        return http.Response('not found', 404);
      });
}

DashboardHandler _buildHandler(http.Client mockClient) {
  final engineClient = EngineClient(baseUrl: 'http://edge.local:8005', client: mockClient);
  return DashboardHandler(
    parcelService: ParcelService(client: engineClient),
    weatherService: WeatherService(client: engineClient),
    phenologyService: PhenologyService(client: engineClient),
    adminService: AdminService(client: engineClient),
    telemetryService: TelemetryService(client: engineClient),
  );
}

void main() {
  group('DashboardHandler.selectParcel — cache buffer', () {
    test('selecting the same parcel twice in quick succession only fetches once', () async {
      final transport = _CountingTransport();
      final handler = _buildHandler(transport.build());
      final parcel = _parcel('p-1');

      await handler.selectParcel(parcel);
      await handler.selectParcel(parcel); // should hit the cache, not the network

      expect(transport.hits['/api/v1/weather/records'], 1);
      expect(transport.hits['/api/v1/weather/analytics'], 1);
      expect(transport.hits['/api/v1/phenology/latest'], 1);
    });

    test('force: true always refetches, even for the same parcel within the cache window', () async {
      final transport = _CountingTransport();
      final handler = _buildHandler(transport.build());
      final parcel = _parcel('p-1');

      await handler.selectParcel(parcel);
      await handler.selectParcel(parcel, force: true);

      expect(transport.hits['/api/v1/weather/records'], 2);
      expect(transport.hits['/api/v1/weather/analytics'], 2);
    });

    test('switching to a different parcel always fetches, cache is per-parcel', () async {
      final transport = _CountingTransport();
      final handler = _buildHandler(transport.build());

      await handler.selectParcel(_parcel('p-1'));
      await handler.selectParcel(_parcel('p-2'));
      await handler.selectParcel(_parcel('p-1')); // back to p-1: not the same "last cached" parcel anymore

      expect(transport.hits['/api/v1/weather/records'], 3);
    });

    test('a failed fetch (backend unreachable) does not poison the cache as "fresh"', () async {
      var callCount = 0;
      final client = MockClient((request) async {
        callCount++;
        throw Exception('Connection refused');
      });
      final handler = _buildHandler(client);
      final parcel = _parcel('p-1');

      // Both calls should attempt the network — a failed fetch must not be
      // remembered as a successful cache fill (or the UI would be stuck
      // believing broken/empty data is current for 30 minutes).
      await handler.selectParcel(parcel);
      await handler.selectParcel(parcel, force: true);

      expect(callCount, greaterThan(0));
      expect(handler.weatherRecords, isEmpty);
    });
  });

  group('DashboardHandler.selectParcel — data population', () {
    test('populates weatherRecords from a real backend-shaped response', () async {
      final client = MockClient((request) async {
        if (request.url.path == '/api/v1/weather/records') {
          return http.Response(
            jsonEncode([
              {
                'date': '2026-06-06',
                't_max': 34.0,
                't_min': 22.0,
                'precipitation_mm': 0.0,
                'radiation_mj_m2': 20.0,
                'relative_humidity_pct': 70.0,
                'source': 'A',
                'daily_gdd': 18.0,
              },
            ]),
            200,
          );
        }
        return http.Response('', 404);
      });
      final handler = _buildHandler(client);

      await handler.selectParcel(_parcel('p-1'));

      expect(handler.weatherRecords, hasLength(1));
      expect(handler.weatherRecords.first.dailyGdd, 18.0);
    });
  });

  group('DashboardHandler.selectParcel — cumulative GDD fetch window', () {
    test('a parcel more than 60 days into its cycle requests a window covering the full cycle', () async {
      String? capturedDays;
      final client = MockClient((request) async {
        if (request.url.path == '/api/v1/weather/records') {
          capturedDays = request.url.queryParameters['days'];
          return http.Response(jsonEncode([]), 200);
        }
        return http.Response('', 404);
      });
      final handler = _buildHandler(client);

      // 90 days after sowing: a fixed 60-day window would truncate the first
      // 30 days of the season from the cumulative GDD chart.
      final oldParcel = _parcel('p-old', sowingDate: DateTime.now().subtract(const Duration(days: 90)));
      await handler.selectParcel(oldParcel);

      expect(int.parse(capturedDays!), greaterThanOrEqualTo(90));
    });

    test('a parcel within its first 60 days still requests at least the 60-day default window', () async {
      String? capturedDays;
      final client = MockClient((request) async {
        if (request.url.path == '/api/v1/weather/records') {
          capturedDays = request.url.queryParameters['days'];
          return http.Response(jsonEncode([]), 200);
        }
        return http.Response('', 404);
      });
      final handler = _buildHandler(client);

      final youngParcel = _parcel('p-young', sowingDate: DateTime.now().subtract(const Duration(days: 10)));
      await handler.selectParcel(youngParcel);

      expect(int.parse(capturedDays!), greaterThanOrEqualTo(60));
    });
  });

  group('DashboardHandler.updateCronTargetTime', () {
    test('applies the new time locally only when the backend accepts it', () async {
      final client = MockClient((request) async => http.Response('{}', 200));
      final handler = _buildHandler(client);

      final ok = await handler.updateCronTargetTime('06:30');

      expect(ok, isTrue);
      expect(handler.cronTargetTime, '06:30');
    });

    test('leaves cronTargetTime unchanged when the backend rejects the value', () async {
      final client = MockClient((request) async => http.Response('{"error":"bad"}', 400));
      final handler = _buildHandler(client);

      final ok = await handler.updateCronTargetTime('99:99');

      expect(ok, isFalse);
      expect(handler.cronTargetTime, isNull);
    });

    test('a successful update also refreshes appHealth, so the HUD label reflects it immediately', () async {
      var configApplied = false;
      final client = MockClient((request) async {
        if (request.method == 'PUT' && request.url.path == '/api/v1/config') {
          configApplied = true;
          return http.Response('{}', 200);
        }
        if (request.url.path == '/api/v1/health/app') {
          return http.Response(
            jsonEncode({
              'status': 'healthy',
              'cron_scheduler': {'status': 'active', 'target_time': configApplied ? '06:30' : '23:59'},
            }),
            200,
          );
        }
        return http.Response('{}', 200);
      });
      final handler = _buildHandler(client);

      await handler.updateCronTargetTime('06:30');

      expect(handler.appHealth?.cronTargetTime, '06:30');
    });
  });
}
