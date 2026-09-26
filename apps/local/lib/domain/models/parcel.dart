/// Farm parcel domain model representing a rice crop plot.
class FarmParcel {
  final String id;
  final String name;
  final double areaHectares;
  final double latitude;
  final double longitude;
  final String riceEcosystem;
  final String riceVariety;
  final DateTime sowingDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FarmParcel({
    required this.id,
    required this.name,
    required this.areaHectares,
    required this.latitude,
    required this.longitude,
    required this.riceEcosystem,
    required this.riceVariety,
    required this.sowingDate,
    this.createdAt,
    this.updatedAt,
  });

  /// Days After Emergence / Sowing
  int get daysAfterSowing {
    final now = DateTime.now();
    return now.difference(sowingDate).inDays.clamp(0, 365);
  }

  factory FarmParcel.fromJson(Map<String, dynamic> json) {
    return FarmParcel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Talhão Sem Nome',
      areaHectares: (json['area_hectares'] as num?)?.toDouble() ?? 1.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      riceEcosystem: json['rice_ecosystem'] as String? ?? 'Irrigated',
      riceVariety: json['rice_variety'] as String? ?? 'RD43',
      sowingDate: json['planting_date'] != null
          ? DateTime.tryParse(json['planting_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area_hectares': areaHectares,
      'latitude': latitude,
      'longitude': longitude,
      'rice_ecosystem': riceEcosystem,
      'rice_variety': riceVariety,
      'planting_date': sowingDate.toIso8601String().split('T').first,
    };
  }

  FarmParcel copyWith({
    String? id,
    String? name,
    double? areaHectares,
    double? latitude,
    double? longitude,
    String? riceEcosystem,
    String? riceVariety,
    DateTime? sowingDate,
  }) {
    return FarmParcel(
      id: id ?? this.id,
      name: name ?? this.name,
      areaHectares: areaHectares ?? this.areaHectares,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      riceEcosystem: riceEcosystem ?? this.riceEcosystem,
      riceVariety: riceVariety ?? this.riceVariety,
      sowingDate: sowingDate ?? this.sowingDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
