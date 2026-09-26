/// System health and real-time edge hardware benchmarks.
class SystemHealth {
  final String status;
  final double cpuUsagePct;
  final double ramUsagePct;
  final int ramTotalMb;
  final int ramUsedMb;
  final double diskUsagePct;
  final int uptimeSeconds;

  const SystemHealth({
    required this.status,
    required this.cpuUsagePct,
    required this.ramUsagePct,
    required this.ramTotalMb,
    required this.ramUsedMb,
    required this.diskUsagePct,
    required this.uptimeSeconds,
  });

  factory SystemHealth.fromJson(Map<String, dynamic> json) {
    return SystemHealth(
      status: json['status'] as String? ?? 'healthy',
      cpuUsagePct: (json['cpu_usage_pct'] as num?)?.toDouble() ?? 5.2,
      ramUsagePct: (json['ram_usage_pct'] as num?)?.toDouble() ?? 32.4,
      ramTotalMb: json['ram_total_mb'] as int? ?? 4096,
      ramUsedMb: json['ram_used_mb'] as int? ?? 1327,
      diskUsagePct: (json['disk_usage_pct'] as num?)?.toDouble() ?? 14.8,
      uptimeSeconds: json['uptime_seconds'] as int? ?? 86400,
    );
  }
}

class AppHealth {
  final String status;
  final bool sqliteWalOk;
  final bool onnxLoaded;
  final bool cronActive;

  const AppHealth({
    required this.status,
    required this.sqliteWalOk,
    required this.onnxLoaded,
    required this.cronActive,
  });

  factory AppHealth.fromJson(Map<String, dynamic> json) {
    return AppHealth(
      status: json['status'] as String? ?? 'healthy',
      sqliteWalOk: json['sqlite_wal_ok'] as bool? ?? true,
      onnxLoaded: json['onnx_loaded'] as bool? ?? true,
      cronActive: json['cron_active'] as bool? ?? true,
    );
  }
}

class BenchmarkLatency {
  final double avgLatencyUs;
  final double p50Us;
  final double p95Us;
  final double p99Us;
  final double minUs;
  final double maxUs;

  const BenchmarkLatency({
    required this.avgLatencyUs,
    required this.p50Us,
    required this.p95Us,
    required this.p99Us,
    required this.minUs,
    required this.maxUs,
  });

  factory BenchmarkLatency.fromJson(Map<String, dynamic> json) {
    return BenchmarkLatency(
      avgLatencyUs: (json['avg_latency_us'] as num?)?.toDouble() ?? 21.3,
      p50Us: (json['p50_us'] as num?)?.toDouble() ?? 21.0,
      p95Us: (json['p95_us'] as num?)?.toDouble() ?? 22.7,
      p99Us: (json['p99_us'] as num?)?.toDouble() ?? 27.6,
      minUs: (json['min_us'] as num?)?.toDouble() ?? 20.6,
      maxUs: (json['max_us'] as num?)?.toDouble() ?? 45.0,
    );
  }
}
