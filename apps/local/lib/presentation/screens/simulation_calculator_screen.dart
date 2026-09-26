import 'package:flutter/material.dart';
import 'package:local/domain/models/simulation_result.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:local/presentation/widgets/parcel_selector_bar.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class SimulationCalculatorScreen extends StatefulWidget {
  final DashboardHandler handler;
  final VoidCallback onNavigateToData;

  const SimulationCalculatorScreen({
    super.key,
    required this.handler,
    required this.onNavigateToData,
  });

  @override
  State<SimulationCalculatorScreen> createState() =>
      _SimulationCalculatorScreenState();
}

/// The only 4 cultivars this simulator actually models -- must match the
/// dropdown's item list exactly, since DropdownButton asserts its `value`
/// matches exactly one item.
const _supportedCultivars = [
  'BRS Querência',
  'IR64',
  'Hom Mali (Jasmine)',
  'Epagri 109',
];

class _SimulationCalculatorScreenState
    extends State<SimulationCalculatorScreen> {
  String _cultivar = 'BRS Querência';
  double _das = 42;
  double _tempMin = 19.5;
  double _tempMax = 31.0;
  double _waterDepth = 7.5;
  double _humidity = 72.0;
  double _radiation = 18.5;
  double _rain = 2.0;

  SimulationResult? _simulationResult;
  bool _hasInitializedFromParcel = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFromParcel();
  }

  void _initializeFromParcel() {
    final parcel = widget.handler.selectedParcel;
    final records = widget.handler.weatherRecords;

    if (parcel != null && !_hasInitializedFromParcel) {
      _hasInitializedFromParcel = true;
      // The simulator only models 4 fixed cultivars -- a real parcel's
      // variety (often a Thai-script name, or free text the farmer typed
      // when registering the parcel) is very unlikely to be one of them.
      // Blindly assigning it used to crash this whole screen (DropdownButton
      // asserts its value must match exactly one item).
      if (_supportedCultivars.contains(parcel.riceVariety)) {
        _cultivar = parcel.riceVariety;
      }
      final now = DateTime.now();
      final diff = now.difference(parcel.sowingDate).inDays;
      if (diff > 0 && diff <= 150) {
        _das = diff.toDouble();
      }

      final completeRecords = records.where((r) => r.isComplete);
      if (completeRecords.isNotEmpty) {
        final latest = completeRecords.last;
        _tempMin = latest.tMin!;
        _tempMax = latest.tMax!;
        _humidity = latest.relativeHumidityPct!;
        _radiation = latest.radiationMjM2!;
        _rain = latest.precipitationMm!;
      }
    }
  }

  Future<void> _runSimulation() async {
    final controller = OryzaScope.of(context);
    final locale = controller.locale.languageCode;

    final res = await widget.handler.runSimulation(
      cultivar: _cultivar,
      das: _das,
      tMin: _tempMin,
      tMax: _tempMax,
      waterDepthCm: _waterDepth,
      relativeHumidityPct: _humidity,
      precipitationMm: _rain,
      radiationMjM2: _radiation,
      locale: locale,
    );

    if (mounted && res != null) {
      setState(() {
        _simulationResult = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final records = widget.handler.weatherRecords;
    final parcel = widget.handler.selectedParcel;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Parcel Selector Toolbar
              ParcelSelectorBar(handler: widget.handler),
              const SizedBox(height: 16),

              // If parcel has no data, show rich Figma empty state
              if (parcel == null || records.isEmpty)
                _buildEmptyState(context, isDark, s)
              else
                _buildSimulatorContent(context, isDark, s),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, OryzaStrings s) {
    final surfaceColor = isDark
        ? OryzaColors.darkSurface
        : OryzaColors.lightSurface;
    final borderColor = isDark
        ? OryzaColors.darkBorder
        : OryzaColors.lightBorder;
    final textSecondary = isDark
        ? OryzaColors.darkTextSecondary
        : OryzaColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            offset: const Offset(3, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/plants/Jungle_Plant_1.png',
                    width: 180,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                Image.asset(
                  'assets/icons3d/calculator-dynamic-color.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              s.simEmptyTitle,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? OryzaColors.darkTextPrimary
                    : OryzaColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Text(
                s.simEmptyDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 13,
                  height: 1.45,
                  color: textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: widget.onNavigateToData,
              icon: const Icon(Icons.upload_file_rounded, size: 18),
              label: Text(
                s.simEmptyBtn,
                style: const TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: OryzaColors.burntOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatorContent(
    BuildContext context,
    bool isDark,
    OryzaStrings s,
  ) {
    final surfaceColor = isDark
        ? OryzaColors.darkSurface
        : OryzaColors.lightSurface;
    final borderColor = isDark
        ? OryzaColors.darkBorder
        : OryzaColors.lightBorder;
    final textColor = isDark
        ? OryzaColors.darkTextPrimary
        : OryzaColors.lightTextPrimary;
    final textSecondary = isDark
        ? OryzaColors.darkTextSecondary
        : OryzaColors.lightTextSecondary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    offset: const Offset(3, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons3d/calculator-dynamic-color.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.simTitle.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          s.simSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: OryzaColors.burntOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: OryzaColors.burntOrange.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      s.simOnnxBadge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: OryzaTypography.monoFontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: OryzaColors.burntOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Controls & Results (Responsive 2-column or stacked)
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildInputPanel(context, isDark, s),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 6,
                    child: _buildOutputPanel(context, isDark, s),
                  ),
                ],
              )
            else ...[
              _buildInputPanel(context, isDark, s),
              const SizedBox(height: 16),
              _buildOutputPanel(context, isDark, s),
            ],
          ],
        );
      },
    );
  }

  Widget _buildInputPanel(BuildContext context, bool isDark, OryzaStrings s) {
    final surfaceColor = isDark
        ? OryzaColors.darkSurface
        : OryzaColors.lightSurface;
    final borderColor = isDark
        ? OryzaColors.darkBorder
        : OryzaColors.lightBorder;
    final textColor = isDark
        ? OryzaColors.darkTextPrimary
        : OryzaColors.lightTextPrimary;
    final textSecondary = isDark
        ? OryzaColors.darkTextSecondary
        : OryzaColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            offset: const Offset(2, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tune_rounded,
                size: 18,
                color: OryzaColors.burntOrange,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  s.simBaselineHeader.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cultivar Dropdown
          Text(
            s.simCultivarLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? OryzaColors.darkCanvas : const Color(0xFFF9F8F4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _cultivar,
                isExpanded: true,
                dropdownColor: surfaceColor,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'BRS Querência',
                    child: Text(s.simCultivarOptionBrs),
                  ),
                  DropdownMenuItem(
                    value: 'IR64',
                    child: Text(s.simCultivarOptionIr64),
                  ),
                  DropdownMenuItem(
                    value: 'Hom Mali (Jasmine)',
                    child: Text(s.simCultivarOptionJasmine),
                  ),
                  DropdownMenuItem(
                    value: 'Epagri 109',
                    child: Text(s.simCultivarOptionEpagri),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _cultivar = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // DAS Slider
          _buildSliderField(
            label: s.simDasLabel,
            valueDisplay: "${_das.toInt()} ${s.simDasUnit}",
            value: _das,
            min: 5,
            max: 120,
            divisions: 115,
            color: OryzaColors.burntOrange,
            isDark: isDark,
            onChanged: (v) => setState(() => _das = v),
          ),

          // T_min Slider
          _buildSliderField(
            label: s.simTminLabel,
            valueDisplay: "${_tempMin.toStringAsFixed(1)} °C",
            value: _tempMin,
            min: 8,
            max: 26,
            divisions: 36,
            color: OryzaColors.botanicalGreen,
            isDark: isDark,
            onChanged: (v) => setState(() => _tempMin = v),
          ),

          // T_max Slider
          _buildSliderField(
            label: s.simTmaxLabel,
            valueDisplay: "${_tempMax.toStringAsFixed(1)} °C",
            value: _tempMax,
            min: 22,
            max: 42,
            divisions: 40,
            color: OryzaColors.burntOrange,
            isDark: isDark,
            onChanged: (v) => setState(() => _tempMax = v),
          ),

          // Water Depth Slider
          _buildSliderField(
            label: s.simWaterDepthLabel,
            valueDisplay: "${_waterDepth.toStringAsFixed(1)} cm",
            value: _waterDepth,
            min: 0,
            max: 20,
            divisions: 40,
            // Mustard yellow reads fine on the dark canvas but is too low-
            // contrast for small bold text on a white/light background.
            color: isDark ? OryzaColors.mustardYellow : Colors.amber.shade900,
            isDark: isDark,
            onChanged: (v) => setState(() => _waterDepth = v),
          ),

          // Relative Humidity Slider
          _buildSliderField(
            label: s.simHumidityLabel,
            valueDisplay: "${_humidity.toInt()} %",
            value: _humidity,
            min: 20,
            max: 100,
            divisions: 80,
            color: Colors.blueAccent,
            isDark: isDark,
            onChanged: (v) => setState(() => _humidity = v),
          ),

          const SizedBox(height: 10),

          // Apply Button
          ElevatedButton.icon(
            onPressed: widget.handler.isAnalyzing ? null : _runSimulation,
            icon: widget.handler.isAnalyzing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.play_arrow_rounded, size: 20),
            label: Text(
              widget.handler.isAnalyzing
                  ? s.simRunningLabel
                  : s.simApplyBtn.toUpperCase(),
              style: const TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: OryzaColors.burntOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderField({
    required String label,
    required String valueDisplay,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Color color,
    required bool isDark,
    required ValueChanged<double> onChanged,
  }) {
    final textSecondary = isDark
        ? OryzaColors.darkTextSecondary
        : OryzaColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 11.5, color: textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                valueDisplay,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            activeColor: color,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildOutputPanel(BuildContext context, bool isDark, OryzaStrings s) {
    final surfaceColor = isDark
        ? OryzaColors.darkSurface
        : OryzaColors.lightSurface;
    final borderColor = isDark
        ? OryzaColors.darkBorder
        : OryzaColors.lightBorder;
    final textColor = isDark
        ? OryzaColors.darkTextPrimary
        : OryzaColors.lightTextPrimary;
    final textSecondary = isDark
        ? OryzaColors.darkTextSecondary
        : OryzaColors.lightTextSecondary;

    if (_simulationResult == null) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons3d/target-dynamic-color.png',
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                s.simWaitingTitle,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  s.simWaitingBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final res = _simulationResult!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: OryzaColors.burntOrange.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            offset: const Offset(3, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge Row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: OryzaColors.burntOrange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  res.bbchCode,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "${s.simGddAccumulatedLabel}: ${res.accumulatedGdd.toStringAsFixed(1)} ${s.simGddDayUnit}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? OryzaColors.mustardYellow
                      : OryzaColors.botanicalGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stage Name
          Text(
            res.stageName,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),

          // Advisory
          Text(
            res.advisory,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 13,
              height: 1.4,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          const Divider(height: 1),
          const SizedBox(height: 14),

          // Combinatorial Actionable Insights List
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 16,
                color: isDark
                    ? OryzaColors.mustardYellow
                    : Colors.brown.shade800,
              ),
              const SizedBox(width: 8),
              Text(
                s.simInsightsTitle.toUpperCase(),
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: isDark
                      ? OryzaColors.mustardYellow
                      : Colors.brown.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ...res.recommendations.map(
            (rec) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: OryzaColors.burntOrange,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rec,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 12,
                        height: 1.4,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
