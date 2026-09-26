import 'package:flutter/material.dart';
import 'package:local/core/logs.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/parcel.dart';
import 'package:local/domain/models/phenology_prediction.dart';
import 'package:local/domain/models/system_telemetry.dart';
import 'package:local/domain/models/weather_analytics.dart';
import 'package:local/domain/models/weather_record.dart';
import 'package:local/domain/services/device_service.dart';
import 'package:local/domain/services/parcel_service.dart';
import 'package:local/domain/services/phenology_service.dart';
import 'package:local/domain/services/telemetry_service.dart';
import 'package:local/domain/services/weather_service.dart';

/// Presentation state coordinator following Handler -> Service -> DAL architecture.
class DashboardHandler extends ChangeNotifier {
  final ParcelService _parcelService;
  final DeviceService _deviceService;
  final WeatherService _weatherService;
  final PhenologyService _phenologyService;
  final TelemetryService _telemetryService;

  DashboardHandler({
    ParcelService? parcelService,
    DeviceService? deviceService,
    WeatherService? weatherService,
    PhenologyService? phenologyService,
    TelemetryService? telemetryService,
  })  : _parcelService = parcelService ?? ParcelService(),
        _deviceService = deviceService ?? DeviceService(),
        _weatherService = weatherService ?? WeatherService(),
        _phenologyService = phenologyService ?? PhenologyService(),
        _telemetryService = telemetryService ?? TelemetryService();

  // State flags
  bool _isLoading = false;
  bool _isAnalyzing = false;
  bool _isEngineOnline = false;
  String? _errorMessage;

  // Data state
  List<FarmParcel> _parcels = [];
  FarmParcel? _selectedParcel;
  PhenologyPrediction? _latestPrediction;
  List<DailyWeatherRecord> _weatherRecords = [];
  WeatherAnalyticsReport? _analyticsReport;
  List<DeviceMapping> _devicePresets = [];
  List<DeviceMapping> _customMappings = [];
  SystemHealth? _systemHealth;
  AppHealth? _appHealth;
  BenchmarkLatency? _benchmarkLatency;
  IngestionReport? _lastIngestionReport;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAnalyzing => _isAnalyzing;
  bool get isEngineOnline => _isEngineOnline;
  String? get errorMessage => _errorMessage;

  List<FarmParcel> get parcels => _parcels;
  FarmParcel? get selectedParcel => _selectedParcel;
  PhenologyPrediction? get latestPrediction => _latestPrediction;
  List<DailyWeatherRecord> get weatherRecords => _weatherRecords;
  WeatherAnalyticsReport? get analyticsReport => _analyticsReport;
  List<DeviceMapping> get devicePresets => _devicePresets;
  List<DeviceMapping> get customMappings => _customMappings;
  SystemHealth? get systemHealth => _systemHealth;
  AppHealth? get appHealth => _appHealth;
  BenchmarkLatency? get benchmarkLatency => _benchmarkLatency;
  IngestionReport? get lastIngestionReport => _lastIngestionReport;

  List<DeviceMapping> get allDeviceMappings => [..._devicePresets, ..._customMappings];

  /// Initial load of edge telemetry, parcels and presets.
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Verify engine connectivity
      _isEngineOnline = await _telemetryService.ping();

      // 2. Load device presets & custom mappings
      final presetsFuture = _deviceService.fetchPresets();
      final customFuture = _deviceService.fetchCustomMappings();
      final parcelsFuture = _parcelService.fetchParcels();
      final telemetryFuture = refreshTelemetry(notify: false);

      final results = await Future.wait([
        presetsFuture,
        customFuture,
        parcelsFuture,
        telemetryFuture,
      ]);

      _devicePresets = results[0] as List<DeviceMapping>;
      _customMappings = results[1] as List<DeviceMapping>;
      _parcels = results[2] as List<FarmParcel>;

      // Auto-select first parcel or fallback
      if (_parcels.isNotEmpty) {
        await selectParcel(_parcels.first, notifyOnChange: false);
      }
    } catch (e) {
      logError('Initialization error: $e');
      _errorMessage = 'Falha ao inicializar o nó de borda: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Selects active parcel and refreshes its agronomic data.
  Future<void> selectParcel(FarmParcel parcel, {bool notifyOnChange = true}) async {
    _selectedParcel = parcel;
    if (notifyOnChange) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final predFuture = _phenologyService.fetchLatest(parcel.id);
      final weatherFuture = _weatherService.fetchRecords(parcel.id, days: 60);
      final analyticsFuture = _weatherService.fetchAnalytics(parcel.id, days: 60);

      final results = await Future.wait([predFuture, weatherFuture, analyticsFuture]);

      _latestPrediction = results[0] as PhenologyPrediction?;
      _weatherRecords = results[1] as List<DailyWeatherRecord>;
      _analyticsReport = results[2] as WeatherAnalyticsReport?;
    } catch (e) {
      logError('Error fetching parcel telemetry: $e');
    } finally {
      if (notifyOnChange) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Triggers on-demand CatBoost inference on the Rust edge engine.
  Future<void> runPrediction([String? locale]) async {
    if (_selectedParcel == null) return;
    _isAnalyzing = true;
    notifyListeners();

    try {
      final pred = await _phenologyService.predict(_selectedParcel!.id, locale: locale);
      if (pred != null) {
        _latestPrediction = pred;
      }
    } catch (e) {
      logError('Prediction error: $e');
      _errorMessage = 'Erro ao executar inferência de borda: $e';
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  /// Refreshes telemetry and real-time hardware benchmarks.
  Future<void> refreshTelemetry({bool notify = true}) async {
    try {
      _isEngineOnline = await _telemetryService.ping();
      final healthFuture = _telemetryService.fetchSystemHealth();
      final appHealthFuture = _telemetryService.fetchAppHealth();
      final benchFuture = _telemetryService.fetchLatencyBenchmark();

      final results = await Future.wait([healthFuture, appHealthFuture, benchFuture]);
      _systemHealth = results[0] as SystemHealth?;
      _appHealth = results[1] as AppHealth?;
      _benchmarkLatency = results[2] as BenchmarkLatency?;
    } catch (e) {
      logWarn('Telemetry refresh warning: $e');
    } finally {
      if (notify) notifyListeners();
    }
  }

  // ── Parcels CRUD ─────────────────────────────────────────────────────────

  Future<bool> createParcel({
    required String name,
    required double areaHectares,
    required double latitude,
    required double longitude,
    required String riceEcosystem,
    required String riceVariety,
    required DateTime sowingDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    final created = await _parcelService.createParcel(
      name: name,
      areaHectares: areaHectares,
      latitude: latitude,
      longitude: longitude,
      riceEcosystem: riceEcosystem,
      riceVariety: riceVariety,
      sowingDate: sowingDate,
    );

    _isLoading = false;
    if (created != null) {
      _parcels = await _parcelService.fetchParcels();
      await selectParcel(created);
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> updateParcel(FarmParcel parcel) async {
    final updated = await _parcelService.updateParcel(parcel);
    if (updated != null) {
      _parcels = await _parcelService.fetchParcels();
      if (_selectedParcel?.id == updated.id) {
        _selectedParcel = updated;
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteParcel(String id) async {
    final ok = await _parcelService.deleteParcel(id);
    if (ok) {
      _parcels = await _parcelService.fetchParcels();
      if (_selectedParcel?.id == id) {
        if (_parcels.isNotEmpty) {
          await selectParcel(_parcels.first);
        } else {
          _selectedParcel = null;
          _latestPrediction = null;
          _weatherRecords = [];
          _analyticsReport = null;
        }
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  // ── Device & Sensor Mapping CRUD ─────────────────────────────────────────

  Future<bool> saveCustomMapping(DeviceMapping mapping) async {
    final saved = await _deviceService.saveCustomMapping(mapping);
    if (saved != null) {
      _customMappings = await _deviceService.fetchCustomMappings();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteCustomMapping(String id) async {
    final ok = await _deviceService.deleteCustomMapping(id);
    if (ok) {
      _customMappings = await _deviceService.fetchCustomMappings();
      notifyListeners();
      return true;
    }
    return false;
  }

  // ── Weather Ingestion (CSV & Single Record) ───────────────────────────────

  Future<IngestionReport?> uploadCsv({
    required String deviceId,
    required String csvContent,
  }) async {
    if (_selectedParcel == null) return null;
    _isLoading = true;
    notifyListeners();

    try {
      final report = await _weatherService.ingestCsv(
        parcelId: _selectedParcel!.id,
        deviceId: deviceId,
        csvContent: csvContent,
      );

      _lastIngestionReport = report;

      // Refresh weather records and analytics after ingestion
      if (report != null && report.successfulRows > 0) {
        await selectParcel(_selectedParcel!, notifyOnChange: false);
      }
      return report;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> ingestSingleRecord(DailyWeatherRecord record) async {
    if (_selectedParcel == null) return false;
    _isLoading = true;
    notifyListeners();

    final ok = await _weatherService.ingestSingleRecord(
      parcelId: _selectedParcel!.id,
      record: record,
    );

    if (ok) {
      await selectParcel(_selectedParcel!, notifyOnChange: false);
    }
    _isLoading = false;
    notifyListeners();
    return ok;
  }
}
