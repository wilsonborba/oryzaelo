import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:local/core/logs.dart';
import 'package:local/core/settings.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/parcel.dart';
import 'package:local/domain/models/phenology_prediction.dart';
import 'package:local/domain/models/simulation_result.dart';
import 'package:local/domain/models/system_telemetry.dart';
import 'package:local/domain/models/weather_analytics.dart';
import 'package:local/domain/models/weather_record.dart';

/// HTTP Client for communicating with the Oryzaelo-Engine edge microservice.
class EngineClient {
  final String baseUrl;
  final http.Client _client;

  EngineClient({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? AppSettings.activeBaseUrl,
        _client = client ?? http.Client();

  Uri _uri(String path, [Map<String, String>? query]) {
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$cleanBase$cleanPath').replace(queryParameters: query);
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ── Health & Telemetry ──────────────────────────────────────────────────

  Future<bool> ping() async {
    try {
      final res = await _client.get(_uri('/health')).timeout(AppSettings.connectTimeout);
      return res.statusCode == 200;
    } catch (e) {
      logWarn('Ping failed: $e');
      return false;
    }
  }

  Future<SystemHealth?> getSystemHealth() async {
    try {
      final res = await _client.get(_uri('/api/v1/health/system')).timeout(AppSettings.connectTimeout);
      if (res.statusCode == 200) {
        return SystemHealth.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logWarn('Failed to fetch system health: $e');
    }
    return null;
  }

  Future<AppHealth?> getAppHealth() async {
    try {
      final res = await _client.get(_uri('/api/v1/health/app')).timeout(AppSettings.connectTimeout);
      if (res.statusCode == 200) {
        return AppHealth.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logWarn('Failed to fetch app health: $e');
    }
    return null;
  }

  Future<BenchmarkLatency?> getLatencyBenchmark() async {
    try {
      final res = await _client.get(_uri('/api/v1/benchmarks/latency')).timeout(AppSettings.connectTimeout);
      if (res.statusCode == 200) {
        return BenchmarkLatency.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logWarn('Failed to run latency benchmark: $e');
    }
    return null;
  }

  // ── Parcels (CRUD) ───────────────────────────────────────────────────────

  Future<List<FarmParcel>> getParcels() async {
    try {
      final res = await _client.get(_uri('/api/v1/parcels')).timeout(AppSettings.receiveTimeout);
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        return list.map((e) => FarmParcel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      logError('Failed to fetch parcels: $e');
    }
    return [];
  }

  Future<FarmParcel?> createParcel(FarmParcel parcel) async {
    try {
      final res = await _client
          .post(
            _uri('/api/v1/parcels'),
            headers: _headers,
            body: jsonEncode(parcel.toJson()),
          )
          .timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 201 || res.statusCode == 200) {
        return FarmParcel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logError('Failed to create parcel: $e');
    }
    return null;
  }

  Future<FarmParcel?> updateParcel(FarmParcel parcel) async {
    try {
      final res = await _client
          .put(
            _uri('/api/v1/parcels/${parcel.id}'),
            headers: _headers,
            body: jsonEncode(parcel.toJson()),
          )
          .timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 200) {
        return FarmParcel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logError('Failed to update parcel: $e');
    }
    return null;
  }

  Future<bool> deleteParcel(String id) async {
    try {
      final res = await _client.delete(_uri('/api/v1/parcels/$id')).timeout(AppSettings.receiveTimeout);
      return res.statusCode == 200 || res.statusCode == 204;
    } catch (e) {
      logError('Failed to delete parcel: $e');
      return false;
    }
  }

  // ── Device Presets & Sensor Mappings (CRUD) ──────────────────────────────

  Future<List<DeviceMapping>> getDevicePresets() async {
    try {
      final res = await _client.get(_uri('/api/v1/devices/presets')).timeout(AppSettings.receiveTimeout);
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        return list.map((e) => DeviceMapping.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      logWarn('Failed to fetch device presets: $e');
    }
    return [];
  }

  Future<List<DeviceMapping>> getDeviceMappings() async {
    try {
      final res = await _client.get(_uri('/api/v1/devices/mappings')).timeout(AppSettings.receiveTimeout);
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        return list.map((e) => DeviceMapping.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      logWarn('Failed to fetch device mappings: $e');
    }
    return [];
  }

  Future<DeviceMapping?> createDeviceMapping(DeviceMapping mapping) async {
    try {
      final res = await _client
          .post(
            _uri('/api/v1/devices/mappings'),
            headers: _headers,
            body: jsonEncode(mapping.toJson()),
          )
          .timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 201 || res.statusCode == 200) {
        return DeviceMapping.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logError('Failed to save device mapping: $e');
    }
    return null;
  }

  Future<bool> deleteDeviceMapping(String id) async {
    try {
      final res = await _client.delete(_uri('/api/v1/devices/mappings/$id')).timeout(AppSettings.receiveTimeout);
      return res.statusCode == 200 || res.statusCode == 204;
    } catch (e) {
      logError('Failed to delete device mapping: $e');
      return false;
    }
  }

  // ── Weather Ingestion (CSV & Single Record) ───────────────────────────────

  Future<IngestionReport?> uploadCsv({
    required String parcelId,
    required String deviceId,
    required String csvContent,
  }) async {
    try {
      final res = await _client
          .post(
            _uri('/api/v1/weather/ingest'),
            headers: _headers,
            body: jsonEncode({
              'parcel_id': parcelId,
              'device_id': deviceId,
              'csv_content': csvContent,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        return IngestionReport.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      } else {
        logWarn('CSV ingest response: ${res.statusCode} - ${res.body}');
      }
    } catch (e) {
      logError('Failed to upload CSV: $e');
    }
    return null;
  }

  Future<bool> ingestSingleRecord({
    required String parcelId,
    required DailyWeatherRecord record,
  }) async {
    try {
      final payload = record.toJson();
      payload['parcel_id'] = parcelId;

      final res = await _client
          .post(
            _uri('/api/v1/weather/record'),
            headers: _headers,
            body: jsonEncode(payload),
          )
          .timeout(AppSettings.receiveTimeout);

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      logError('Failed to ingest single record: $e');
      return false;
    }
  }

  Future<List<DailyWeatherRecord>> getWeatherRecords(
    String parcelId, {
    int days = 60,
  }) async {
    try {
      final res = await _client
          .get(_uri('/api/v1/weather/records', {
            'parcel_id': parcelId,
            'days': days.toString(),
          }))
          .timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        return list.map((e) => DailyWeatherRecord.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      logError('Failed to fetch weather records: $e');
    }
    return [];
  }

  Future<int> deleteWeatherRecords(
    String parcelId,
    List<DateTime> dates,
  ) async {
    try {
      final dateStrings = dates.map((d) {
        final year = d.year.toString().padLeft(4, '0');
        final month = d.month.toString().padLeft(2, '0');
        final day = d.day.toString().padLeft(2, '0');
        return '$year-$month-$day';
      }).toList();

      final res = await _client
          .delete(
            _uri('/api/v1/weather/records'),
            headers: _headers,
            body: jsonEncode({
              'parcel_id': parcelId,
              'dates': dateStrings,
            }),
          )
          .timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        return (body['deleted_count'] as num?)?.toInt() ?? 0;
      }
    } catch (e) {
      logError('Failed to delete weather records: $e');
    }
    return 0;
  }

  // ── Agrometeorological Analytics & Correlation ───────────────────────────

  Future<WeatherAnalyticsReport?> getWeatherAnalytics(
    String parcelId, {
    int days = 60,
  }) async {
    try {
      final res = await _client
          .get(_uri('/api/v1/weather/analytics', {
            'parcel_id': parcelId,
            'days': days.toString(),
          }))
          .timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 200) {
        return WeatherAnalyticsReport.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logWarn('Failed to fetch weather analytics: $e');
    }
    return null;
  }

  // ── Phenology Prediction & Advisories ────────────────────────────────────

  Future<PhenologyPrediction?> predictPhenology(
    String parcelId, {
    String? locale,
  }) async {
    try {
      final payload = <String, dynamic>{
        'parcel_id': parcelId,
      };
      if (locale != null) payload['locale'] = locale;

      final res = await _client
          .post(
            _uri('/api/v1/phenology/predict'),
            headers: _headers,
            body: jsonEncode(payload),
          )
          .timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 200) {
        return PhenologyPrediction.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logError('Failed to predict phenology: $e');
    }
    return null;
  }

  Future<PhenologyPrediction?> getLatestPhenology(
    String parcelId, {
    String? locale,
  }) async {
    try {
      final query = <String, String>{'parcel_id': parcelId};
      if (locale != null) query['locale'] = locale;

      final res = await _client.get(_uri('/api/v1/phenology/latest', query)).timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 200) {
        return PhenologyPrediction.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logWarn('No existing prediction found for parcel $parcelId: $e');
    }
    return null;
  }

  Future<List<PhenologyPrediction>> getPhenologyHistory(
    String parcelId, {
    int limit = 30,
  }) async {
    try {
      final res = await _client
          .get(_uri('/api/v1/phenology/history', {
            'parcel_id': parcelId,
            'limit': limit.toString(),
          }))
          .timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        return list.map((e) => PhenologyPrediction.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      logWarn('Failed to fetch phenology history: $e');
    }
    return [];
  }

  Future<SimulationResult?> simulateScenario({
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
  }) async {
    try {
      final payload = <String, dynamic>{
        'parcel_id': parcelId,
        'das': das,
        't_min': tMin,
        't_max': tMax,
        'water_depth_cm': waterDepthCm,
      };
      if (cultivar != null) payload['cultivar'] = cultivar;
      if (relativeHumidityPct != null) payload['relative_humidity_pct'] = relativeHumidityPct;
      if (precipitationMm != null) payload['precipitation_mm'] = precipitationMm;
      if (radiationMjM2 != null) payload['radiation_mj_m2'] = radiationMjM2;
      if (locale != null) payload['locale'] = locale;

      final res = await _client
          .post(
            _uri('/api/v1/phenology/simulate'),
            headers: _headers,
            body: jsonEncode(payload),
          )
          .timeout(AppSettings.receiveTimeout);

      if (res.statusCode == 200) {
        return SimulationResult.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
    } catch (e) {
      logError('Failed to execute simulation: $e');
    }
    return null;
  }


  // ── Admin & Mock Data (Turnkey Testing) ──────────────────────────────────

  Future<bool> populateMockData({int? days, int? parcels}) async {
    try {
      final query = <String, String>{};
      if (days != null) query['days'] = days.toString();
      if (parcels != null) query['parcels'] = parcels.toString();

      final res = await _client
          .post(_uri('/api/v1/admin/populate', query.isEmpty ? null : query), headers: _headers)
          .timeout(const Duration(seconds: 30));

      return res.statusCode == 200;
    } catch (e) {
      logError('Failed to populate mock data: $e');
      return false;
    }
  }

  Future<bool> cleanMockData({bool resetPresets = false}) async {
    try {
      final query = <String, String>{};
      if (resetPresets) query['reset_presets'] = 'true';

      final res = await _client
          .post(_uri('/api/v1/admin/clean', query.isEmpty ? null : query), headers: _headers)
          .timeout(const Duration(seconds: 30));

      return res.statusCode == 200;
    } catch (e) {
      logError('Failed to clean mock data: $e');
      return false;
    }
  }
}
