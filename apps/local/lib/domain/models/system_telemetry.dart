/// System health and real-time edge hardware benchmarks.
///
/// Every field mirrors the backend's `/api/v1/health/system` response
/// exactly and is measured live on whatever host the engine is actually
/// running on (a Raspberry Pi in the field, a developer's laptop, a CI
/// runner) — there is no fixed/demo hardware profile behind these numbers.
/// A field is left null, never given a plausible-looking fake number, when
/// the backend genuinely can't report it (e.g. no disks detected).
class SystemHealth {
  final String status;
  final String? os;
  final String? arch;
  final int? cpuCores;
  final double? cpuUsagePct;
  final double? ramUsagePct;
  final int? ramTotalMb;
  final int? ramUsedMb;
  final double? diskUsagePct;
  final int? uptimeSeconds;

  const SystemHealth({
    required this.status,
    this.os,
    this.arch,
    this.cpuCores,
    this.cpuUsagePct,
    this.ramUsagePct,
    this.ramTotalMb,
    this.ramUsedMb,
    this.diskUsagePct,
    this.uptimeSeconds,
  });

  factory SystemHealth.fromJson(Map<String, dynamic> json) {
    return SystemHealth(
      status: json['status'] as String? ?? 'unknown',
      os: json['os'] as String?,
      arch: json['arch'] as String?,
      cpuCores: json['cpu_cores'] as int?,
      cpuUsagePct: (json['cpu_usage_pct'] as num?)?.toDouble(),
      ramUsagePct: (json['ram_usage_pct'] as num?)?.toDouble(),
      ramTotalMb: json['ram_total_mb'] as int?,
      ramUsedMb: json['ram_used_mb'] as int?,
      diskUsagePct: (json['disk_usage_pct'] as num?)?.toDouble(),
      uptimeSeconds: json['uptime_seconds'] as int?,
    );
  }
}

/// Application internal subsystems health probe. The backend nests each
/// subsystem under its own key (`sqlite`, `onnx_engine`, `cron_scheduler`),
/// each carrying its own `status` string — parsed here rather than assumed.
class AppHealth {
  final String status;
  final bool? sqliteConnected;
  final bool? onnxLoaded;
  final bool? cronActive;
  final String? cronTargetTime;

  const AppHealth({
    required this.status,
    this.sqliteConnected,
    this.onnxLoaded,
    this.cronActive,
    this.cronTargetTime,
  });

  factory AppHealth.fromJson(Map<String, dynamic> json) {
    final sqlite = json['sqlite'] as Map<String, dynamic>?;
    final onnx = json['onnx_engine'] as Map<String, dynamic>?;
    final cron = json['cron_scheduler'] as Map<String, dynamic>?;

    return AppHealth(
      status: json['status'] as String? ?? 'unknown',
      sqliteConnected: sqlite == null ? null : sqlite['status'] == 'connected',
      onnxLoaded: onnx == null ? null : onnx['status'] == 'loaded',
      cronActive: cron == null ? null : cron['status'] == 'active',
      cronTargetTime: cron?['target_time'] as String?,
    );
  }
}

/// Real ONNX CPU inference latency micro-benchmark from
/// `/api/v1/benchmarks/latency`. Field names mirror the backend's
/// `LatencyBenchmarkResponse` exactly; `targetCeilingMs` and
/// `speedupVsEdgeCeiling` are the backend's own computed figures, never a
/// client-side guess.
class BenchmarkLatency {
  final double? meanLatencyUs;
  final double? p50Us;
  final double? p95Us;
  final double? p99Us;
  final double? minUs;
  final double? maxUs;
  final double? targetCeilingMs;
  final double? speedupVsEdgeCeiling;

  const BenchmarkLatency({
    this.meanLatencyUs,
    this.p50Us,
    this.p95Us,
    this.p99Us,
    this.minUs,
    this.maxUs,
    this.targetCeilingMs,
    this.speedupVsEdgeCeiling,
  });

  factory BenchmarkLatency.fromJson(Map<String, dynamic> json) {
    return BenchmarkLatency(
      meanLatencyUs: (json['mean_latency_us'] as num?)?.toDouble(),
      p50Us: (json['p50_latency_us'] as num?)?.toDouble(),
      p95Us: (json['p95_latency_us'] as num?)?.toDouble(),
      p99Us: (json['p99_latency_us'] as num?)?.toDouble(),
      minUs: (json['min_latency_us'] as num?)?.toDouble(),
      maxUs: (json['max_latency_us'] as num?)?.toDouble(),
      targetCeilingMs: (json['target_ceiling_ms'] as num?)?.toDouble(),
      speedupVsEdgeCeiling: (json['speedup_vs_edge_ceiling'] as num?)?.toDouble(),
    );
  }
}
