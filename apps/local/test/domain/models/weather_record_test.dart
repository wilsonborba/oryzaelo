import 'package:flutter_test/flutter_test.dart';
import 'package:local/domain/models/weather_record.dart';

void main() {
  group('DailyWeatherRecord', () {
    test('fromJson parses the backend WeatherRecordResponse shape, including daily_gdd', () {
      // Exact shape of oryzaelo_engine's WeatherRecordResponse (added this
      // session so the chart/table stop recomputing GDD client-side).
      final json = {
        'date': '2026-06-06',
        't_max': 34.0,
        't_min': 22.0,
        'precipitation_mm': 0.0,
        'radiation_mj_m2': 20.0,
        'relative_humidity_pct': 70.0,
        'source': 'LoRaWAN_Station_A',
        'daily_gdd': 18.0,
      };

      final record = DailyWeatherRecord.fromJson(json);

      expect(record.tMax, 34.0);
      expect(record.tMin, 22.0);
      expect(record.source, 'LoRaWAN_Station_A');
      expect(record.dailyGdd, 18.0);
      expect(record.date.year, 2026);
      expect(record.date.month, 6);
      expect(record.date.day, 6);
    });

    test('fromJson defaults daily_gdd to 0.0 when the backend omits it (older/mocked responses)', () {
      final record = DailyWeatherRecord.fromJson({
        'date': '2026-06-06',
        't_max': 30.0,
        't_min': 20.0,
        'precipitation_mm': 0.0,
        'radiation_mj_m2': 18.0,
        'relative_humidity_pct': 70.0,
        'source': 'Manual',
      });

      expect(record.dailyGdd, 0.0);
    });

    test('toJson never sends daily_gdd back to the server (it is server-computed, read-only)', () {
      final record = DailyWeatherRecord(
        date: _fixedDate,
        tMax: 30.0,
        tMin: 20.0,
        precipitationMm: 5.0,
        radiationMjM2: 18.0,
        relativeHumidityPct: 70.0,
        source: 'Manual_Terminal_Entry',
        dailyGdd: 999.0, // even if populated, must not round-trip out
      );

      final json = record.toJson();

      expect(json.containsKey('daily_gdd'), isFalse);
      expect(json['date'], '2026-06-06');
    });

    test('dtr getter computes and clamps correctly', () {
      final hot = DailyWeatherRecord(
        date: _fixedDate,
        tMax: 40.0,
        tMin: 15.0,
        precipitationMm: 0.0,
        radiationMjM2: 20.0,
        relativeHumidityPct: 60.0,
        source: 'x',
      );
      expect(hot.dtr, 25.0);

      // tMin > tMax should never happen post-validation, but the getter
      // must not go negative if it ever does.
      final inverted = DailyWeatherRecord(
        date: _fixedDate,
        tMax: 10.0,
        tMin: 20.0,
        precipitationMm: 0.0,
        radiationMjM2: 20.0,
        relativeHumidityPct: 60.0,
        source: 'x',
      );
      expect(inverted.dtr, 0.0);
    });
  });

  group('IngestionReport', () {
    test('parses the real backend UploadCsvResponse shape ({message, report, records_persisted})', () {
      final json = {
        'message': 'Successfully processed 3 rows (2 persisted, 1 rejected)',
        'records_persisted': 2,
        'report': {
          'total_rows': 3,
          'successful_rows': 2,
          'failed_rows': 1,
          'records': [],
          'errors': ["Row 2: physical violation: T_min (25.00°C) cannot exceed T_max (20.00°C)"],
        },
      };

      final report = IngestionReport.fromJson(json);

      expect(report.totalRows, 3);
      expect(report.successfulRows, 2);
      expect(report.failedRows, 1);
      expect(report.errors, hasLength(1));
      expect(report.errors.first, contains('T_min'));
    });

    test('falls back to records_persisted when report.successful_rows is absent', () {
      final report = IngestionReport.fromJson({
        'records_persisted': 5,
        'report': {'total_rows': 5, 'failed_rows': 0, 'errors': []},
      });

      expect(report.successfulRows, 5);
    });

    test('a fully-failed batch (zero successful rows) parses without error', () {
      final report = IngestionReport.fromJson({
        'records_persisted': 0,
        'report': {
          'total_rows': 1,
          'successful_rows': 0,
          'failed_rows': 1,
          'errors': ['Row 2: physical violation: T_min (25.00°C) cannot exceed T_max (20.00°C)'],
        },
      });

      expect(report.successfulRows, 0);
      expect(report.failedRows, 1);
      expect(report.errors.single, contains('physical violation'));
    });
  });
}

final _fixedDate = DateTime.utc(2026, 6, 6);
