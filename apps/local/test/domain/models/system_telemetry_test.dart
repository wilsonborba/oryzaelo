import 'package:flutter_test/flutter_test.dart';
import 'package:local/domain/models/system_telemetry.dart';

/// Regression tests for a real bug: the HUD's telemetry models expected JSON
/// keys the backend never sent (cpu_usage_pct, ram_total_mb, sqlite_wal_ok,
/// avg_latency_us...) and silently fell back to hardcoded, plausible-looking
/// fake numbers on every machine, regardless of what was actually running.
/// These models must now mirror the real backend response exactly, and must
/// leave a field null (never a fake default) when the backend didn't send it.
void main() {
  group('SystemHealth', () {
    test('parses the real /api/v1/health/system response shape', () {
      final sys = SystemHealth.fromJson({
        'status': 'healthy',
        'os': 'linux',
        'arch': 'x86_64',
        'cpu_cores': 24,
        'cpu_usage_pct': 6.93,
        'ram_total_mb': 15697,
        'ram_used_mb': 3626,
        'ram_usage_pct': 23.1,
        'disk_usage_pct': 44.03,
        'uptime_seconds': 120,
      });

      expect(sys.os, 'linux');
      expect(sys.arch, 'x86_64');
      expect(sys.cpuCores, 24);
      expect(sys.cpuUsagePct, 6.93);
      expect(sys.ramTotalMb, 15697);
      expect(sys.ramUsedMb, 3626);
      expect(sys.diskUsagePct, 44.03);
    });

    test('leaves fields null (not a fake number) when the backend omits them', () {
      final sys = SystemHealth.fromJson({'status': 'healthy'});

      expect(sys.cpuUsagePct, isNull);
      expect(sys.ramTotalMb, isNull);
      expect(sys.diskUsagePct, isNull);
      expect(sys.cpuCores, isNull);
    });
  });

  group('AppHealth', () {
    test('parses the real nested {sqlite, onnx_engine, cron_scheduler} shape', () {
      final app = AppHealth.fromJson({
        'status': 'healthy',
        'sqlite': {'status': 'connected', 'total_parcels': 4},
        'onnx_engine': {'status': 'loaded'},
        'cron_scheduler': {'status': 'active'},
      });

      expect(app.sqliteConnected, isTrue);
      expect(app.onnxLoaded, isTrue);
      expect(app.cronActive, isTrue);
    });

    test('parses the configured cron target_time, not a hardcoded "23:59"', () {
      final app = AppHealth.fromJson({
        'status': 'healthy',
        'cron_scheduler': {'status': 'active', 'target_time': '06:30'},
      });

      expect(app.cronTargetTime, '06:30');
    });

    test('reports a real disconnect, not a fake "always healthy" default', () {
      final app = AppHealth.fromJson({
        'status': 'degraded',
        'sqlite': {'status': 'disconnected'},
        'onnx_engine': {'status': 'loaded'},
        'cron_scheduler': {'status': 'active'},
      });

      expect(app.sqliteConnected, isFalse);
    });

    test('leaves subsystem flags null when the backend sends no data at all', () {
      final app = AppHealth.fromJson({'status': 'healthy'});

      expect(app.sqliteConnected, isNull);
      expect(app.onnxLoaded, isNull);
      expect(app.cronActive, isNull);
    });
  });

  group('BenchmarkLatency', () {
    test('parses the real LatencyBenchmarkResponse field names', () {
      final bench = BenchmarkLatency.fromJson({
        'mean_latency_us': 22.4,
        'min_latency_us': 20.1,
        'max_latency_us': 30.5,
        'p50_latency_us': 21.9,
        'p95_latency_us': 25.3,
        'p99_latency_us': 28.7,
        'target_ceiling_ms': 200.0,
        'speedup_vs_edge_ceiling': 8928.6,
      });

      expect(bench.meanLatencyUs, 22.4);
      expect(bench.p95Us, 25.3);
      expect(bench.targetCeilingMs, 200.0);
      expect(bench.speedupVsEdgeCeiling, 8928.6);
    });

    test('leaves everything null when the benchmark has not run, not a fake 21.3µs', () {
      final bench = BenchmarkLatency.fromJson({});

      expect(bench.meanLatencyUs, isNull);
      expect(bench.speedupVsEdgeCeiling, isNull);
    });
  });
}
