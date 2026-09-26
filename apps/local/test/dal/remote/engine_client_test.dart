import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/weather_record.dart';

/// Exercises EngineClient against a mocked HTTP transport — no real engine
/// process required. Covers exactly what the user asked about: does the
/// frontend actually parse the real backend response/error shapes correctly,
/// and does it degrade gracefully (never throw into the UI) on 4xx/5xx
/// responses and on outright network failures.
void main() {
  group('EngineClient — device mapping creation (schema + error handling)', () {
    test('sends the exact backend-shaped JSON body on create', () async {
      Map<String, dynamic>? capturedBody;
      final client = EngineClient(
        baseUrl: 'http://edge.local:8005',
        client: MockClient((request) async {
          capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(request.body, 201, headers: {'content-type': 'application/json'});
        }),
      );

      final mapping = DeviceMapping.blank('sensor-01').copyWith(deviceName: 'Test Sensor');
      await client.createDeviceMapping(mapping);

      expect(capturedBody, isNotNull);
      expect(capturedBody!['id'], 'sensor-01');
      expect(capturedBody!['device_name'], 'Test Sensor');
      expect(capturedBody!.containsKey('t_max_col'), isTrue);
      // The old broken schema's keys must never be sent again.
      expect(capturedBody!.containsKey('mappings'), isFalse);
      expect(capturedBody!.containsKey('model'), isFalse);
    });

    test('returns the created mapping on 201', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          return http.Response(request.body, 201, headers: {'content-type': 'application/json'});
        }),
      );

      final result = await client.createDeviceMapping(DeviceMapping.blank('sensor-02'));

      expect(result, isNotNull);
      expect(result!.id, 'sensor-02');
    });

    test('returns null (not a thrown exception) when the backend rejects with 400', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          return http.Response(
            jsonEncode({'error': 'Cannot overwrite factory preset device mapping: sensor-03', 'code': 'BAD_REQUEST'}),
            400,
          );
        }),
      );

      final result = await client.createDeviceMapping(DeviceMapping.blank('sensor-03'));

      expect(result, isNull);
    });

    test('returns null (not a thrown exception) on a network failure', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          throw const SocketException('Connection refused');
        }),
      );

      final result = await client.createDeviceMapping(DeviceMapping.blank('sensor-04'));

      expect(result, isNull);
    });

    test('returns null when the server responds with malformed JSON', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          return http.Response('{not valid json', 201);
        }),
      );

      // Must not throw a FormatException up into the caller.
      final result = await client.createDeviceMapping(DeviceMapping.blank('sensor-05'));
      expect(result, isNull);
    });
  });

  group('EngineClient — CSV upload / ingestion error handling', () {
    test('parses a real backend UploadCsvResponse with mixed valid/invalid rows', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          expect(request.url.path, '/api/v1/weather/ingest');
          final payload = jsonDecode(request.body) as Map<String, dynamic>;
          expect(payload['parcel_id'], 'p-1');
          expect(payload['device_id'], 'preset_pessl_imetos');
          return http.Response(
            jsonEncode({
              'message': 'Successfully processed 2 rows (1 persisted, 1 rejected)',
              'records_persisted': 1,
              'report': {
                'total_rows': 2,
                'successful_rows': 1,
                'failed_rows': 1,
                'records': [],
                'errors': ["Row 3: physical violation: T_min (25.00°C) cannot exceed T_max (20.00°C)"],
              },
            }),
            200,
          );
        }),
      );

      final report = await client.uploadCsv(
        parcelId: 'p-1',
        deviceId: 'preset_pessl_imetos',
        csvContent: 'Timestamp,AirTemp_Max,AirTemp_Min,Precipitation,SolarRad,RelHumidity\n...',
      );

      expect(report, isNotNull);
      expect(report!.totalRows, 2);
      expect(report.successfulRows, 1);
      expect(report.failedRows, 1);
      expect(report.errors.single, contains('T_min'));
    });

    test('a missing-column CSV (backend 400) surfaces as null, not a crash', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          return http.Response(
            jsonEncode({
              'error': "Missing column 'AirTemp_Max' for canonical field 'T_max' configured in device profile "
                  "'Pessl iMetos 3.3 (Standard Agro)'. Available columns: [Timestamp, WrongCol, ...]",
              'code': 'BAD_REQUEST',
            }),
            400,
          );
        }),
      );

      final report = await client.uploadCsv(
        parcelId: 'p-1',
        deviceId: 'preset_pessl_imetos',
        csvContent: 'Timestamp,WrongCol,...\n2026-07-01,31.5,...',
      );

      expect(report, isNull);
    });

    test('an unknown parcel_id (backend 404) surfaces as null, not a crash', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          return http.Response(jsonEncode({'error': 'Parcel ghost-parcel not found', 'code': 'NOT_FOUND'}), 404);
        }),
      );

      final report = await client.uploadCsv(
        parcelId: 'ghost-parcel',
        deviceId: 'preset_pessl_imetos',
        csvContent: 'irrelevant',
      );

      expect(report, isNull);
    });

    test('a request timeout is caught and surfaces as null, not an uncaught exception', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          // Simulate a hang longer than the client's own timeout by never
          // completing before the 30s ingest timeout would fire in
          // production — here we just throw the same exception .timeout()
          // would produce, since actually waiting 30s would make the test
          // suite slow.
          throw Exception('Simulated timeout');
        }),
      );

      final report = await client.uploadCsv(parcelId: 'p-1', deviceId: 'd-1', csvContent: 'x');
      expect(report, isNull);
    });
  });

  group('EngineClient — single record ingestion', () {
    test('sends the record as JSON with parcel_id merged in, no daily_gdd (server-computed only)', () async {
      Map<String, dynamic>? captured;
      final client = EngineClient(
        client: MockClient((request) async {
          captured = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response('{}', 201);
        }),
      );

      final record = DailyWeatherRecord(
        date: DateTime.utc(2026, 6, 6),
        tMax: 30.0,
        tMin: 20.0,
        precipitationMm: 5.0,
        radiationMjM2: 18.0,
        relativeHumidityPct: 70.0,
        source: 'Manual_Terminal_Entry',
      );

      final ok = await client.ingestSingleRecord(parcelId: 'p-1', record: record);

      expect(ok, isTrue);
      expect(captured!['parcel_id'], 'p-1');
      expect(captured!['t_max'], 30.0);
      expect(captured!.containsKey('daily_gdd'), isFalse);
    });

    test('a domain-validation 400 (e.g. t_min > t_max) returns false', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          return http.Response(
            jsonEncode({
              'error': 'Domain error: Invalid weather record: T_min (25.00°C) cannot exceed T_max (20.00°C)',
              'code': 'DOMAIN_VALIDATION_ERROR',
            }),
            400,
          );
        }),
      );

      final ok = await client.ingestSingleRecord(
        parcelId: 'p-1',
        record: DailyWeatherRecord(
          date: DateTime.utc(2026, 6, 6),
          tMax: 20.0,
          tMin: 25.0,
          precipitationMm: 0.0,
          radiationMjM2: 18.0,
          relativeHumidityPct: 70.0,
          source: 'Manual',
        ),
      );

      expect(ok, isFalse);
    });

    test('an unreachable engine (connection refused) returns false, not a thrown exception', () async {
      final client = EngineClient(
        client: MockClient((request) async => throw const SocketException('Connection refused')),
      );

      final ok = await client.ingestSingleRecord(
        parcelId: 'p-1',
        record: DailyWeatherRecord(
          date: DateTime.utc(2026, 6, 6),
          tMax: 30.0,
          tMin: 20.0,
          precipitationMm: 0.0,
          radiationMjM2: 18.0,
          relativeHumidityPct: 70.0,
          source: 'Manual',
        ),
      );

      expect(ok, isFalse);
    });
  });

  group('EngineClient — weather records fetch', () {
    test('parses daily_gdd from a list of WeatherRecordResponse', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          expect(request.url.queryParameters['parcel_id'], 'p-1');
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
        }),
      );

      final records = await client.getWeatherRecords('p-1', days: 10);

      expect(records, hasLength(1));
      expect(records.first.dailyGdd, 18.0);
    });

    test('an unreachable engine returns an empty list, not a thrown exception', () async {
      final client = EngineClient(
        client: MockClient((request) async => throw const SocketException('refused')),
      );

      final records = await client.getWeatherRecords('p-1');
      expect(records, isEmpty);
    });

    test('a 500 from the server returns an empty list', () async {
      final client = EngineClient(
        client: MockClient((request) async => http.Response('Internal Server Error', 500)),
      );

      final records = await client.getWeatherRecords('p-1');
      expect(records, isEmpty);
    });
  });

  group('EngineClient — ping / health', () {
    test('ping returns true on 200', () async {
      final client = EngineClient(client: MockClient((_) async => http.Response('{"status":"ok"}', 200)));
      expect(await client.ping(), isTrue);
    });

    test('ping returns false (not a thrown exception) when the engine is down', () async {
      final client = EngineClient(client: MockClient((_) async => throw const SocketException('refused')));
      expect(await client.ping(), isFalse);
    });

    test('ping returns false on a non-200 status', () async {
      final client = EngineClient(client: MockClient((_) async => http.Response('', 503)));
      expect(await client.ping(), isFalse);
    });
  });
}
