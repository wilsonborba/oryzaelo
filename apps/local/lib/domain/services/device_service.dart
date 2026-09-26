import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/metric_type.dart';
import 'package:local/domain/models/sensor_reading.dart';

/// Pure domain service for sensor presets and custom device configurations.
class DeviceService {
  final EngineClient _client;

  DeviceService({EngineClient? client}) : _client = client ?? EngineClient();

  Future<List<DeviceMapping>> fetchPresets() => _client.getDevicePresets();

  /// A sensor's own raw reading history for one metric -- full provenance,
  /// independent of what any other sensor reported.
  Future<List<SensorReading>> fetchSensorReadings({
    required String parcelId,
    required MetricType metricType,
  }) =>
      _client.listSensorReadings(parcelId: parcelId, metricType: metricType);

  Future<bool> deleteSensorReading({required int id, required MetricType metricType}) =>
      _client.deleteSensorReading(id: id, metricType: metricType);

  /// The backend's `/devices/mappings` endpoint returns ALL mappings
  /// (presets + custom, `is_preset` unfiltered) — filter client-side so
  /// presets aren't duplicated alongside [fetchPresets] in the UI.
  Future<List<DeviceMapping>> fetchCustomMappings() async {
    final all = await _client.getDeviceMappings();
    return all.where((m) => !m.isPreset).toList();
  }

  Future<DeviceMapping?> saveCustomMapping(DeviceMapping mapping) =>
      _client.createDeviceMapping(mapping);

  Future<bool> deleteCustomMapping(String id) => _client.deleteDeviceMapping(id);
}
