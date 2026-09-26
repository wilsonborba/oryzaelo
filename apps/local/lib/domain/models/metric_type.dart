/// The 5 canonical agrometeorological variables the phenology model
/// consumes. Every sensor profile, reading, and column mapping is tagged
/// with exactly one of these -- mirrors the backend's `MetricType` enum
/// (oryzaelo_engine/src/domain/models/metric_type.rs) field-for-field.
enum MetricType {
  tMax,
  tMin,
  rainfall,
  radiation,
  humidity;

  /// Wire identifier, matching the backend's `serde(rename_all = "snake_case")`.
  String get wireValue {
    switch (this) {
      case MetricType.tMax:
        return 't_max';
      case MetricType.tMin:
        return 't_min';
      case MetricType.rainfall:
        return 'rainfall';
      case MetricType.radiation:
        return 'radiation';
      case MetricType.humidity:
        return 'humidity';
    }
  }

  static MetricType? fromWire(String value) {
    for (final m in MetricType.values) {
      if (m.wireValue == value) return m;
    }
    return null;
  }

  String get canonicalUnit {
    switch (this) {
      case MetricType.tMax:
      case MetricType.tMin:
        return 'C';
      case MetricType.rainfall:
        return 'mm';
      case MetricType.radiation:
        return 'MJ/m2';
      case MetricType.humidity:
        return '%';
    }
  }
}
