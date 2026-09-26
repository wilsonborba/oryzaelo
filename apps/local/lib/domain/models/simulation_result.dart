class SimulationResult {
  final String parcelId;
  final String cultivar;
  final double das;
  final double tMean;
  final double dailyGdd;
  final double accumulatedGdd;
  final double dtr;
  final String bbchCode;
  final String stageName;
  final double waterDepthCm;
  final String waterStatus;
  final String thermalRisk;
  final String advisory;
  final List<String> recommendations;

  const SimulationResult({
    required this.parcelId,
    required this.cultivar,
    required this.das,
    required this.tMean,
    required this.dailyGdd,
    required this.accumulatedGdd,
    required this.dtr,
    required this.bbchCode,
    required this.stageName,
    required this.waterDepthCm,
    required this.waterStatus,
    required this.thermalRisk,
    required this.advisory,
    required this.recommendations,
  });

  factory SimulationResult.fromJson(Map<String, dynamic> json) {
    return SimulationResult(
      parcelId: json['parcel_id'] as String? ?? '',
      cultivar: json['cultivar'] as String? ?? '',
      das: (json['das'] as num?)?.toDouble() ?? 0.0,
      tMean: (json['t_mean'] as num?)?.toDouble() ?? 0.0,
      dailyGdd: (json['daily_gdd'] as num?)?.toDouble() ?? 0.0,
      accumulatedGdd: (json['accumulated_gdd'] as num?)?.toDouble() ?? 0.0,
      dtr: (json['dtr'] as num?)?.toDouble() ?? 0.0,
      bbchCode: json['bbch_code'] as String? ?? 'BBCH 00',
      stageName: json['stage_name'] as String? ?? '',
      waterDepthCm: (json['water_depth_cm'] as num?)?.toDouble() ?? 0.0,
      waterStatus: json['water_status'] as String? ?? '',
      thermalRisk: json['thermal_risk'] as String? ?? '',
      advisory: json['advisory'] as String? ?? '',
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
