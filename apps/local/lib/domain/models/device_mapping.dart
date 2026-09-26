/// Sensor mapping and telemetry configuration domain model.
class DeviceMapping {
  final String id;
  final String name;
  final String manufacturer;
  final String model;
  final String description;
  final List<MappingEntry> mappings;

  const DeviceMapping({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.model,
    required this.description,
    required this.mappings,
  });

  factory DeviceMapping.fromJson(Map<String, dynamic> json) {
    return DeviceMapping(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      model: json['model'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mappings: (json['mappings'] as List<dynamic>?)
              ?.map((e) => MappingEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'model': model,
      'description': description,
      'mappings': mappings.map((e) => e.toJson()).toList(),
    };
  }
}

class MappingEntry {
  final String columnName;
  final String targetMetric;
  final String unit;
  final double scaleFactor;
  final double offset;

  const MappingEntry({
    required this.columnName,
    required this.targetMetric,
    required this.unit,
    this.scaleFactor = 1.0,
    this.offset = 0.0,
  });

  factory MappingEntry.fromJson(Map<String, dynamic> json) {
    return MappingEntry(
      columnName: json['column_name'] as String? ?? '',
      targetMetric: json['target_metric'] as String? ?? '',
      unit: json['unit'] as String? ?? 'Raw',
      scaleFactor: (json['scale_factor'] as num?)?.toDouble() ?? 1.0,
      offset: (json['offset'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'column_name': columnName,
      'target_metric': targetMetric,
      'unit': unit,
      'scale_factor': scaleFactor,
      'offset': offset,
    };
  }
}
