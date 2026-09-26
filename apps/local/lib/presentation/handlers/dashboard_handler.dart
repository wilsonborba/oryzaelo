import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:local/core/logs.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/metric_type.dart';
import 'package:local/domain/models/parcel.dart';
import 'package:local/domain/models/phenology_prediction.dart';
import 'package:local/domain/models/sensor_reading.dart';
import 'package:local/domain/models/simulation_result.dart';
import 'package:local/domain/models/system_telemetry.dart';
import 'package:local/domain/models/weather_analytics.dart';
import 'package:local/domain/models/weather_record.dart';
import 'package:local/domain/services/admin_service.dart';
import 'package:local/domain/services/device_service.dart';
import 'package:local/domain/services/parcel_service.dart';
import 'package:local/domain/services/phenology_service.dart';
import 'package:local/domain/services/telemetry_service.dart';
import 'package:local/domain/services/weather_service.dart';

/// How long a parcel's weather/analytics/prediction fetch stays valid before
/// [selectParcel] silently refetches it. The reload button (or a parcel
/// switch) always forces a fresh fetch regardless of this buffer.
const Duration _dataCacheTtl = Duration(minutes: 30);

/// Presentation state coordinator following Handler -> Service -> DAL architecture.
class DashboardHandler extends ChangeNotifier {
  final ParcelService _parcelService;
  final DeviceService _deviceService;
  final WeatherService _weatherService;
  final PhenologyService _phenologyService;
  final TelemetryService _telemetryService;
  final AdminService _adminService;

  DashboardHandler({
    ParcelService? parcelService,
    DeviceService? deviceService,
    WeatherService? weatherService,
    PhenologyService? phenologyService,
    TelemetryService? telemetryService,
    AdminService? adminService,
  })  : _parcelService = parcelService ?? ParcelService(),
        _deviceService = deviceService ?? DeviceService(),
        _weatherService = weatherService ?? WeatherService(),
        _phenologyService = phenologyService ?? PhenologyService(),
        _telemetryService = telemetryService ?? TelemetryService(),
        _adminService = adminService ?? AdminService();

  // State flags
  bool _isLoading = false;
  bool _isAnalyzing = false;
  bool _isEngineOnline = false;
  bool _isOperatingMock = false;
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
  String? _cachedParcelId;
  DateTime? _cachedAt;
  String? _cronTargetTime;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAnalyzing => _isAnalyzing;
  bool get isEngineOnline => _isEngineOnline;
  bool get isOperatingMock => _isOperatingMock;
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
  /// The nightly phenology-evaluation time ("HH:MM"), read live from the
  /// backend's config store; null until [initialize] loads it, never a
  /// client-side guess at what the backend defaults to.
  String? get cronTargetTime => _cronTargetTime;

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
      final configFuture = _adminService.fetchConfig();

      final results = await Future.wait([
        presetsFuture,
        customFuture,
        parcelsFuture,
        telemetryFuture,
        configFuture,
      ]);

      _devicePresets = results[0] as List<DeviceMapping>;
      _customMappings = results[1] as List<DeviceMapping>;
      _parcels = results[2] as List<FarmParcel>;
      _cronTargetTime = (results[4] as Map<String, String>)['cron_time'];

      // Auto-select first parcel or fallback
      if (_parcels.isNotEmpty) {
        await selectParcel(_parcels.first, notifyOnChange: false, force: true);
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
  ///
  /// Skips the network round-trip when the same parcel was already fetched
  /// within [_dataCacheTtl] (default 30 min), unless [force] is set (used by
  /// the header's manual reload button) or the parcel actually changed.
  Future<void> selectParcel(
    FarmParcel parcel, {
    bool notifyOnChange = true,
    bool force = false,
  }) async {
    final sameParcel = _selectedParcel?.id == parcel.id;
    _selectedParcel = parcel;

    final cacheFresh = sameParcel &&
        _cachedParcelId == parcel.id &&
        _cachedAt != null &&
        DateTime.now().difference(_cachedAt!) < _dataCacheTtl;

    if (!force && cacheFresh) {
      if (notifyOnChange) notifyListeners();
      return;
    }

    if (notifyOnChange) {
      _isLoading = true;
      notifyListeners();
    }

    // Cumulative charts (GDD accumulation) must cover the full growth cycle
    // since sowing, or the running total silently understates the season:
    // a fixed last-60-days window truncates the early season for any parcel
    // more than 60 days into its cycle (rice runs ~100-150 days), and the
    // cutoff worsens by one day every day the crop keeps growing.
    final windowDays = math.max(60, parcel.daysAfterSowing + 7);

    try {
      final predFuture = _phenologyService.fetchLatest(parcel.id);
      final weatherFuture = _weatherService.fetchRecords(parcel.id, days: windowDays);
      final analyticsFuture = _weatherService.fetchAnalytics(parcel.id, days: windowDays);

      final results = await Future.wait([predFuture, weatherFuture, analyticsFuture]);

      _latestPrediction = results[0] as PhenologyPrediction?;
      _weatherRecords = results[1] as List<DailyWeatherRecord>;
      _analyticsReport = results[2] as WeatherAnalyticsReport?;
      _cachedParcelId = parcel.id;
      _cachedAt = DateTime.now();
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

  /// One sensor's own raw reading history for the selected parcel -- full
  /// audit trail, independent of any other sensor's data.
  Future<List<SensorReading>> fetchSensorReadings(MetricType metricType) {
    if (_selectedParcel == null) return Future.value([]);
    return _deviceService.fetchSensorReadings(parcelId: _selectedParcel!.id, metricType: metricType);
  }

  /// Deletes one raw reading, then refreshes the current parcel's data so
  /// the day's aggregate (and any chart/table showing it) reflects whatever
  /// the day now recomputes to.
  Future<bool> deleteSensorReading({required int id, required MetricType metricType}) async {
    final ok = await _deviceService.deleteSensorReading(id: id, metricType: metricType);
    if (ok && _selectedParcel != null) {
      await selectParcel(_selectedParcel!, notifyOnChange: false, force: true);
      notifyListeners();
    }
    return ok;
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
        await selectParcel(_selectedParcel!, notifyOnChange: false, force: true);
      }
      return report;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> ingestSingleRecord(ManualWeatherEntry entry) async {
    if (_selectedParcel == null) return false;
    _isLoading = true;
    notifyListeners();

    final ok = await _weatherService.ingestSingleRecord(
      parcelId: _selectedParcel!.id,
      entry: entry,
    );

    if (ok) {
      await selectParcel(_selectedParcel!, notifyOnChange: false, force: true);
    }
    _isLoading = false;
    notifyListeners();
    return ok;
  }

  // ── Mock & Demo Data Administration ──────────────────────────────────────

  Future<bool> populateMockData({int? days, int? parcels}) async {
    _isLoading = true;
    _isOperatingMock = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ok = await _adminService.populateMockData(days: days, parcels: parcels);
      if (ok) {
        await initialize();
        return true;
      } else {
        _errorMessage = 'Falha ao popular dados sintéticos de teste no nó de borda.';
        return false;
      }
    } catch (e) {
      logError('Populate mock data error: $e');
      _errorMessage = 'Erro ao popular dados de teste: $e';
      return false;
    } finally {
      _isLoading = false;
      _isOperatingMock = false;
      notifyListeners();
    }
  }

  Future<bool> cleanMockData({bool resetPresets = false}) async {
    _isLoading = true;
    _isOperatingMock = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ok = await _adminService.cleanMockData(resetPresets: resetPresets);
      if (ok) {
        _selectedParcel = null;
        _latestPrediction = null;
        _weatherRecords = [];
        _analyticsReport = null;
        await initialize();
        return true;
      } else {
        _errorMessage = 'Falha ao limpar base de dados no nó de borda.';
        return false;
      }
    } catch (e) {
      logError('Clean mock data error: $e');
      _errorMessage = 'Erro ao limpar base de dados: $e';
      return false;
    } finally {
      _isLoading = false;
      _isOperatingMock = false;
      notifyListeners();
    }
  }

  // ── Edge Node Configuration ──────────────────────────────────────────────

  /// Updates the nightly cron evaluation time. Returns false (config left
  /// unchanged, [cronTargetTime] untouched) if the backend rejects the value
  /// — e.g. malformed "HH:MM" — never optimistically applying it locally.
  ///
  /// Also refreshes telemetry so the Edge Node Subsystems HUD (which reads
  /// [appHealth].cronTargetTime, a separate field populated by that fetch)
  /// reflects the new time immediately, not just [cronTargetTime] itself.
  Future<bool> updateCronTargetTime(String hhMm) async {
    final ok = await _adminService.updateConfig({'cron_time': hhMm});
    if (ok) {
      _cronTargetTime = hhMm;
      await refreshTelemetry(notify: false);
      notifyListeners();
    }
    return ok;
  }

  // ── Record Batch Deletion ────────────────────────────────────────────────

  Future<bool> deleteRecords(List<DateTime> dates) async {
    if (_selectedParcel == null || dates.isEmpty) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final count = await _weatherService.deleteRecords(_selectedParcel!.id, dates);
      if (count > 0) {
        final dateSet = dates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
        _weatherRecords.removeWhere((r) => dateSet.contains(DateTime(r.date.year, r.date.month, r.date.day)));
        // Refresh analytics in background
        _analyticsReport = await _weatherService.fetchAnalytics(_selectedParcel!.id);
        return true;
      }
      return false;
    } catch (e) {
      logError('Delete records error: $e');
      _errorMessage = 'Erro ao excluir registros: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Scenario Simulation ──────────────────────────────────────────────────

  Future<SimulationResult?> runSimulation({
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
    if (_selectedParcel == null) return null;
    _isAnalyzing = true;
    notifyListeners();

    try {
      final res = await _phenologyService.simulate(
        parcelId: _selectedParcel!.id,
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
      return res;
    } catch (e) {
      logError('Run simulation error: $e');
      return null;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }
}

