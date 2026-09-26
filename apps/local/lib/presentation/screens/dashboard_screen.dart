import 'package:flutter/material.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:local/presentation/screens/data_management_screen.dart';
import 'package:local/presentation/screens/sensor_config_screen.dart';
import 'package:local/presentation/screens/settings_screen.dart';
import 'package:local/presentation/screens/simulation_calculator_screen.dart';
import 'package:local/presentation/screens/stats_overview_screen.dart';
import 'package:local/presentation/widgets/dashboard_header.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Master shell with lateral collapsible sidebar and routed content area.
/// Replaces the previous single-scroll dashboard with a proper multi-screen
/// navigation architecture matching the Swiss minimalist design system.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardHandler _handler;
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;

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

  void _navigateTo(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _handler,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final s = OryzaI18n.of(context);
        final screenWidth = MediaQuery.of(context).size.width;
        final isCompact = screenWidth < 768;

        // On compact screens, auto-collapse sidebar
        final showExpandedSidebar = !isCompact && _isSidebarExpanded;

        return Scaffold(
          backgroundColor: isDark ? OryzaColors.darkCanvas : OryzaColors.lightCanvas,
          body: SafeArea(
            child: Column(
              children: [
                // ── Top Header Bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: DashboardHeader(
                    isOnline: _handler.isEngineOnline,
                    isRefreshing: _handler.isLoading,
                    onRefresh: () => _handler.initialize(),
                    onToggleSidebar: () {
                      setState(() => _isSidebarExpanded = !_isSidebarExpanded);
                    },
                  ),
                ),

                // ── Error Banner if Engine Unreachable ──
                if (!_handler.isEngineOnline)
                  _buildErrorBanner(isDark, s),

                // ── Sidebar + Content Area ──
                Expanded(
                  child: Row(
                    children: [
                      // Lateral Navigation Sidebar
                      _buildSidebar(context, isDark, s, showExpandedSidebar, isCompact),

                      // Content Area
                      Expanded(
                        child: _buildContentArea(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Mobile bottom nav as fallback on very compact screens
          bottomNavigationBar: isCompact ? _buildBottomNav(isDark, s) : null,
        );
      },
    );
  }

  // ── Sidebar ─────────────────────────────────────────────────────────────────

  Widget _buildSidebar(
    BuildContext context,
    bool isDark,
    OryzaStrings s,
    bool expanded,
    bool isCompact,
  ) {
    // On compact screens, no sidebar -- use bottom nav instead
    if (isCompact) return const SizedBox.shrink();

    final sidebarWidth = expanded ? 240.0 : 64.0;
    final bgColor = isDark
        ? Colors.black.withValues(alpha: 0.25)
        : Colors.white.withValues(alpha: 0.55);
    final borderColor = isDark ? Colors.white10 : Colors.black12;

    final destinations = _sidebarDestinations(s);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: sidebarWidth,
      margin: const EdgeInsets.only(left: 12, bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Navigation Items
          Expanded(
            child: ListView.builder(
              itemCount: destinations.length,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemBuilder: (context, index) {
                final dest = destinations[index];
                final isActive = _selectedIndex == index;

                return _buildSidebarItem(
                  icon: dest.icon,
                  label: dest.label,
                  isActive: isActive,
                  expanded: expanded,
                  isDark: isDark,
                  onTap: () => _navigateTo(index),
                );
              },
            ),
          ),

          // Sidebar Footer: Asodya Logo
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: expanded ? 16 : 8,
              vertical: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: isDark ? Colors.white10 : Colors.black12,
                  height: 1,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/img/logo.png',
                    width: expanded ? 36 : 28,
                    height: expanded ? 36 : 28,
                    fit: BoxFit.contain,
                  ),
                ),
                if (expanded) ...[
                  const SizedBox(height: 6),
                  Text(
                    s.sidebarBrand,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      fontFamily: 'Ubuntu Sans Mono',
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool expanded,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final activeColor = isDark ? Colors.green.shade400 : Colors.green.shade700;
    final inactiveColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final activeBg = isDark
        ? Colors.green.shade900.withValues(alpha: 0.25)
        : Colors.green.shade50;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isActive ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: expanded ? 12 : 0,
              vertical: 10,
            ),
            child: expanded
                ? Row(
                    children: [
                      Icon(icon, size: 20, color: isActive ? activeColor : inactiveColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                            fontFamily: 'Ubuntu Sans',
                            color: isActive ? activeColor : inactiveColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isActive)
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: activeColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  )
                : Tooltip(
                    message: label,
                    child: Center(
                      child: Icon(icon, size: 22, color: isActive ? activeColor : inactiveColor),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // ── Content Area ────────────────────────────────────────────────────────────

  Widget _buildContentArea() {
    switch (_selectedIndex) {
      case 0:
        return StatsOverviewScreen(handler: _handler);
      case 1:
        return SimulationCalculatorScreen(
          handler: _handler,
          onNavigateToData: () => _navigateTo(2),
        );
      case 2:
        return DataManagementScreen(handler: _handler);
      case 3:
        return SensorConfigScreen(handler: _handler);
      case 4:
        return SettingsScreen(handler: _handler);
      default:
        return StatsOverviewScreen(handler: _handler);
    }
  }

  // ── Error Banner ────────────────────────────────────────────────────────────

  Widget _buildErrorBanner(bool isDark, OryzaStrings s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.shade900.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade700),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, color: Colors.redAccent, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.errorBannerOfflineMsg,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                  fontFamily: 'Ubuntu Sans',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Mobile Bottom Navigation ────────────────────────────────────────────────

  Widget? _buildBottomNav(bool isDark, OryzaStrings s) {
    final destinations = _sidebarDestinations(s);

    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _navigateTo,
      backgroundColor: isDark
          ? Colors.grey.shade900.withValues(alpha: 0.95)
          : Colors.white.withValues(alpha: 0.95),
      indicatorColor: isDark
          ? Colors.green.shade900.withValues(alpha: 0.4)
          : Colors.green.shade100,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: destinations.map((d) {
        return NavigationDestination(
          icon: Icon(d.icon, size: 20),
          selectedIcon: Icon(d.icon, size: 22, color: Colors.green.shade600),
          label: d.shortLabel,
        );
      }).toList(),
    );
  }

  // ── Navigation Destinations Spec ────────────────────────────────────────────

  List<_NavDestination> _sidebarDestinations(OryzaStrings s) {
    return [
      _NavDestination(
        icon: Icons.analytics_outlined,
        label: s.dashNavStats,
        shortLabel: s.dashNavStats,
      ),
      _NavDestination(
        icon: Icons.calculate_outlined,
        label: s.dashNavSim,
        shortLabel: s.dashNavSim,
      ),
      _NavDestination(
        icon: Icons.table_chart_outlined,
        label: s.dashNavData,
        shortLabel: s.dashNavData,
      ),
      _NavDestination(
        icon: Icons.sensors_outlined,
        label: s.dashNavSensors,
        shortLabel: s.dashNavSensors,
      ),
      _NavDestination(
        icon: Icons.tune_outlined,
        label: s.dashNavSettings,
        shortLabel: s.dashNavSettings,
      ),
    ];
  }
}

/// Internal navigation destination model.
class _NavDestination {
  final IconData icon;
  final String label;
  final String shortLabel;

  const _NavDestination({
    required this.icon,
    required this.label,
    required this.shortLabel,
  });
}
