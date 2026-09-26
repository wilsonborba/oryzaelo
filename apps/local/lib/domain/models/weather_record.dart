import 'metric_type.dart';

/// Daily agrometeorological weather record and ingestion report.
///
/// Every metric field is nullable: a day is genuinely partial until every
/// sensor covering the parcel has reported for it (a rain-only sensor and a
/// temperature-only sensor may report at completely different times).
/// Mirrors the backend's `WeatherRecordResponse` exactly -- never fabricates
/// a value for a field that hasn't arrived yet.
class DailyWeatherRecord {
  final DateTime date;
  final double? tMax;
  final double? tMin;
  final double? precipitationMm;
  final double? radiationMjM2;
  final double? relativeHumidityPct;

  /// Which sensor last reported each field -- provenance is per-field.
  final String? tMaxSensorId;
  final String? tMinSensorId;
  final String? rainfallSensorId;
  final String? radiationSensorId;
  final String? humiditySensorId;

  /// Growing Degree Days for this day, as computed by the backend -- the
  /// single source of truth, never recomputed client-side. `null` unless
  /// both T_max and T_min have been reported.
  final double? dailyGdd;

  const DailyWeatherRecord({
    required this.date,
    this.tMax,
    this.tMin,
    this.precipitationMm,
    this.radiationMjM2,
    this.relativeHumidityPct,
    this.tMaxSensorId,
    this.tMinSensorId,
    this.rainfallSensorId,
    this.radiationSensorId,
    this.humiditySensorId,
    this.dailyGdd,
  });

  bool get isComplete =>
      tMax != null && tMin != null && precipitationMm != null && radiationMjM2 != null && relativeHumidityPct != null;

  bool get isPartial => !isComplete;

  /// Which of the 5 canonical metrics are still missing for this day, so
  /// the UI can say exactly what's outstanding (e.g. "waiting on rainfall")
  /// instead of an opaque "incomplete" badge.
  List<MetricType> get missingMetrics {
    final missing = <MetricType>[];
    if (tMax == null) missing.add(MetricType.tMax);
    if (tMin == null) missing.add(MetricType.tMin);
    if (precipitationMm == null) missing.add(MetricType.rainfall);
    if (radiationMjM2 == null) missing.add(MetricType.radiation);
    if (relativeHumidityPct == null) missing.add(MetricType.humidity);
    return missing;
  }

  /// A short display string naming whichever sensor(s) contributed to this
  /// day, for the table's "source" column -- there is no single "source"
  /// any more since each field can come from a different sensor.
  String get sourceDisplay {
    final ids = <String>{
      ?tMaxSensorId,
      ?tMinSensorId,
      ?rainfallSensorId,
      ?radiationSensorId,
      ?humiditySensorId,
    };
    if (ids.isEmpty) return '—';
    if (ids.length == 1) return ids.first;
    return '${ids.length} sensors';
  }

  /// Diurnal Temperature Range (DTR). `null` unless both T_max and T_min
  /// have been reported.
  double? get dtr {
    if (tMax == null || tMin == null) return null;
    return (tMax! - tMin!).clamp(0.0, 50.0);
  }

  factory DailyWeatherRecord.fromJson(Map<String, dynamic> json) {
    return DailyWeatherRecord(
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      tMax: (json['t_max'] as num?)?.toDouble(),
      tMin: (json['t_min'] as num?)?.toDouble(),
      precipitationMm: (json['precipitation_mm'] as num?)?.toDouble(),
      radiationMjM2: (json['radiation_mj_m2'] as num?)?.toDouble(),
      relativeHumidityPct: (json['relative_humidity_pct'] as num?)?.toDouble(),
      tMaxSensorId: json['t_max_sensor_id'] as String?,
      tMinSensorId: json['t_min_sensor_id'] as String?,
      rainfallSensorId: json['rainfall_sensor_id'] as String?,
      radiationSensorId: json['radiation_sensor_id'] as String?,
      humiditySensorId: json['humidity_sensor_id'] as String?,
      dailyGdd: (json['daily_gdd'] as num?)?.toDouble(),
    );
  }
}

/// A human-typed manual weather entry (the "New Record" dialog): all 5
/// fields filled in at once by a person, not a physical sensor. This is a
/// write payload, deliberately separate from [DailyWeatherRecord] (a read
/// model whose fields are nullable) -- a manual entry always has every
/// field, by construction of the form that creates one.
class ManualWeatherEntry {
  final DateTime date;
  final double tMax;
  final double tMin;
  final double precipitationMm;
  final double radiationMjM2;
  final double relativeHumidityPct;
  final String source;

  const ManualWeatherEntry({
    required this.date,
    required this.tMax,
    required this.tMin,
    required this.precipitationMm,
    required this.radiationMjM2,
    required this.relativeHumidityPct,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String().split('T').first,
        't_max': tMax,
        't_min': tMin,
        'precipitation_mm': precipitationMm,
        'radiation_mj_m2': radiationMjM2,
        'relative_humidity_pct': relativeHumidityPct,
        'source': source,
      };
}

/// One parsed (date, metric_type, value) reading from a CSV upload, ready to
/// be reviewed before being persisted by the backend. Mirrors the backend's
/// `ParsedReading`.
class ParsedReading {
  final DateTime date;
  final MetricType metricType;
  final double value;

  const ParsedReading({required this.date, required this.metricType, required this.value});

  factory ParsedReading.fromJson(Map<String, dynamic> json) {
    return ParsedReading(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      metricType: MetricType.fromWire(json['metric_type'] as String? ?? '') ?? MetricType.tMax,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
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
