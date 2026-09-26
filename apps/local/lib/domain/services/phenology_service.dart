import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/phenology_prediction.dart';
import 'package:local/domain/models/simulation_result.dart';

/// Pure domain service for phenological stage inference and advisories.
class PhenologyService {
  final EngineClient _client;

  PhenologyService({EngineClient? client}) : _client = client ?? EngineClient();

  Future<PhenologyPrediction?> predict(String parcelId, {String? locale}) =>
      _client.predictPhenology(parcelId, locale: locale);

  Future<PhenologyPrediction?> fetchLatest(String parcelId, {String? locale}) =>
      _client.getLatestPhenology(parcelId, locale: locale);

  Future<List<PhenologyPrediction>> fetchHistory(String parcelId, {int limit = 30}) =>
      _client.getPhenologyHistory(parcelId, limit: limit);

  Future<SimulationResult?> simulate({
    required String parcelId,
    String? cultivar,
    required double das,
    required double tMin,
    required double tMax,
    required double waterDepthCm,
    double? relativeHumidityPct,
    double? precipitationMm,
    double? radiationMjM2,
    String? locale,
  }) =>
      _client.simulateScenario(
        parcelId: parcelId,
        cultivar: cultivar,
        das: das,
        tMin: tMin,
        tMax: tMax,
        waterDepthCm: waterDepthCm,
        relativeHumidityPct: relativeHumidityPct,
        precipitationMm: precipitationMm,
        radiationMjM2: radiationMjM2,
        locale: locale,
      );
}

