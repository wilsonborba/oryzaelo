import 'package:flutter/material.dart';
import 'package:local/core/settings.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Settings screen for edge station parameters, SQLite database diagnostics, and visual preferences.
class SettingsScreen extends StatefulWidget {
  final DashboardHandler handler;

  const SettingsScreen({
    super.key,
    required this.handler,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isTestingPing = false;
  String? _pingResult;

  Future<void> _testConnection() async {
    setState(() {
      _isTestingPing = true;
      _pingResult = null;
    });

    final stopwatch = Stopwatch()..start();
    await widget.handler.refreshTelemetry();
    stopwatch.stop();

    if (!mounted) return;

    final s = OryzaI18n.of(context);
    setState(() {
      _isTestingPing = false;
      if (widget.handler.isEngineOnline) {
        _pingResult = s.settingsOnlineStatus.replaceAll('{ms}', '${stopwatch.elapsedMilliseconds}');
      } else {
        _pingResult = s.settingsOfflineStatus;
      }
    });
  }

  void _showCronTimeDialog() {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = widget.handler.cronTargetTime ?? '23:59';
    final parts = current.split(':');
    var selected = TimeOfDay(
      hour: parts.isNotEmpty ? int.tryParse(parts[0]) ?? 23 : 23,
      minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 59 : 59,
    );
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(s.settingsCronDialogTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, fontFamily: 'Ubuntu Sans Mono'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showTimePicker(context: context, initialTime: selected);
                  if (picked != null) setDlgState(() => selected = picked);
                },
                icon: const Icon(Icons.schedule, size: 16),
                label: Text(s.settingsCronChangeBtn),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
              child: Text(s.cancelBtn),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      setDlgState(() => isSaving = true);
                      final hhMm =
                          '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}';
                      final ok = await widget.handler.updateCronTargetTime(hhMm);
                      if (!ctx.mounted) return;
                      Navigator.of(ctx).pop();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ok ? s.settingsCronUpdateSuccess : s.settingsCronUpdateFailedMsg),
                          backgroundColor: ok ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      );
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(s.confirmBtn),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmCleanDatabase() {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          s.confirmCleanTitle,
          style: const TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Ubuntu Sans'),
        ),
        content: Text(
          s.confirmCleanDesc,
          style: const TextStyle(fontSize: 13, fontFamily: 'Ubuntu Sans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(s.cancelBtn),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final ok = await widget.handler.cleanMockData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok ? s.demoDataCleanedSuccess : s.settingsCleanFailedMsg,
                    ),
                    backgroundColor: ok ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                );
              }
            },
            child: Text(s.confirmBtn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = OryzaScope.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              _buildHeaderCard(context, isDark, s),
              const SizedBox(height: 16),

              // Layout: Two columns on desktop, one column on mobile
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildEndpointCard(context, isDark, s),
                              const SizedBox(height: 16),
                              _buildDatabaseCard(context, isDark, s),
                              const SizedBox(height: 16),
                              _buildCronCard(context, isDark, s),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildAppearanceCard(context, isDark, s, controller),
                              const SizedBox(height: 16),
                              _buildSystemInfoCard(context, isDark, s),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildEndpointCard(context, isDark, s),
                      const SizedBox(height: 16),
                      _buildDatabaseCard(context, isDark, s),
                      const SizedBox(height: 16),
                      _buildCronCard(context, isDark, s),
                      const SizedBox(height: 16),
                      _buildAppearanceCard(context, isDark, s, controller),
                      const SizedBox(height: 16),
                      _buildSystemInfoCard(context, isDark, s),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, bool isDark, OryzaStrings s) {
    return ScrapbookCard(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.settingsTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    fontFamily: 'Ubuntu Sans Mono',
                    color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.settingsSubtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Ubuntu Sans',
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndpointCard(BuildContext context, bool isDark, OryzaStrings s) {
    final isOnline = widget.handler.isEngineOnline;

    return ScrapbookCard(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                s.settingsEdgeEndpoint.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black38 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppSettings.activeBaseUrl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Ubuntu Sans Mono',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? (isDark ? Colors.green.shade900.withValues(alpha: 0.4) : Colors.green.shade100)
                        : (isDark ? Colors.red.shade900.withValues(alpha: 0.4) : Colors.red.shade100),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isOnline ? s.settingsConnectedBadge : s.settingsNoResponseBadge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Ubuntu Sans Mono',
                      color: isOnline
                          ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
                          : (isDark ? Colors.red.shade300 : Colors.red.shade800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _isTestingPing ? null : _testConnection,
                icon: _isTestingPing
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.network_ping, size: 16),
                label: Text(s.settingsTestConnectionBtn),
              ),
              if (_pingResult != null) ...[
                const SizedBox(width: 12),
                Text(
                  _pingResult!,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Ubuntu Sans Mono',
                    color: isOnline ? Colors.green.shade600 : Colors.red.shade600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatabaseCard(BuildContext context, bool isDark, OryzaStrings s) {
    final parcelsCount = widget.handler.parcels.length;
    final recordsCount = widget.handler.weatherRecords.length;
    final presetsCount = widget.handler.devicePresets.length;
    final customSensorsCount = widget.handler.customMappings.length;

    return ScrapbookCard(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                s.settingsStorageInfo.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(s.settingsPersistenceEngineLabel, s.settingsSqliteEngineValue, isDark),
          const SizedBox(height: 8),
          _buildInfoRow(s.settingsParcelsRegisteredLabel, '$parcelsCount ${s.settingsParcelsUnit}', isDark),
          const SizedBox(height: 8),
          _buildInfoRow(s.settingsRecordsLoadedLabel, '$recordsCount ${s.settingsDaysUnit}', isDark),
          const SizedBox(height: 8),
          _buildInfoRow(
            s.settingsSensorsMappedLabel,
            '$presetsCount ${s.settingsPresetsUnit} / $customSensorsCount ${s.settingsCustomUnit}',
            isDark,
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            s.settingsQuickActionsHeader,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              fontFamily: 'Ubuntu Sans Mono',
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.green.shade800 : Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                onPressed: widget.handler.isLoading
                    ? null
                    : () async {
                        final ok = await widget.handler.populateMockData(days: 75, parcels: 4);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ok ? s.demoDataLoadedSuccess : s.settingsPopulateFailedMsg,
                              ),
                              backgroundColor: ok ? Colors.green.shade800 : Colors.red.shade800,
                            ),
                          );
                        }
                      },
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: Text(s.settingsPopulateDemoBtn),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  side: BorderSide(color: Colors.red.shade700.withValues(alpha: 0.5)),
                ),
                onPressed: widget.handler.isLoading ? null : _confirmCleanDatabase,
                icon: const Icon(Icons.delete_sweep, size: 16),
                label: Text(s.settingsRestoreFactoryBtn),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCronCard(BuildContext context, bool isDark, OryzaStrings s) {
    final currentTime = widget.handler.cronTargetTime;

    return ScrapbookCard(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                s.settingsCronHeader.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            s.settingsCronDesc,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Ubuntu Sans',
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black38 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.settingsCronCurrentLabel,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontFamily: 'Ubuntu Sans Mono',
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentTime ?? '—',
                        style: const TextStyle(
                          fontFamily: 'Ubuntu Sans Mono',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _showCronTimeDialog,
                  icon: const Icon(Icons.schedule, size: 16),
                  label: Text(s.settingsCronChangeBtn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard(
    BuildContext context,
    bool isDark,
    OryzaStrings s,
    OryzaController controller,
  ) {
    return ScrapbookCard(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                s.settingsThemeLabel.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Theme Selector (Dark / Light)
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode, size: 16),
                label: Text(s.themeDarkMode),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode, size: 16),
                label: Text(s.themeLightMode),
              ),
            ],
            selected: {controller.themeMode},
            onSelectionChanged: (modes) {
              if (modes.isNotEmpty) {
                controller.setThemeMode(modes.first);
              }
            },
          ),
          const SizedBox(height: 20),
          // Language Selector
          Row(
            children: [
              Text(
                s.settingsLangLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: controller.locale.languageCode,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: const [
              DropdownMenuItem(value: 'pt', child: Text('Português (Brasil)')),
              DropdownMenuItem(value: 'en', child: Text('English (Global)')),
              DropdownMenuItem(value: 'th', child: Text('ไทย (ภาษาไทย)')),
            ],
            onChanged: (lang) {
              if (lang != null) {
                if (lang == 'pt') {
                  controller.setLocale(const Locale('pt', 'BR'));
                } else if (lang == 'th') {
                  controller.setLocale(const Locale('th', 'TH'));
                } else {
                  controller.setLocale(const Locale('en', 'US'));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfoCard(BuildContext context, bool isDark, OryzaStrings s) {
    return ScrapbookCard(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                s.settingsSystemArchHeader,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade200 : Colors.grey.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(s.settingsInfoAppLabel, 'Oryza-Elo Dashboard v0.1.0', isDark),
          const SizedBox(height: 8),
          _buildInfoRow(s.settingsInfoEngineLabel, 'Rust 2021 (Axum + Tokio + Tract ONNX)', isDark),
          const SizedBox(height: 8),
          _buildInfoRow(s.settingsInfoDesignLabel, 'Swiss Scrapbook Minimalist / Oryzaelo UI', isDark),
          const SizedBox(height: 8),
          _buildInfoRow(s.settingsInfoModeLabel, s.settingsInfoModeValue, isDark),
          const SizedBox(height: 8),
          _buildInfoRow(s.settingsInfoPortLabel, '8005 (HTTP / REST JSON)', isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Ubuntu Sans',
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Ubuntu Sans Mono',
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
