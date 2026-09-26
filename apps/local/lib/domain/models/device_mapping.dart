import 'metric_type.dart';

/// Column specification, unit, and scale multiplier for one metric a sensor
/// profile reports. Mirrors the backend's `MetricColumnMapping`.
class MetricColumnMapping {
  final MetricType metricType;
  final String columnName;
  final String unit;
  final double scale;

  const MetricColumnMapping({
    required this.metricType,
    required this.columnName,
    required this.unit,
    required this.scale,
  });

  factory MetricColumnMapping.fromJson(Map<String, dynamic> json) {
    return MetricColumnMapping(
      metricType: MetricType.fromWire(json['metric_type'] as String? ?? '') ?? MetricType.tMax,
      columnName: json['column_name'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'metric_type': metricType.wireValue,
        'column_name': columnName,
        'unit': unit,
        'scale': scale,
      };

  MetricColumnMapping copyWith({String? columnName, String? unit, double? scale}) {
    return MetricColumnMapping(
      metricType: metricType,
      columnName: columnName ?? this.columnName,
      unit: unit ?? this.unit,
      scale: scale ?? this.scale,
    );
  }
}

/// Sensor profile domain model. Mirrors the backend's `DeviceMapping` struct
/// field-for-field (oryzaelo_engine/src/domain/models/device_mapping.rs).
///
/// A profile declares 1..5 metric mappings -- a standalone sensor (a rain
/// gauge, a pyranometer) declares exactly the one metric it physically
/// measures; a bundled multi-sensor weather station (Davis Vantage Pro2,
/// Pessl iMetos) declares all 5, matching how these real commercial
/// products actually report (one combined feed). There is no forced
/// "every sensor has 5 fields" assumption any more.
class DeviceMapping {
  final String id;
  final String deviceName;
  final String manufacturer;
  final bool isPreset;

  final String dateCol;
  final String dateFormat;

  final List<MetricColumnMapping> metrics;

  final DateTime createdAt;

  const DeviceMapping({
    required this.id,
    required this.deviceName,
    required this.manufacturer,
    required this.isPreset,
    required this.dateCol,
    required this.dateFormat,
    required this.metrics,
    required this.createdAt,
  });

  MetricColumnMapping? metric(MetricType type) {
    for (final m in metrics) {
      if (m.metricType == type) return m;
    }
    return null;
  }

  bool get isSingleMetric => metrics.length == 1;

  List<MetricType> metricTypes() => metrics.map((m) => m.metricType).toList();

  /// Blank slate for registering a new standalone single-metric sensor:
  /// the farmer picks the metric type and fills in exactly the one column
  /// their own sensor sends, instead of guessing from a manufacturer preset.
  factory DeviceMapping.blankSingleMetric(String id, MetricType metricType) {
    return DeviceMapping(
      id: id,
      deviceName: '',
      manufacturer: 'Custom',
      isPreset: false,
      dateCol: '',
      dateFormat: 'yyyy-MM-dd',
      metrics: [
        MetricColumnMapping(metricType: metricType, columnName: '', unit: metricType.canonicalUnit, scale: 1.0),
      ],
      createdAt: DateTime.now(),
    );
  }

  factory DeviceMapping.fromJson(Map<String, dynamic> json) {
    final rawMetrics = json['metrics'] as List<dynamic>? ?? [];
    return DeviceMapping(
      id: json['id'] as String? ?? '',
      deviceName: json['device_name'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      isPreset: json['is_preset'] as bool? ?? false,
      dateCol: json['date_col'] as String? ?? '',
      dateFormat: json['date_format'] as String? ?? 'yyyy-MM-dd',
      metrics: rawMetrics.map((m) => MetricColumnMapping.fromJson(m as Map<String, dynamic>)).toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_name': deviceName,
      'manufacturer': manufacturer,
      'is_preset': isPreset,
      'date_col': dateCol,
      'date_format': dateFormat,
      'metrics': metrics.map((m) => m.toJson()).toList(),
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  DeviceMapping copyWith({
    String? id,
    String? deviceName,
    String? manufacturer,
    bool? isPreset,
    String? dateCol,
    String? dateFormat,
    List<MetricColumnMapping>? metrics,
  }) {
    return DeviceMapping(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      manufacturer: manufacturer ?? this.manufacturer,
      isPreset: isPreset ?? this.isPreset,
      dateCol: dateCol ?? this.dateCol,
      dateFormat: dateFormat ?? this.dateFormat,
      metrics: metrics ?? this.metrics,
      createdAt: createdAt,
    );
  }
}
