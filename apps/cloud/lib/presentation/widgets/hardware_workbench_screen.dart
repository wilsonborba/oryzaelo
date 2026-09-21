import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class HardwareWorkbenchScreen extends StatefulWidget {
  final bool isDark;

  const HardwareWorkbenchScreen({super.key, required this.isDark});

  @override
  State<HardwareWorkbenchScreen> createState() => _HardwareWorkbenchScreenState();
}

class _HardwareWorkbenchScreenState extends State<HardwareWorkbenchScreen> {
  int _selectedDevice = 0;
  bool _showExploded = false; // false = Blueprint, true = Exploded View

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final s = OryzaI18n.of(context);
    for (final dev in s.hwDevices) {
      precacheImage(AssetImage(dev.blueprintImg), context);
      precacheImage(AssetImage(dev.explodedImg), context);
    }
  }

  void _openFullscreen(String imagePath, String title, String mode) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 1300, maxHeight: 880),
              decoration: BoxDecoration(
                color: const Color(0xFF0C100C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: OryzaColors.burntOrange, width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black87, blurRadius: 40, offset: Offset(0, 10)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$title — $mode",
                          style: const TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded || frame != null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 36,
                                height: 36,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: OryzaColors.burntOrange,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, _, _) => const Center(
                            child: Icon(Icons.broken_image, color: Colors.white38, size: 64),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;

    final devices = s.hwDevices;
    final deviceIndex = _selectedDevice.clamp(0, devices.length - 1);
    final device = devices[deviceIndex];
    final activeImage = _showExploded ? device.explodedImg : device.blueprintImg;
    final modeLabel = _showExploded ? s.hwToggleExploded : s.hwToggleBlueprint;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      constraints: const BoxConstraints(maxWidth: 1600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: OryzaColors.mustardYellow,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                s.hwSectionTag,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            s.hwTitle,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: isDesktop ? 34 : 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            s.hwSubtitle,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 15,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Horizontal Device Selector for smaller screens, or quick pills
          if (!isDesktop) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(devices.length, (idx) {
                  final isSelected = idx == _selectedDevice;
                  final dev = devices[idx];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(dev.name),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedDevice = idx),
                      selectedColor: OryzaColors.burntOrange,
                      backgroundColor: widget.isDark ? const Color(0xFF1B231B) : const Color(0xFFEDEAE0),
                      labelStyle: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : textPrimary,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? OryzaColors.burntOrange
                            : (widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 18),
          ],

          // Widescreen Multi-Column Desktop Grid
          if (isDesktop) ...[
            // Desktop Side-by-Side: CAD Canvas (Left 62%) + Hardware Inspector & Specs (Right 38%)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Interactive CAD Canvas & Switcher
                Expanded(
                  flex: 62,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mode Switcher & Zoom Toolbar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: widget.isDark ? const Color(0xFF161E16) : const Color(0xFFEDEAE0),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildToggleBtn(
                                  label: s.hwToggleBlueprint,
                                  icon: Icons.architecture,
                                  isSelected: !_showExploded,
                                  onTap: () => setState(() => _showExploded = false),
                                ),
                                const SizedBox(width: 4),
                                _buildToggleBtn(
                                  label: s.hwToggleExploded,
                                  icon: Icons.auto_awesome_motion,
                                  isSelected: _showExploded,
                                  onTap: () => setState(() => _showExploded = true),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _openFullscreen(activeImage, device.name, modeLabel),
                            icon: const Icon(Icons.zoom_in, size: 16),
                            label: Text(
                              s.hwZoomBtn,
                              style: const TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                              ),
                              foregroundColor: textPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Canvas Box
                      ScrapbookCard(
                        isDark: widget.isDark,
                        tag: "DWG: ${device.dwg}",
                        padding: EdgeInsets.zero,
                        child: GestureDetector(
                          onTap: () => _openFullscreen(activeImage, device.name, modeLabel),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.zoomIn,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D120D),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 240),
                                    child: Image.asset(
                                      activeImage,
                                      key: ValueKey<String>(activeImage),
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded || frame != null) return child;
                                        return Center(
                                          child: SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, _, _) => const Center(
                                        child: Icon(Icons.architecture, color: Colors.white24, size: 64),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        s.hwAiDisclaimer,
                        style: TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 10.5,
                          color: textSecondary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Right Column: Device Selector List & Deep Technical Inspector
                Expanded(
                  flex: 38,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Device Selector Vertical List
                      Text(
                        s.hwDeviceSelect,
                        style: TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(devices.length, (idx) {
                        final isSelected = idx == _selectedDevice;
                        final dev = devices[idx];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () => setState(() => _selectedDevice = idx),
                            borderRadius: BorderRadius.circular(8),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (widget.isDark ? const Color(0xFF1F2B1F) : const Color(0xFFE4DFCE))
                                    : (widget.isDark ? const Color(0xFF131813) : const Color(0xFFEDE8DD)),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? OryzaColors.burntOrange
                                      : (widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected ? OryzaColors.burntOrange : textSecondary.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dev.name,
                                          style: TextStyle(
                                            fontFamily: OryzaTypography.fontFamily,
                                            package: 'oryzaelo_ui',
                                            fontSize: 13.5,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                            color: isSelected ? textPrimary : textSecondary,
                                          ),
                                        ),
                                        Text(
                                          dev.role,
                                          style: TextStyle(
                                            fontFamily: OryzaTypography.fontFamily,
                                            package: 'oryzaelo_ui',
                                            fontSize: 11,
                                            color: isSelected
                                                ? (widget.isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange)
                                                : textSecondary.withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    dev.dwg,
                                    style: TextStyle(
                                      fontFamily: OryzaTypography.monoFontFamily,
                                      package: 'oryzaelo_ui',
                                      fontSize: 10,
                                      color: textSecondary.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),

                      // Selected Device Technical Inspector Card
                      ScrapbookCard(
                        isDark: widget.isDark,
                        tag: s.hwInspectorTitle,
                        accentColor: OryzaColors.burntOrange,
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${device.name} • ${device.role}",
                                    style: TextStyle(
                                      fontFamily: OryzaTypography.fontFamily,
                                      package: 'oryzaelo_ui',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: OryzaColors.burntOrange.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: OryzaColors.burntOrange.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    s.hwAiBadge,
                                    style: TextStyle(
                                      fontFamily: OryzaTypography.monoFontFamily,
                                      package: 'oryzaelo_ui',
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: OryzaColors.burntOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              device.desc,
                              style: TextStyle(
                                fontFamily: OryzaTypography.fontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 13,
                                height: 1.45,
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: widget.isDark ? const Color(0xFF101510) : const Color(0xFFEDE9DC),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.hwSpecLabel,
                                    style: TextStyle(
                                      fontFamily: OryzaTypography.monoFontFamily,
                                      package: 'oryzaelo_ui',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                      color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    device.specs,
                                    style: TextStyle(
                                      fontFamily: OryzaTypography.monoFontFamily,
                                      package: 'oryzaelo_ui',
                                      fontSize: 11.5,
                                      height: 1.4,
                                      fontWeight: FontWeight.w500,
                                      color: textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            // Mobile & Tablet Stacked View
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 10,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF161E16) : const Color(0xFFEDEAE0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleBtn(
                        label: s.hwToggleBlueprint,
                        icon: Icons.architecture,
                        isSelected: !_showExploded,
                        onTap: () => setState(() => _showExploded = false),
                      ),
                      const SizedBox(width: 4),
                      _buildToggleBtn(
                        label: s.hwToggleExploded,
                        icon: Icons.auto_awesome_motion,
                        isSelected: _showExploded,
                        onTap: () => setState(() => _showExploded = true),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _openFullscreen(activeImage, device.name, modeLabel),
                  icon: const Icon(Icons.zoom_in, size: 16),
                  label: Text(
                    s.hwZoomBtn,
                    style: const TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                    ),
                    foregroundColor: textPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ScrapbookCard(
              isDark: widget.isDark,
              tag: "DWG: ${device.dwg}",
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _openFullscreen(activeImage, device.name, modeLabel),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.zoomIn,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0D120D),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(
                              activeImage,
                              key: ValueKey<String>(activeImage),
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: widget.isDark ? const Color(0xFF161E16) : const Color(0xFFF5F3EB),
                      border: Border(
                        top: BorderSide(
                          color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                        ),
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${device.name} • ${device.role}",
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          device.desc,
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 13,
                            color: textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "${s.hwSpecLabel} ${device.specs}",
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToggleBtn({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (widget.isDark ? OryzaColors.burntOrange : OryzaColors.militaryGreen)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? Colors.white
                  : (widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
