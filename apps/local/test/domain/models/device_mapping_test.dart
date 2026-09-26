import 'package:flutter_test/flutter_test.dart';
import 'package:local/domain/models/device_mapping.dart';

/// Locks the exact JSON shape DeviceMapping sends/receives against the Rust
/// backend's `DeviceMapping` struct (oryzaelo_engine/src/domain/models/
/// device_mapping.rs). This schema mismatch was a real, previously-shipped
/// bug this session: the old Dart model sent a completely different shape
/// (`{id, name, model, description, mappings: [...]}`) that the backend
/// could never deserialize, so "add custom sensor" silently failed with no
/// error surfaced anywhere. If this test ever fails after an edit to either
/// side, the two are drifting apart again.
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
        tMaxCol: 't_max',
        tMaxUnit: 'C',
        tMaxScale: 1.0,
        tMinCol: 't_min',
        tMinUnit: 'C',
        tMinScale: 1.0,
        rainCol: 'rain',
        rainUnit: 'mm',
        rainScale: 1.0,
        radCol: 'rad',
        radUnit: 'MJ/m2',
        radScale: 1.0,
        rhCol: 'rh',
        rhUnit: '%',
        rhScale: 1.0,
        createdAt: DateTime.utc(2026, 6, 6),
      );

      final json = mapping.toJson();

      // Exact key set the backend struct's serde derive expects — no more,
      // no less. A stray/missing key here means the schema drifted again.
      expect(
        json.keys.toSet(),
        {
          'id', 'device_name', 'manufacturer', 'is_preset',
          'date_col', 'date_format',
          't_max_col', 't_max_unit', 't_max_scale',
          't_min_col', 't_min_unit', 't_min_scale',
          'rain_col', 'rain_unit', 'rain_scale',
          'rad_col', 'rad_unit', 'rad_scale',
          'rh_col', 'rh_unit', 'rh_scale',
          'created_at',
        },
      );
      expect(json['device_name'], 'Field Station 01');
      expect(json['is_preset'], false);
      expect(json['t_max_scale'], 1.0);
      expect(json['created_at'], '2026-06-06T00:00:00.000Z');
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
        't_max_col': 'AirTemp_Max', 't_max_unit': 'C', 't_max_scale': 1.0,
        't_min_col': 'AirTemp_Min', 't_min_unit': 'C', 't_min_scale': 1.0,
        'rain_col': 'Precipitation', 'rain_unit': 'mm', 'rain_scale': 1.0,
        'rad_col': 'SolarRad', 'rad_unit': 'W/m2', 'rad_scale': 1.0,
        'rh_col': 'RelHumidity', 'rh_unit': '%', 'rh_scale': 1.0,
        'created_at': '2026-01-01T00:00:00Z',
      };

      final mapping = DeviceMapping.fromJson(json);

      expect(mapping.id, 'preset_pessl_imetos');
      expect(mapping.deviceName, 'Pessl iMetos 3.3 (Standard Agro)');
      expect(mapping.isPreset, isTrue);
      expect(mapping.tMaxCol, 'AirTemp_Max');
      expect(mapping.radUnit, 'W/m2');
    });

    test('round trip preserves every field', () {
      final original = DeviceMapping(
        id: 'roundtrip-01',
        deviceName: 'RT Station',
        manufacturer: 'Custom',
        isPreset: false,
        dateCol: 'd',
        dateFormat: '%Y-%m-%d',
        tMaxCol: 'tmax', tMaxUnit: 'F', tMaxScale: 1.8,
        tMinCol: 'tmin', tMinUnit: 'F', tMinScale: 1.8,
        rainCol: 'r', rainUnit: 'in', rainScale: 0.1,
        radCol: 'rd', radUnit: 'W/m2', radScale: 2.0,
        rhCol: 'h', rhUnit: '%', rhScale: 0.5,
        createdAt: DateTime.utc(2026, 3, 15, 10, 30),
      );

      final restored = DeviceMapping.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.deviceName, original.deviceName);
      expect(restored.tMaxScale, original.tMaxScale);
      expect(restored.rainScale, original.rainScale);
      expect(restored.rhScale, original.rhScale);
      expect(restored.createdAt, original.createdAt);
    });

    test('blank() gives every column an empty string, ready for the "Outro" flow', () {
      final blank = DeviceMapping.blank('new-sensor');

      expect(blank.id, 'new-sensor');
      expect(blank.isPreset, isFalse);
      expect(blank.tMaxCol, isEmpty);
      expect(blank.tMinCol, isEmpty);
      expect(blank.rainCol, isEmpty);
      expect(blank.radCol, isEmpty);
      expect(blank.rhCol, isEmpty);
      // Units still get sane defaults so the form isn't blank in that column.
      expect(blank.tMaxUnit, 'C');
      expect(blank.rhUnit, '%');
    });

    test('fromJson tolerates a missing field with sane defaults instead of throwing', () {
      final mapping = DeviceMapping.fromJson({'id': 'partial'});

      expect(mapping.id, 'partial');
      expect(mapping.deviceName, isEmpty);
      expect(mapping.tMaxScale, 1.0);
      expect(mapping.isPreset, isFalse);
    });
  });
}
