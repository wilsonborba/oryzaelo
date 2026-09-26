import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/weather_analytics.dart';
import 'package:local/domain/models/weather_record.dart';

/// Pure domain service for weather ingestion and agrometeorological time series.
class WeatherService {
  final EngineClient _client;

  WeatherService({EngineClient? client}) : _client = client ?? EngineClient();

  Future<IngestionReport?> ingestCsv({
    required String parcelId,
    required String deviceId,
    required String csvContent,
  }) =>
      _client.uploadCsv(
        parcelId: parcelId,
        deviceId: deviceId,
        csvContent: csvContent,
      );

  Future<bool> ingestSingleRecord({
    required String parcelId,
    required ManualWeatherEntry entry,
  }) =>
      _client.ingestSingleRecord(
        parcelId: parcelId,
        entry: entry,
      );

  Future<List<DailyWeatherRecord>> fetchRecords(
    String parcelId, {
    int days = 60,
  }) =>
      _client.getWeatherRecords(parcelId, days: days);

  Future<WeatherAnalyticsReport?> fetchAnalytics(
    String parcelId, {
    int days = 60,
  }) =>
      _client.getWeatherAnalytics(parcelId, days: days);

  Future<int> deleteRecords(
    String parcelId,
    List<DateTime> dates,
  ) =>
      _client.deleteWeatherRecords(parcelId, dates);
}

