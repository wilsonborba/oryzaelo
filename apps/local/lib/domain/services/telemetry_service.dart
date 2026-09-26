import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/system_telemetry.dart';

/// Pure domain service for edge node health and latency benchmarks.
class TelemetryService {
  final EngineClient _client;

  TelemetryService({EngineClient? client}) : _client = client ?? EngineClient();

  Future<bool> ping() => _client.ping();

  Future<SystemHealth?> fetchSystemHealth() => _client.getSystemHealth();

  Future<AppHealth?> fetchAppHealth() => _client.getAppHealth();

  Future<BenchmarkLatency?> fetchLatencyBenchmark() => _client.getLatencyBenchmark();
}
