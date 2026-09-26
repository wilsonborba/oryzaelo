import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/metric_type.dart';

/// Covers the per-sensor raw reading CRUD endpoints -- each metric type
/// lives in its own backend table, and this is the client-side path to
/// list/delete an individual sensor's own readings.
void main() {
  group('EngineClient — sensor readings', () {
    test('listSensorReadings sends the right query params and parses the response', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          expect(request.url.path, '/api/v1/weather/sensor-readings');
          expect(request.url.queryParameters['parcel_id'], 'p-1');
          expect(request.url.queryParameters['metric_type'], 'rainfall');
          return http.Response(
            jsonEncode([
              {
                'id': 1,
                'parcel_id': 'p-1',
                'sensor_id': 'rain-gauge-01',
                'metric_type': 'rainfall',
                'value': 5.0,
                'recorded_at': '2026-06-06T12:00:00Z',
                'received_at': '2026-06-06T12:00:05Z',
              },
            ]),
            200,
          );
        }),
      );

      final readings = await client.listSensorReadings(parcelId: 'p-1', metricType: MetricType.rainfall);

      expect(readings, hasLength(1));
      expect(readings.first.sensorId, 'rain-gauge-01');
      expect(readings.first.value, 5.0);
    });

    test('listSensorReadings returns an empty list (not a crash) when unreachable', () async {
      final client = EngineClient(
        client: MockClient((request) async => throw Exception('refused')),
      );

      final readings = await client.listSensorReadings(parcelId: 'p-1', metricType: MetricType.rainfall);

      expect(readings, isEmpty);
    });

    test('deleteSensorReading sends the metric_type as a query param', () async {
      Uri? capturedUri;
      final client = EngineClient(
        client: MockClient((request) async {
          capturedUri = request.url;
          return http.Response('{"deleted":true}', 200);
        }),
      );

      final ok = await client.deleteSensorReading(id: 42, metricType: MetricType.tMax);

      expect(ok, isTrue);
      expect(capturedUri!.path, '/api/v1/weather/sensor-readings/42');
      expect(capturedUri!.queryParameters['metric_type'], 't_max');
    });

    test('deleteSensorReading returns false (not a thrown exception) on a network failure', () async {
      final client = EngineClient(
        client: MockClient((request) async => throw Exception('refused')),
      );

      final ok = await client.deleteSensorReading(id: 1, metricType: MetricType.humidity);

      expect(ok, isFalse);
    });
  });
}
