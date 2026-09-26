import 'package:flutter/material.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:local/presentation/widgets/agrometeorological_charts.dart';
import 'package:local/presentation/widgets/dashboard_header.dart';
import 'package:local/presentation/widgets/edge_telemetry_hud.dart';
import 'package:local/presentation/widgets/expandable_section.dart';
import 'package:local/presentation/widgets/multidimensional_visualizations.dart';
import 'package:local/presentation/widgets/parcel_selector_bar.dart';
import 'package:local/presentation/widgets/phenology_monitor_card.dart';
import 'package:local/presentation/widgets/sensor_ingestion_center.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Main operational dashboard screen running on edge hardware (0.0.0.0:8005).
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardHandler _handler;

  @override
  void initState() {
    super.initState();
    _handler = DashboardHandler();
    _handler.initialize();
  }

  @override
  void dispose() {
    _handler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _handler,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          body: GraphPaperBackground(
            isDark: isDark,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1280),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top Header (Brand, Air-Gapped pill, Theme & Language toggles)
                        DashboardHeader(
                          isOnline: _handler.isEngineOnline,
                          isRefreshing: _handler.isLoading,
                          onRefresh: () => _handler.initialize(),
                        ),

                        // Error Banner if Engine is Unreachable
                        if (!_handler.isEngineOnline) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade900.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade700),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.cloud_off, color: Colors.redAccent, size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Nó de borda local não respondeu em 0.0.0.0:8005. Verifique se o binário oryzaelo_engine está em execução.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.redAccent,
                                      fontFamily: 'Ubuntu Sans',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Parcel Selector Toolbar (CRUD for Parcels)
                        ParcelSelectorBar(handler: _handler),

                        // ── SECTION 1: Phenological BBCH Monitor & Prescriptive Advisories ──
                        ExpandableSection(
                          title: 'MONITOR FENOLÓGICO BBCH E PRESCRIÇÕES AGRONÔMICAS',
                          subtitle: 'Estágio fisiológico predito por IA residente (ONNX) e manejo operacional',
                          tag: 'INFERÊNCIA ATIVA',
                          icon: Icons.psychology,
                          initialExpanded: true,
                          child: PhenologyMonitorCard(handler: _handler),
                        ),

                        // ── SECTION 2: Agrometeorological Curves & Dynamics ──
                        ExpandableSection(
                          title: 'DINÂMICA CLIMÁTICA E SOMA TÉRMICA (GDD BASE 10°C)',
                          subtitle: 'Curvas de acúmulo térmico, amplitude DTR e balanço hídrico',
                          tag: 'SÉRIES TEMPORAIS',
                          icon: Icons.show_chart,
                          initialExpanded: true,
                          child: AgrometeorologicalCharts(records: _handler.weatherRecords),
                        ),

                        // ── SECTION 3: Multidimensional Visualizations ──
                        ExpandableSection(
                          title: 'ÍNDICES MULTIDIMENSIONAIS, RADAR BIOMET E CORRELAÇÕES',
                          subtitle: 'Radar de 5 dimensões fisiológicas, matriz de Pearson e alertas estatísticos',
                          tag: 'CIÊNCIA DE DADOS',
                          icon: Icons.auto_graph,
                          initialExpanded: true,
                          child: MultidimensionalVisualizations(
                            prediction: _handler.latestPrediction,
                            analytics: _handler.analyticsReport,
                          ),
                        ),

                        // ── SECTION 4: Sensor & Ingestion Management Center ──
                        ExpandableSection(
                          title: 'CONFIGURAÇÃO DE SENSORES E INGESTÃO DE DADOS (CSV)',
                          subtitle: 'Mapeamento de colunas, calibração de unidades e validação no SQLite',
                          tag: 'INGESTÃO LOCAL',
                          icon: Icons.sensors,
                          initialExpanded: false,
                          child: SensorIngestionCenter(handler: _handler),
                        ),

                        // ── SECTION 5: Edge Node Hardware & Benchmarks Telemetry HUD ──
                        ExpandableSection(
                          title: 'TELEMETRIA DO HARDWARE DE BORDA E BENCHMARKS EM TEMPO REAL',
                          subtitle: 'Latência submilissegundo (< 22 µs), CPU/RAM do Raspberry Pi e estado dos subsistemas',
                          tag: 'HARDWARE HUD',
                          icon: Icons.speed,
                          initialExpanded: false,
                          child: EdgeTelemetryHud(handler: _handler),
                        ),

                        const SizedBox(height: 24),

                        // Footer
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'ORYZA-ELO EDGE PLATFORM • OPERAÇÃO 100% AIR-GAPPED • USP / ESALQ • ASODYA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Ubuntu Sans Mono',
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade600,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
