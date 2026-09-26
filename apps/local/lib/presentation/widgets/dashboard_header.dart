import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Top operational header matching the landing page design system.
class DashboardHeader extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onRefresh;
  final bool isRefreshing;

  const DashboardHeader({
    super.key,
    required this.isOnline,
    required this.onRefresh,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ScrapbookCard(
        isDark: isDark,
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 768;

            return Row(
              children: [
                // Brand Mark & Identity
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.green.shade800 : Colors.green.shade700,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🌾',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'ORYZA-ELO',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                                fontFamily: 'Ubuntu Sans',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.amber.shade900.withValues(alpha: 0.4)
                                    : Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isDark ? Colors.amber.shade700 : Colors.amber.shade400,
                                ),
                              ),
                              child: Text(
                                'LOCAL EDGE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                                  fontFamily: 'Ubuntu Sans Mono',
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!isCompact) ...[
                          Text(
                            'NÓ DE BORDA RURAL • PORTA 8005 • 0.0.0.0',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontFamily: 'Ubuntu Sans Mono',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                // Air-Gapped Status Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? (isDark ? Colors.green.shade900.withValues(alpha: 0.3) : Colors.green.shade50)
                        : (isDark ? Colors.red.shade900.withValues(alpha: 0.3) : Colors.red.shade50),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isOnline
                          ? (isDark ? Colors.green.shade700 : Colors.green.shade300)
                          : (isDark ? Colors.red.shade700 : Colors.red.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOnline ? Colors.greenAccent.shade700 : Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOnline ? 'AIR-GAPPED ATIVO' : 'ENGINE OFFLINE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isOnline
                              ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
                              : (isDark ? Colors.red.shade300 : Colors.red.shade800),
                          fontFamily: 'Ubuntu Sans Mono',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Refresh Button
                IconButton(
                  onPressed: isRefreshing ? null : onRefresh,
                  icon: isRefreshing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh, size: 20),
                  tooltip: 'Atualizar Telemetria',
                ),

                const SizedBox(width: 6),

                // Design System Controls
                const BackgroundStyleSelector(),
                const SizedBox(width: 6),
                const ThemeToggle(),
                const SizedBox(width: 6),
                const LanguageSelector(),
              ],
            );
          },
        ),
      ),
    );
  }
}
