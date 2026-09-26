/// Daily agrometeorological weather record and ingestion report.
class DailyWeatherRecord {
  final DateTime date;
  final double tMax;
  final double tMin;
  final double precipitationMm;
  final double radiationMjM2;
  final double relativeHumidityPct;
  final String source;

  /// Growing Degree Days for this day, as computed by the backend
  /// (`WeatherRecordResponse.daily_gdd`, same formula/base temp used for the
  /// `total_gdd` aggregate) — the single source of truth, never recomputed
  /// client-side, so chart/table/backend never disagree.
  final double dailyGdd;

  const DailyWeatherRecord({
    required this.date,
    required this.tMax,
    required this.tMin,
    required this.precipitationMm,
    required this.radiationMjM2,
    required this.relativeHumidityPct,
    required this.source,
    this.dailyGdd = 0.0,
  });

  /// Diurnal Temperature Range (DTR)
  double get dtr => (tMax - tMin).clamp(0.0, 50.0);

  factory DailyWeatherRecord.fromJson(Map<String, dynamic> json) {
    return DailyWeatherRecord(
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      tMax: (json['t_max'] as num?)?.toDouble() ?? 0.0,
      tMin: (json['t_min'] as num?)?.toDouble() ?? 0.0,
      precipitationMm: (json['precipitation_mm'] as num?)?.toDouble() ?? 0.0,
      radiationMjM2: (json['radiation_mj_m2'] as num?)?.toDouble() ?? 0.0,
      relativeHumidityPct:
          (json['relative_humidity_pct'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? 'Sensor',
      dailyGdd: (json['daily_gdd'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T').first,
      't_max': tMax,
      't_min': tMin,
      'precipitation_mm': precipitationMm,
      'radiation_mj_m2': radiationMjM2,
      'relative_humidity_pct': relativeHumidityPct,
      'source': source,
    };
  }
}

class IngestionReport {
  final int totalRows;
  final int successfulRows;
  final int failedRows;
  final List<String> errors;

  const IngestionReport({
    required this.totalRows,
    required this.successfulRows,
    required this.failedRows,
    required this.errors,
  });

  factory IngestionReport.fromJson(Map<String, dynamic> json) {
    final rep = json['report'] as Map<String, dynamic>? ?? json;
    return IngestionReport(
      totalRows: rep['total_rows'] as int? ?? 0,
      successfulRows: rep['successful_rows'] as int? ??
          (json['records_persisted'] as int? ?? 0),
      failedRows: rep['failed_rows'] as int? ?? 0,
      errors: (rep['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
