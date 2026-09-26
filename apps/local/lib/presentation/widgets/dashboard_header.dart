import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Top operational header matching the Swiss minimalist design system.
/// Contains system status, refresh action, and design system controls.
class DashboardHeader extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onRefresh;
  final bool isRefreshing;
  final VoidCallback? onToggleSidebar;

  const DashboardHeader({
    super.key,
    required this.isOnline,
    required this.onRefresh,
    this.isRefreshing = false,
    this.onToggleSidebar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = OryzaI18n.of(context);

    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 768;
          // Phone-tier: trims the header further so it never overflows on a
          // real handset (menu + brand + status + refresh + theme + language
          // all fit in ~300px once the badge/subtitle/text labels are cut).
          final isNarrow = constraints.maxWidth < 480;

          return Row(
            children: [
              // Optional Sidebar toggle button (useful on mobile or compact widths)
              if (onToggleSidebar != null) ...[
                Tooltip(
                  message: s.headerMenuTooltip,
                  child: Material(
                    color: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: onToggleSidebar,
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                        child: const Icon(Icons.menu, size: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],

                // Brand Mark & Local Edge Title (No corner emoji/logo)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                        if (!isNarrow) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.amber.shade900.withValues(alpha: 0.35)
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
                      ],
                    ),
                    if (!isCompact) ...[
                      const SizedBox(height: 2),
                      Text(
                        s.headerSubtitle,
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

                const Spacer(),

                // Air-Gapped Status Indicator Pill (dot-only on narrow phones)
                Tooltip(
                  message: isOnline ? s.headerOnlineStatus : s.headerOfflineStatus,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: isNarrow ? 6 : 10, vertical: 5),
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
                        if (!isNarrow) ...[
                          const SizedBox(width: 6),
                          Text(
                            isOnline ? s.headerOnlineStatus : s.headerOfflineStatus,
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
                      ],
                    ),
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
                  tooltip: s.headerRefreshTooltip,
                ),

                const SizedBox(width: 6),

                // Design System Controls
                const ThemeToggle(),
                const SizedBox(width: 6),
                LanguageSelector(compact: isNarrow),
              ],
            );
          },
        ),
    );
  }
}
