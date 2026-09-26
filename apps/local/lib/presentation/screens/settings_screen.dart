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

    setState(() {
      _isTestingPing = false;
      if (widget.handler.isEngineOnline) {
        _pingResult = 'Online (${stopwatch.elapsedMilliseconds} ms)';
      } else {
        _pingResult = 'Offline (timeout)';
      }
    });
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
          s.tableConfirmDeleteTitle,
          style: const TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Ubuntu Sans'),
        ),
        content: Text(
          s.tableConfirmDeleteDesc,
          style: const TextStyle(fontSize: 13, fontFamily: 'Ubuntu Sans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
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
                      ok ? 'Base de dados restaurada com sucesso.' : 'Falha ao limpar base de dados.',
                    ),
                    backgroundColor: ok ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                );
              }
            },
            child: const Text('Confirmar Limpeza'),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.blueGrey.shade900 : Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.tune,
              size: 28,
              color: isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade800,
            ),
          ),
          const SizedBox(width: 16),
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
              Icon(
                Icons.router,
                size: 18,
                color: isDark ? Colors.green.shade400 : Colors.green.shade800,
              ),
              const SizedBox(width: 8),
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
                    isOnline ? 'CONECTADO' : 'SEM RESPOSTA',
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
                label: const Text('Testar Conexão'),
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
              Icon(
                Icons.storage,
                size: 18,
                color: isDark ? Colors.blue.shade400 : Colors.blue.shade800,
              ),
              const SizedBox(width: 8),
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
          _buildInfoRow('Engine de Persistência', 'SQLite 3 (WAL Mode + FFI)', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Talhões Cadastrados', '$parcelsCount talhões', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Registros Climáticos Carregados', '$recordsCount dias', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Sensores Mapeados', '$presetsCount presets / $customSensorsCount personalizados', isDark),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'AÇÕES RÁPIDAS DE DESENVOLVIMENTO & DEMONSTRAÇÃO',
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
                                ok
                                    ? 'Base populada com sucesso (4 talhões, 75 dias).'
                                    : 'Falha ao popular base de dados.',
                              ),
                              backgroundColor: ok ? Colors.green.shade800 : Colors.red.shade800,
                            ),
                          );
                        }
                      },
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Popular Base Demo (75 Dias)'),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  side: BorderSide(color: Colors.red.shade700.withValues(alpha: 0.5)),
                ),
                onPressed: widget.handler.isLoading ? null : _confirmCleanDatabase,
                icon: const Icon(Icons.delete_sweep, size: 16),
                label: const Text('Restaurar Estado de Fábrica'),
              ),
            ],
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
              Icon(
                Icons.palette_outlined,
                size: 18,
                color: isDark ? Colors.purple.shade300 : Colors.purple.shade700,
              ),
              const SizedBox(width: 8),
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
            segments: const [
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode, size: 16),
                label: Text('Modo Escuro'),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode, size: 16),
                label: Text('Modo Claro'),
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
          // Background Graph Paper Selector
          Row(
            children: [
              Icon(
                Icons.grid_4x4,
                size: 16,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                s.settingsGridLabel,
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
          DropdownButtonFormField<OryzaBackgroundStyle>(
            initialValue: controller.backgroundStyle,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: const [
              DropdownMenuItem(
                value: OryzaBackgroundStyle.atmospheric,
                child: Text('Atmosférico (Difuso Biofísico)'),
              ),
              DropdownMenuItem(
                value: OryzaBackgroundStyle.cleanStudio,
                child: Text('Estúdio Minimalista (Limpo)'),
              ),
              DropdownMenuItem(
                value: OryzaBackgroundStyle.swissDots,
                child: Text('Matriz Suíça (Micro-Pontos 48px)'),
              ),
              DropdownMenuItem(
                value: OryzaBackgroundStyle.topographic,
                child: Text('Topográfico (Curvas Agronômicas)'),
              ),
            ],
            onChanged: (style) {
              if (style != null) {
                controller.setBackgroundStyle(style);
              }
            },
          ),
          const SizedBox(height: 20),
          // Language Selector
          Row(
            children: [
              Icon(
                Icons.language,
                size: 16,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
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
              Icon(
                Icons.info_outline,
                size: 18,
                color: isDark ? Colors.amber.shade300 : Colors.amber.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'ARQUITETURA DO SISTEMA & TELEMETRIA',
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
          _buildInfoRow('Aplicação Edge', 'Oryza-Elo Dashboard v0.1.0', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Engine Residente', 'Rust 2021 (Axum + Tokio + Tract ONNX)', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Design System', 'Swiss Scrapbook Minimalist / Oryzaelo UI', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Modo de Operação', 'Air-Gapped Local (Zero Dependência Cloud)', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Porta TCP Padrão', '8005 (HTTP / REST JSON)', isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Ubuntu Sans',
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Ubuntu Sans Mono',
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
}
