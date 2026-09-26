import 'metric_type.dart';

/// A single raw measurement from one physical sensor. Mirrors the backend's
/// `SensorReading` (oryzaelo_engine/src/domain/models/sensor_reading.rs) --
/// each metric type lives in its own table server-side, so this always
/// belongs to exactly one sensor and one metric, never merged with another
/// sensor's data.
class SensorReading {
  final int id;
  final String parcelId;
  final String sensorId;
  final MetricType metricType;
  final double value;
  final DateTime recordedAt;
  final DateTime receivedAt;

  const SensorReading({
    required this.id,
    required this.parcelId,
    required this.sensorId,
    required this.metricType,
    required this.value,
    required this.recordedAt,
    required this.receivedAt,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      id: json['id'] as int? ?? 0,
      parcelId: json['parcel_id'] as String? ?? '',
      sensorId: json['sensor_id'] as String? ?? '',
      metricType: MetricType.fromWire(json['metric_type'] as String? ?? '') ?? MetricType.tMax,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      recordedAt: DateTime.tryParse(json['recorded_at']?.toString() ?? '') ?? DateTime.now(),
      receivedAt: DateTime.tryParse(json['received_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
