import 'package:local/dal/remote/engine_client.dart';

/// Domain service for edge node administration, mock data generation and resets.
class AdminService {
  final EngineClient _client;

  AdminService({EngineClient? client}) : _client = client ?? EngineClient();

  Future<bool> populateMockData({int? days, int? parcels}) =>
      _client.populateMockData(days: days, parcels: parcels);

  Future<bool> cleanMockData({bool resetPresets = false}) =>
      _client.cleanMockData(resetPresets: resetPresets);
}
