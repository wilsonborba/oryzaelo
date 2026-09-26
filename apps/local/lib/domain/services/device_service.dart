import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/device_mapping.dart';

/// Pure domain service for sensor presets and custom device configurations.
class DeviceService {
  final EngineClient _client;

  DeviceService({EngineClient? client}) : _client = client ?? EngineClient();

  Future<List<DeviceMapping>> fetchPresets() => _client.getDevicePresets();

  Future<List<DeviceMapping>> fetchCustomMappings() => _client.getDeviceMappings();

  Future<DeviceMapping?> saveCustomMapping(DeviceMapping mapping) =>
      _client.createDeviceMapping(mapping);

  Future<bool> deleteCustomMapping(String id) => _client.deleteDeviceMapping(id);
}
