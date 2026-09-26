import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/device_mapping.dart';

/// Pure domain service for sensor presets and custom device configurations.
class DeviceService {
  final EngineClient _client;

  DeviceService({EngineClient? client}) : _client = client ?? EngineClient();

  Future<List<DeviceMapping>> fetchPresets() => _client.getDevicePresets();

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
