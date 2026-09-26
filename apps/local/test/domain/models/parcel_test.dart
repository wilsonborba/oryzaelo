import 'package:flutter_test/flutter_test.dart';
import 'package:local/domain/models/parcel.dart';

void main() {
  group('FarmParcel JSON schema', () {
    test('toJson sends planting_date, matching the backend FarmParcel field name exactly', () {
      final parcel = FarmParcel(
        id: 'p-1',
        name: 'Talhão 1',
        areaHectares: 1.5,
        latitude: 14.0,
        longitude: 100.0,
        riceEcosystem: 'Irrigated',
        riceVariety: 'RD43',
        sowingDate: DateTime.utc(2026, 4, 1),
      );

      final json = parcel.toJson();

      expect(json['planting_date'], '2026-04-01');
      // The old, backend-incompatible key must never be sent again.
      expect(json.containsKey('sowing_date'), isFalse);
    });

    test('fromJson reads planting_date from a real backend FarmParcel response', () {
      final parcel = FarmParcel.fromJson({
        'id': 'p-1',
        'name': 'Talhão 1',
        'rice_variety': 'RD43',
        'rice_ecosystem': 'Irrigated',
        'latitude': 14.0,
        'longitude': 100.0,
        'planting_date': '2026-04-01',
        'area_hectares': 1.5,
      });

      expect(parcel.sowingDate.year, 2026);
      expect(parcel.sowingDate.month, 4);
      expect(parcel.sowingDate.day, 1);
    });

    test('round trip preserves the sowing/planting date', () {
      final original = FarmParcel(
        id: 'p-2',
        name: 'Talhão 2',
        areaHectares: 2.0,
        latitude: 13.0,
        longitude: 101.0,
        riceEcosystem: 'Rainfed',
        riceVariety: 'IR64',
        sowingDate: DateTime.utc(2026, 6, 6),
      );

      final restored = FarmParcel.fromJson(original.toJson());

      // Only the calendar date round-trips (the wire format is date-only,
      // "YYYY-MM-DD"); the local/UTC time component is not preserved.
      expect(restored.sowingDate.year, original.sowingDate.year);
      expect(restored.sowingDate.month, original.sowingDate.month);
      expect(restored.sowingDate.day, original.sowingDate.day);
    });
  });
}
