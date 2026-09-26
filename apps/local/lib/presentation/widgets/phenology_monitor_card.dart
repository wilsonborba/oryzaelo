import 'package:flutter/material.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Real-time BBCH Phenological Monitor and Prescriptive Agronomic Advisories.
class PhenologyMonitorCard extends StatelessWidget {
  final DashboardHandler handler;

  const PhenologyMonitorCard({
    super.key,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = OryzaScope.of(context);
    final locale = state.locale;
    final currentLang = locale.countryCode != null
        ? '${locale.languageCode}-${locale.countryCode}'
        : locale.languageCode;
    final pred = handler.latestPrediction;

    if (pred == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(Icons.eco_outlined, size: 48, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text(
                'Nenhuma inferência fenológica registrada para este talhão.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text(
                'Carregue dados meteorológicos ou execute a predição manual com o modelo CatBoost ONNX.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: handler.isAnalyzing ? null : () => handler.runPrediction(currentLang),
                icon: const Icon(Icons.bolt, size: 18),
                label: const Text('Executar Inferência de Borda'),
              ),
            ],
          ),
        ),
      );
    }

    // Resolve localized advisory from backend payload without calling server
    final advisory = pred.getAdvisoryForLocale(currentLang);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Stage & Confidence Banner
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
                // Granular Stage Badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getStageColor(pred.granularStage).withValues(alpha: isDark ? 0.25 : 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _getStageColor(pred.granularStage),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.psychology,
                            size: 20,
                            color: _getStageColor(pred.granularStage),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatStageName(pred.granularStage),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Ubuntu Sans',
                              color: _getStageColor(pred.granularStage),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Macro-Phase Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'FASE: ${pred.macroPhase.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Ubuntu Sans Mono',
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                // Confidence Gauge & Predict Button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Confidence Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black26 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: pred.confidence >= 0.85 ? Colors.green : Colors.amber,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'CONFIANÇA: ${(pred.confidence * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Ubuntu Sans Mono',
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (pred.isTransitioning) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade900.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade700),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.swap_horiz, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              'TRANSIÇÃO IMINENTE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Ubuntu Sans Mono',
                                color: Colors.amber.shade300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(width: 10),

                    // Manual Predict CTA
                    ElevatedButton.icon(
                      onPressed: handler.isAnalyzing ? null : () => handler.runPrediction(currentLang),
                      icon: handler.isAnalyzing
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.bolt, size: 16),
                      label: Text(handler.isAnalyzing ? 'Inferindo...' : 'Reavaliar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.green.shade800 : Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

        const SizedBox(height: 18),

        // BBCH Stage Progression Timeline
        _buildStageProgressionBar(pred.granularStage, isDark),

        const SizedBox(height: 18),

        // Actionable Agronomic Advisory Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Advisory Headline
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.tips_and_updates_outlined,
                    color: isDark ? Colors.amber.shade300 : Colors.amber.shade800,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          advisory.headline,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Ubuntu Sans',
                            color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          advisory.plainText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.45,
                            fontFamily: 'Ubuntu Sans',
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Urgent Warnings (Mandatory Restrictions, e.g. 09h-12h Spray Ban)
              if (advisory.urgentWarnings.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.red.shade900.withValues(alpha: 0.3) : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.red.shade700 : Colors.red.shade300,
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 18, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'RESTRIÇÃO OPERACIONAL MANDATÓRIA',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Ubuntu Sans Mono',
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...advisory.urgentWarnings.map(
                        (w) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red)),
                              Expanded(
                                child: Text(
                                  w,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Ubuntu Sans',
                                    color: isDark ? Colors.red.shade200 : Colors.red.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Management Tips
              if (advisory.managementTips.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'RECOMENDAÇÕES PRÁTICAS DE MANEJO:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    fontFamily: 'Ubuntu Sans Mono',
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                ...advisory.managementTips.map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 14,
                          color: isDark ? Colors.green.shade400 : Colors.green.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tip,
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              fontFamily: 'Ubuntu Sans',
                              color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStageProgressionBar(String currentStage, bool isDark) {
    const stages = [
      {'key': 'Seedling', 'label': 'Plântula', 'bbch': '10-19'},
      {'key': 'Tillering', 'label': 'Perfilhamento', 'bbch': '20-29'},
      {'key': 'Booting', 'label': 'Emborrachamento', 'bbch': '40-49'},
      {'key': 'Heading', 'label': 'Espigamento', 'bbch': '50-59'},
      {'key': 'Flowering', 'label': 'Floração', 'bbch': '60-69'},
      {'key': 'PreHarvest', 'label': 'Maturação', 'bbch': '70-89'},
      {'key': 'HarvestReady', 'label': 'Colheita', 'bbch': '90-99'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: stages.asMap().entries.map((entry) {
          final idx = entry.key;
          final s = entry.value;
          final isCurrent = s['key'] == currentStage;
          final isPassed = _stageIndex(s['key']!) < _stageIndex(currentStage);

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? (isDark ? Colors.green.shade800 : Colors.green.shade600)
                      : (isPassed
                          ? (isDark ? const Color(0xFF0C2612) : Colors.green.shade100)
                          : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04))),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isCurrent
                        ? Colors.greenAccent
                        : (isPassed ? Colors.green.shade700 : Colors.transparent),
                    width: isCurrent ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      s['label']!,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                        color: isCurrent
                            ? Colors.white
                            : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                        fontFamily: 'Ubuntu Sans',
                      ),
                    ),
                    Text(
                      'BBCH ${s['bbch']}',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Ubuntu Sans Mono',
                        color: isCurrent
                            ? Colors.white70
                            : (isDark ? Colors.grey.shade600 : Colors.grey.shade500),
                      ),
                    ),
                  ],
                ),
              ),
              if (idx < stages.length - 1) ...[
                Container(
                  width: 14,
                  height: 2,
                  color: isPassed ? Colors.green.shade600 : (isDark ? Colors.white12 : Colors.black12),
                ),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  int _stageIndex(String stage) {
    switch (stage) {
      case 'Seedling':
        return 0;
      case 'Tillering':
        return 1;
      case 'Booting':
        return 2;
      case 'Heading':
        return 3;
      case 'Flowering':
        return 4;
      case 'PreHarvest':
        return 5;
      case 'HarvestReady':
        return 6;
      default:
        return 0;
    }
  }

  Color _getStageColor(String stage) {
    switch (stage) {
      case 'Seedling':
        return Colors.teal;
      case 'Tillering':
        return Colors.green;
      case 'Booting':
        return Colors.blue;
      case 'Heading':
        return Colors.indigo;
      case 'Flowering':
        return Colors.amber.shade800;
      case 'PreHarvest':
        return Colors.orange;
      case 'HarvestReady':
        return Colors.red.shade700;
      default:
        return Colors.green;
    }
  }

  String _formatStageName(String stage) {
    switch (stage) {
      case 'Seedling':
        return 'Plântula (BBCH 10–19)';
      case 'Tillering':
        return 'Perfilhamento Ativo (BBCH 20–29)';
      case 'Booting':
        return 'Emborrachamento (BBCH 40–49)';
      case 'Heading':
        return 'Espigamento (BBCH 50–59)';
      case 'Flowering':
        return 'Floração / Antese (BBCH 60–69)';
      case 'PreHarvest':
        return 'Maturação Pré-Colheita (BBCH 70–89)';
      case 'HarvestReady':
        return 'Colheita Plena (BBCH 90–99)';
      default:
        return stage;
    }
  }
}
