import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:local/domain/models/system_telemetry.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Real-time Edge Hardware & Microsecond Benchmark Telemetry HUD.
class EdgeTelemetryHud extends StatelessWidget {
  final DashboardHandler handler;

  const EdgeTelemetryHud({
    super.key,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = OryzaI18n.of(context);

    final sys = handler.systemHealth;
    final app = handler.appHealth;
    final bench = handler.benchmarkLatency;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 850;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Microsecond Latency Meters (Edge Inference Performance)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.hudLatencyHeader,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      fontFamily: 'Ubuntu Sans Mono',
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, gaugeConstraints) {
                      // A fixed 175px tile only fits 1-per-row on a phone
                      // (≈296px content width). Size tiles so 2 always fit
                      // side by side, capped at 175 on wider containers.
                      final gaugeWidth = math.min(
                        175.0,
                        (gaugeConstraints.maxWidth - 16) / 2,
                      );
                      return Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildLatencyGauge(
                            width: gaugeWidth,
                            label: s.hudCpuMeanLabel,
                            value: bench?.meanLatencyUs != null
                                ? '${bench!.meanLatencyUs!.toStringAsFixed(1)} µs'
                                : s.hudNoDataLabel,
                            subtext: s.hudCpuMeanDetail,
                            color: Colors.green,
                            isDark: isDark,
                          ),
                          _buildLatencyGauge(
                            width: gaugeWidth,
                            label: s.hudP95Label,
                            value: bench?.p95Us != null ? '${bench!.p95Us!.toStringAsFixed(1)} µs' : s.hudNoDataLabel,
                            subtext: s.hudP95Detail,
                            color: Colors.teal,
                            isDark: isDark,
                          ),
                          _buildLatencyGauge(
                            width: gaugeWidth,
                            label: s.hudThesisCeilingLabel,
                            value: bench?.targetCeilingMs != null
                                ? '${bench!.targetCeilingMs!.toStringAsFixed(1)} ms'
                                : s.hudNoDataLabel,
                            subtext: s.hudThesisCeilingDetail,
                            color: Colors.blueGrey,
                            isDark: isDark,
                          ),
                          _buildLatencyGauge(
                            width: gaugeWidth,
                            label: s.hudRelativeSpeedLabel,
                            value: bench?.speedupVsEdgeCeiling != null
                                ? '${bench!.speedupVsEdgeCeiling!.toStringAsFixed(2)}x'
                                : s.hudNoDataLabel,
                            subtext: s.hudRelativeSpeedDetail,
                            color: Colors.amber.shade800,
                            isDark: isDark,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Hardware & Operating System Probes
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSystemProbesPanel(sys, isDark, s),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSubsystemsPanel(app, isDark, s),
                  ),
                ],
              )
            else ...[
              _buildSystemProbesPanel(sys, isDark, s),
              const SizedBox(height: 16),
              _buildSubsystemsPanel(app, isDark, s),
            ],
          ],
        );
      },
    );
  }

  Widget _buildLatencyGauge({
    required String label,
    required String value,
    required String subtext,
    required Color color,
    required bool isDark,
    double width = 175,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              fontFamily: 'Ubuntu Sans Mono',
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Ubuntu Sans Mono',
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 9.5,
              fontFamily: 'Ubuntu Sans',
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemProbesPanel(SystemHealth? sys, bool isDark, OryzaStrings s) {
    final hostIdentity = (sys?.os != null && sys?.arch != null)
        ? s.hudHostIdentityFormat.replaceAll('{os}', sys!.os!).replaceAll('{arch}', sys.arch!)
        : null;
    final cpuDetail = sys?.cpuCores != null
        ? s.hudCpuUsageDetail.replaceAll('{cores}', '${sys!.cpuCores}')
        : s.hudNoDataLabel;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                s.hudHardwareHeader,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                ),
              ),
              if (hostIdentity != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    hostIdentity,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontFamily: 'Ubuntu Sans Mono',
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          _buildResourceBar(
            label: s.hudCpuUsageLabel,
            pct: sys?.cpuUsagePct,
            detail: sys?.cpuUsagePct != null ? '${sys!.cpuUsagePct!.toStringAsFixed(1)}% ($cpuDetail)' : null,
            noDataLabel: s.hudNoDataLabel,
            color: Colors.blue,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildResourceBar(
            label: s.hudRamLabel,
            pct: sys?.ramUsagePct,
            detail: (sys?.ramUsedMb != null && sys?.ramTotalMb != null)
                ? '${sys!.ramUsedMb} MB / ${sys.ramTotalMb} MB'
                : null,
            noDataLabel: s.hudNoDataLabel,
            color: Colors.teal,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildResourceBar(
            label: s.hudDiskLabel,
            pct: sys?.diskUsagePct,
            detail: sys?.diskUsagePct != null ? '${sys!.diskUsagePct!.toStringAsFixed(1)}% ${s.hudUsedSuffix}' : null,
            noDataLabel: s.hudNoDataLabel,
            color: Colors.amber.shade800,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceBar({
    required String label,
    required double? pct,
    required String? detail,
    required String noDataLabel,
    required Color color,
    required bool isDark,
  }) {
    final hasData = pct != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                detail ?? noDataLabel,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: hasData
                      ? (isDark ? Colors.grey.shade300 : Colors.grey.shade800)
                      : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: hasData ? (pct / 100.0).clamp(0.0, 1.0) : 0.0,
            minHeight: 6,
            backgroundColor: isDark ? Colors.white10 : Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(hasData ? color : Colors.grey.withValues(alpha: 0.3)),
          ),
        ),
      ],
    );
  }

  Widget _buildSubsystemsPanel(AppHealth? app, bool isDark, OryzaStrings s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.hudSubsystemsHeader,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              fontFamily: 'Ubuntu Sans Mono',
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 14),
          _buildSubsystemRow(
            s.hudSqliteLabel,
            app?.sqliteConnected,
            'src/dal/data/local/oryza_elo_edge.db',
            isDark,
            s,
          ),
          const SizedBox(height: 10),
          _buildSubsystemRow(
            s.hudOnnxSessionLabel,
            app?.onnxLoaded,
            s.hudOnnxSessionDetail,
            isDark,
            s,
          ),
          const SizedBox(height: 10),
          _buildSubsystemRow(
            s.hudCronLabel.replaceAll('{time}', app?.cronTargetTime ?? s.hudNoDataLabel),
            app?.cronActive,
            s.hudCronDetail,
            isDark,
            s,
          ),
        ],
      ),
    );
  }

  Widget _buildSubsystemRow(String title, bool? isOk, String desc, bool isDark, OryzaStrings s) {
    return Row(
      children: [
        Icon(
          isOk == null ? Icons.help_outline : (isOk ? Icons.check_circle : Icons.error),
          size: 16,
          color: isOk == null ? Colors.grey : (isOk ? Colors.green : Colors.red),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Ubuntu Sans',
                ),
              ),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 9.5,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isOk == null
                ? (isDark ? Colors.white10 : Colors.grey.shade200)
                : (isOk ? (isDark ? Colors.green.shade900.withValues(alpha: 0.3) : Colors.green.shade50) : Colors.red.shade100),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            isOk == null ? s.hudStatusUnknown : (isOk ? s.hudStatusActive : s.hudStatusFailed),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              fontFamily: 'Ubuntu Sans Mono',
              color: isOk == null
                  ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                  : (isOk ? (isDark ? Colors.green.shade300 : Colors.green.shade800) : Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
