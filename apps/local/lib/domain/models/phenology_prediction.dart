/// Phenology prediction and advisory domain models.
class PhenologyPrediction {
  final DateTime evaluatedAt;
  final String parcelId;
  final String macroPhase;
  final String granularStage;
  final double confidence;
  final bool isTransitioning;
  final Map<String, double> probabilities;
  final FarmerAdvisory advisory;
  final Map<String, FarmerAdvisory> allTranslations;
  final TechnicalMetrics technicalMetrics;

  const PhenologyPrediction({
    required this.evaluatedAt,
    required this.parcelId,
    required this.macroPhase,
    required this.granularStage,
    required this.confidence,
    required this.isTransitioning,
    required this.probabilities,
    required this.advisory,
    required this.allTranslations,
    required this.technicalMetrics,
  });

  /// Resolves the advisory for any given locale string ('pt-BR', 'en', 'th')
  /// from local cached translations with zero internet calls.
  FarmerAdvisory getAdvisoryForLocale(String localeCode) {
    if (allTranslations.containsKey(localeCode)) {
      return allTranslations[localeCode]!;
    }
    // Fallback normalization
    if (localeCode.startsWith('pt') && allTranslations.containsKey('pt-BR')) {
      return allTranslations['pt-BR']!;
    }
    if (localeCode.startsWith('en') && allTranslations.containsKey('en')) {
      return allTranslations['en']!;
    }
    if (localeCode.startsWith('th') && allTranslations.containsKey('th')) {
      return allTranslations['th']!;
    }
    return advisory;
  }

  factory PhenologyPrediction.fromJson(Map<String, dynamic> json) {
    final probsRaw = json['probabilities'] as Map<String, dynamic>? ?? {};
    final probs = probsRaw.map(
      (k, v) => MapEntry(k, (v as num).toDouble()),
    );

    final transRaw = json['all_translations'] as Map<String, dynamic>? ?? {};
    final allTrans = transRaw.map(
      (k, v) => MapEntry(k, FarmerAdvisory.fromJson(v as Map<String, dynamic>)),
    );

    return PhenologyPrediction(
      evaluatedAt: json['evaluated_at'] != null
          ? DateTime.tryParse(json['evaluated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      parcelId: json['parcel_id'] as String? ?? '',
      macroPhase: json['macro_phase'] as String? ?? 'Vegetative',
      granularStage: json['granular_stage'] as String? ?? 'Tillering',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.85,
      isTransitioning: json['is_transitioning'] as bool? ?? false,
      probabilities: probs,
      advisory: FarmerAdvisory.fromJson(
          json['advisory'] as Map<String, dynamic>? ?? {}),
      allTranslations: allTrans,
      technicalMetrics: TechnicalMetrics.fromJson(
          json['technical_metrics'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class FarmerAdvisory {
  final String locale;
  final String stage;
  final String headline;
  final String plainText;
  final List<String> urgentWarnings;
  final List<String> managementTips;

  const FarmerAdvisory({
    required this.locale,
    required this.stage,
    required this.headline,
    required this.plainText,
    required this.urgentWarnings,
    required this.managementTips,
  });

  factory FarmerAdvisory.fromJson(Map<String, dynamic> json) {
    return FarmerAdvisory(
      locale: json['locale'] as String? ?? 'pt-BR',
      stage: json['stage'] as String? ?? '',
      headline: json['headline'] as String? ?? 'Recomendação Agronômica',
      plainText: json['plain_text'] as String? ?? '',
      urgentWarnings: (json['urgent_warnings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      managementTips: (json['management_tips'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class TechnicalMetrics {
  final String modelVersion;
  final double inferenceLatencyMs;
  final double entropy;
  final double margin;

  const TechnicalMetrics({
    required this.modelVersion,
    required this.inferenceLatencyMs,
    required this.entropy,
    required this.margin,
  });

  factory TechnicalMetrics.fromJson(Map<String, dynamic> json) {
    return TechnicalMetrics(
      modelVersion: json['model_version'] as String? ?? 'CatBoost-v1',
      inferenceLatencyMs:
          (json['inference_latency_ms'] as num?)?.toDouble() ?? 0.021,
      entropy: (json['entropy'] as num?)?.toDouble() ?? 0.12,
      margin: (json['margin'] as num?)?.toDouble() ?? 0.88,
    );
  }
}
