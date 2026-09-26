/// Weather analytics report, correlation matrix, and dynamic agronomic alerts.
class WeatherAnalyticsReport {
  final String parcelId;
  final DateTime evaluationDate;
  final int windowDays;
  final BiometSummary summary;
  final CorrelationMatrix correlationMatrix;
  final List<RadarDimensionScore> biometRadar;
  final Map<String, List<DynamicAdvisoryAlert>> dynamicAdvisories;

  const WeatherAnalyticsReport({
    required this.parcelId,
    required this.evaluationDate,
    required this.windowDays,
    required this.summary,
    required this.correlationMatrix,
    required this.biometRadar,
    required this.dynamicAdvisories,
  });

  List<DynamicAdvisoryAlert> getAlertsForLocale(String localeCode) {
    if (dynamicAdvisories.containsKey(localeCode)) {
      return dynamicAdvisories[localeCode]!;
    }
    if (localeCode.startsWith('pt') && dynamicAdvisories.containsKey('pt-BR')) {
      return dynamicAdvisories['pt-BR']!;
    }
    if (localeCode.startsWith('en') && dynamicAdvisories.containsKey('en')) {
      return dynamicAdvisories['en']!;
    }
    if (localeCode.startsWith('th') && dynamicAdvisories.containsKey('th')) {
      return dynamicAdvisories['th']!;
    }
    return dynamicAdvisories.values.firstOrNull ?? [];
  }

  factory WeatherAnalyticsReport.fromJson(Map<String, dynamic> json) {
    final advMapRaw =
        json['dynamic_advisories'] as Map<String, dynamic>? ?? {};
    final advMap = advMapRaw.map(
      (k, v) => MapEntry(
        k,
        (v as List<dynamic>?)
                ?.map((item) =>
                    DynamicAdvisoryAlert.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
      ),
    );

    return WeatherAnalyticsReport(
      parcelId: json['parcel_id'] as String? ?? '',
      evaluationDate: json['evaluation_date'] != null
          ? DateTime.tryParse(json['evaluation_date'].toString()) ??
              DateTime.now()
          : DateTime.now(),
      windowDays: json['window_days'] as int? ?? 60,
      summary:
          BiometSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
      correlationMatrix: CorrelationMatrix.fromJson(
          json['correlation_matrix'] as Map<String, dynamic>? ?? {}),
      biometRadar: (json['biomet_radar'] as List<dynamic>?)
              ?.map((e) =>
                  RadarDimensionScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      dynamicAdvisories: advMap,
    );
  }
}

class BiometSummary {
  final int totalRecords;
  final double totalGdd;
  final double totalRainMm;
  final double maxRainMm;
  final double meanTMaxCelsius;
  final double meanTMinCelsius;
  final double meanDtrCelsius;
  final double meanRadiationMjM2;
  final double meanRelativeHumidityPct;
  final int consecutiveDryDays;

  const BiometSummary({
    required this.totalRecords,
    required this.totalGdd,
    required this.totalRainMm,
    required this.maxRainMm,
    required this.meanTMaxCelsius,
    required this.meanTMinCelsius,
    required this.meanDtrCelsius,
    required this.meanRadiationMjM2,
    required this.meanRelativeHumidityPct,
    required this.consecutiveDryDays,
  });

  factory BiometSummary.fromJson(Map<String, dynamic> json) {
    return BiometSummary(
      totalRecords: json['total_records'] as int? ?? 0,
      totalGdd: (json['total_gdd'] as num?)?.toDouble() ?? 0.0,
      totalRainMm: (json['total_rain_mm'] as num?)?.toDouble() ?? 0.0,
      maxRainMm: (json['max_rain_mm'] as num?)?.toDouble() ?? 0.0,
      meanTMaxCelsius:
          (json['mean_t_max_celsius'] as num?)?.toDouble() ?? 0.0,
      meanTMinCelsius:
          (json['mean_t_min_celsius'] as num?)?.toDouble() ?? 0.0,
      meanDtrCelsius:
          (json['mean_dtr_celsius'] as num?)?.toDouble() ?? 0.0,
      meanRadiationMjM2:
          (json['mean_radiation_mj_m2'] as num?)?.toDouble() ?? 0.0,
      meanRelativeHumidityPct:
          (json['mean_relative_humidity_pct'] as num?)?.toDouble() ?? 0.0,
      consecutiveDryDays: json['consecutive_dry_days'] as int? ?? 0,
    );
  }
}

class CorrelationMatrix {
  final List<String> variables;
  final List<List<double>> matrix;

  const CorrelationMatrix({
    required this.variables,
    required this.matrix,
  });

  factory CorrelationMatrix.fromJson(Map<String, dynamic> json) {
    final vars = (json['variables'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final mat = (json['matrix'] as List<dynamic>?)
            ?.map((row) => (row as List<dynamic>)
                .map((cell) => (cell as num).toDouble())
                .toList())
            .toList() ??
        [];
    return CorrelationMatrix(variables: vars, matrix: mat);
  }
}

class RadarDimensionScore {
  final String key;
  final String label;
  final double score;
  final double benchmarkOptimal;
  final String description;

  const RadarDimensionScore({
    required this.key,
    required this.label,
    required this.score,
    required this.benchmarkOptimal,
    required this.description,
  });

  factory RadarDimensionScore.fromJson(Map<String, dynamic> json) {
    return RadarDimensionScore(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      benchmarkOptimal:
          (json['benchmark_optimal'] as num?)?.toDouble() ?? 100.0,
      description: json['description'] as String? ?? '',
    );
  }
}

class DynamicAdvisoryAlert {
  final String level;
  final String category;
  final String title;
  final String message;
  final String action;

  const DynamicAdvisoryAlert({
    required this.level,
    required this.category,
    required this.title,
    required this.message,
    required this.action,
  });

  factory DynamicAdvisoryAlert.fromJson(Map<String, dynamic> json) {
    return DynamicAdvisoryAlert(
      level: json['level'] as String? ?? 'info',
      category: json['category'] as String? ?? 'general',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      action: json['action'] as String? ?? '',
    );
  }
}
