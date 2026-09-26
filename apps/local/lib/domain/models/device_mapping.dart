/// Sensor mapping and telemetry configuration domain model.
///
/// Mirrors the backend's `DeviceMapping` struct field-for-field
/// (oryzaelo_engine/src/domain/models/device_mapping.rs) — a device maps its
/// own CSV column name, physical unit, and scale multiplier onto each of the
/// 5 canonical weather variables the phenology model consumes (T_max, T_min,
/// rain, radiation, RH). There is no generic/arbitrary-field mechanism: the
/// backend only ever ingests these 5 quantities.
class DeviceMapping {
  final String id;
  final String deviceName;
  final String manufacturer;
  final bool isPreset;

  final String dateCol;
  final String dateFormat;

  final String tMaxCol;
  final String tMaxUnit;
  final double tMaxScale;

  final String tMinCol;
  final String tMinUnit;
  final double tMinScale;

  final String rainCol;
  final String rainUnit;
  final double rainScale;

  final String radCol;
  final String radUnit;
  final double radScale;

  final String rhCol;
  final String rhUnit;
  final double rhScale;

  final DateTime createdAt;

  const DeviceMapping({
    required this.id,
    required this.deviceName,
    required this.manufacturer,
    required this.isPreset,
    required this.dateCol,
    required this.dateFormat,
    required this.tMaxCol,
    required this.tMaxUnit,
    required this.tMaxScale,
    required this.tMinCol,
    required this.tMinUnit,
    required this.tMinScale,
    required this.rainCol,
    required this.rainUnit,
    required this.rainScale,
    required this.radCol,
    required this.radUnit,
    required this.radScale,
    required this.rhCol,
    required this.rhUnit,
    required this.rhScale,
    required this.createdAt,
  });

  /// Blank slate for the "Outro / Custom" option: every column name starts
  /// empty so the farmer/technician fills in exactly what their own sensor
  /// sends, instead of guessing from a manufacturer preset.
  factory DeviceMapping.blank(String id) {
    return DeviceMapping(
      id: id,
      deviceName: '',
      manufacturer: 'Custom',
      isPreset: false,
      dateCol: '',
      dateFormat: 'yyyy-MM-dd',
      tMaxCol: '',
      tMaxUnit: 'C',
      tMaxScale: 1.0,
      tMinCol: '',
      tMinUnit: 'C',
      tMinScale: 1.0,
      rainCol: '',
      rainUnit: 'mm',
      rainScale: 1.0,
      radCol: '',
      radUnit: 'MJ/m2',
      radScale: 1.0,
      rhCol: '',
      rhUnit: '%',
      rhScale: 1.0,
      createdAt: DateTime.now(),
    );
  }

  factory DeviceMapping.fromJson(Map<String, dynamic> json) {
    return DeviceMapping(
      id: json['id'] as String? ?? '',
      deviceName: json['device_name'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      isPreset: json['is_preset'] as bool? ?? false,
      dateCol: json['date_col'] as String? ?? '',
      dateFormat: json['date_format'] as String? ?? 'yyyy-MM-dd',
      tMaxCol: json['t_max_col'] as String? ?? '',
      tMaxUnit: json['t_max_unit'] as String? ?? 'C',
      tMaxScale: (json['t_max_scale'] as num?)?.toDouble() ?? 1.0,
      tMinCol: json['t_min_col'] as String? ?? '',
      tMinUnit: json['t_min_unit'] as String? ?? 'C',
      tMinScale: (json['t_min_scale'] as num?)?.toDouble() ?? 1.0,
      rainCol: json['rain_col'] as String? ?? '',
      rainUnit: json['rain_unit'] as String? ?? 'mm',
      rainScale: (json['rain_scale'] as num?)?.toDouble() ?? 1.0,
      radCol: json['rad_col'] as String? ?? '',
      radUnit: json['rad_unit'] as String? ?? 'MJ/m2',
      radScale: (json['rad_scale'] as num?)?.toDouble() ?? 1.0,
      rhCol: json['rh_col'] as String? ?? '',
      rhUnit: json['rh_unit'] as String? ?? '%',
      rhScale: (json['rh_scale'] as num?)?.toDouble() ?? 1.0,
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
      't_max_col': tMaxCol,
      't_max_unit': tMaxUnit,
      't_max_scale': tMaxScale,
      't_min_col': tMinCol,
      't_min_unit': tMinUnit,
      't_min_scale': tMinScale,
      'rain_col': rainCol,
      'rain_unit': rainUnit,
      'rain_scale': rainScale,
      'rad_col': radCol,
      'rad_unit': radUnit,
      'rad_scale': radScale,
      'rh_col': rhCol,
      'rh_unit': rhUnit,
      'rh_scale': rhScale,
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
    String? tMaxCol,
    String? tMaxUnit,
    double? tMaxScale,
    String? tMinCol,
    String? tMinUnit,
    double? tMinScale,
    String? rainCol,
    String? rainUnit,
    double? rainScale,
    String? radCol,
    String? radUnit,
    double? radScale,
    String? rhCol,
    String? rhUnit,
    double? rhScale,
  }) {
    return DeviceMapping(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      manufacturer: manufacturer ?? this.manufacturer,
      isPreset: isPreset ?? this.isPreset,
      dateCol: dateCol ?? this.dateCol,
      dateFormat: dateFormat ?? this.dateFormat,
      tMaxCol: tMaxCol ?? this.tMaxCol,
      tMaxUnit: tMaxUnit ?? this.tMaxUnit,
      tMaxScale: tMaxScale ?? this.tMaxScale,
      tMinCol: tMinCol ?? this.tMinCol,
      tMinUnit: tMinUnit ?? this.tMinUnit,
      tMinScale: tMinScale ?? this.tMinScale,
      rainCol: rainCol ?? this.rainCol,
      rainUnit: rainUnit ?? this.rainUnit,
      rainScale: rainScale ?? this.rainScale,
      radCol: radCol ?? this.radCol,
      radUnit: radUnit ?? this.radUnit,
      radScale: radScale ?? this.radScale,
      rhCol: rhCol ?? this.rhCol,
      rhUnit: rhUnit ?? this.rhUnit,
      rhScale: rhScale ?? this.rhScale,
      createdAt: createdAt,
    );
  }
}
