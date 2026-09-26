import 'package:flutter_test/flutter_test.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/metric_type.dart';

/// Locks the exact JSON shape DeviceMapping sends/receives against the Rust
/// backend's `DeviceMapping` struct (oryzaelo_engine/src/domain/models/
/// device_mapping.rs). A sensor profile declares 1..5 metric mappings, not
/// a fixed 5-field shape -- a standalone single-metric sensor only ever
/// declares the one metric it measures.
void main() {
  group('DeviceMapping JSON schema', () {
    test('toJson produces exactly the field names the backend expects', () {
      final mapping = DeviceMapping(
        id: 'custom-01',
        deviceName: 'Field Station 01',
        manufacturer: 'Custom',
        isPreset: false,
        dateCol: 'date',
        dateFormat: 'yyyy-MM-dd',
        metrics: const [
          MetricColumnMapping(metricType: MetricType.tMax, columnName: 't_max', unit: 'C', scale: 1.0),
          MetricColumnMapping(metricType: MetricType.tMin, columnName: 't_min', unit: 'C', scale: 1.0),
          MetricColumnMapping(metricType: MetricType.rainfall, columnName: 'rain', unit: 'mm', scale: 1.0),
          MetricColumnMapping(metricType: MetricType.radiation, columnName: 'rad', unit: 'MJ/m2', scale: 1.0),
          MetricColumnMapping(metricType: MetricType.humidity, columnName: 'rh', unit: '%', scale: 1.0),
        ],
        createdAt: DateTime.utc(2026, 6, 6),
      );

      final json = mapping.toJson();

      // Exact key set the backend struct's serde derive expects — no more,
      // no less. A stray/missing key here means the schema drifted again.
      expect(
        json.keys.toSet(),
        {'id', 'device_name', 'manufacturer', 'is_preset', 'date_col', 'date_format', 'metrics', 'created_at'},
      );
      expect(json['device_name'], 'Field Station 01');
      expect(json['is_preset'], false);
      expect(json['created_at'], '2026-06-06T00:00:00.000Z');

      final metrics = json['metrics'] as List<dynamic>;
      expect(metrics, hasLength(5));
      expect(metrics[0], {'metric_type': 't_max', 'column_name': 't_max', 'unit': 'C', 'scale': 1.0});
    });

    test('fromJson parses a backend-shaped preset response correctly', () {
      // Exact shape the Rust `pessl_preset()` factory serializes.
      final json = {
        'id': 'preset_pessl_imetos',
        'device_name': 'Pessl iMetos 3.3 (Standard Agro)',
        'manufacturer': 'Pessl Instruments (Austria/Germany)',
        'is_preset': true,
        'date_col': 'Timestamp',
        'date_format': '%Y-%m-%d',
        'metrics': [
          {'metric_type': 't_max', 'column_name': 'AirTemp_Max', 'unit': 'C', 'scale': 1.0},
          {'metric_type': 't_min', 'column_name': 'AirTemp_Min', 'unit': 'C', 'scale': 1.0},
          {'metric_type': 'rainfall', 'column_name': 'Precipitation', 'unit': 'mm', 'scale': 1.0},
          {'metric_type': 'radiation', 'column_name': 'SolarRad', 'unit': 'W/m2', 'scale': 1.0},
          {'metric_type': 'humidity', 'column_name': 'RelHumidity', 'unit': '%', 'scale': 1.0},
        ],
        'created_at': '2026-01-01T00:00:00Z',
      };

      final mapping = DeviceMapping.fromJson(json);

      expect(mapping.id, 'preset_pessl_imetos');
      expect(mapping.deviceName, 'Pessl iMetos 3.3 (Standard Agro)');
      expect(mapping.isPreset, isTrue);
      expect(mapping.metric(MetricType.tMax)!.columnName, 'AirTemp_Max');
      expect(mapping.metric(MetricType.radiation)!.unit, 'W/m2');
      expect(mapping.metricTypes(), hasLength(5));
    });

    test('round trip preserves every field', () {
      final original = DeviceMapping(
        id: 'roundtrip-01',
        deviceName: 'RT Station',
        manufacturer: 'Custom',
        isPreset: false,
        dateCol: 'd',
        dateFormat: '%Y-%m-%d',
        metrics: const [
          MetricColumnMapping(metricType: MetricType.tMax, columnName: 'tmax', unit: 'F', scale: 1.8),
          MetricColumnMapping(metricType: MetricType.rainfall, columnName: 'r', unit: 'in', scale: 0.1),
        ],
        createdAt: DateTime.utc(2026, 3, 15, 10, 30),
      );

      final restored = DeviceMapping.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.deviceName, original.deviceName);
      expect(restored.metric(MetricType.tMax)!.scale, 1.8);
      expect(restored.metric(MetricType.rainfall)!.scale, 0.1);
      expect(restored.createdAt, original.createdAt);
    });

    test('blankSingleMetric() gives a standalone sensor exactly one metric mapping', () {
      final blank = DeviceMapping.blankSingleMetric('new-sensor', MetricType.rainfall);

      expect(blank.id, 'new-sensor');
      expect(blank.isPreset, isFalse);
      expect(blank.metricTypes(), [MetricType.rainfall]);
      expect(blank.metric(MetricType.rainfall)!.columnName, isEmpty);
      // Unit still gets a sane default so the form isn't blank in that column.
      expect(blank.metric(MetricType.rainfall)!.unit, 'mm');
      expect(blank.metric(MetricType.tMax), isNull);
    });

    test('fromJson tolerates a missing field with sane defaults instead of throwing', () {
      final mapping = DeviceMapping.fromJson({'id': 'partial'});

      expect(mapping.id, 'partial');
      expect(mapping.deviceName, isEmpty);
      expect(mapping.metrics, isEmpty);
      expect(mapping.isPreset, isFalse);
    });
  });
}
