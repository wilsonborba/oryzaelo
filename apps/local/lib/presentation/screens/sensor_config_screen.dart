import 'package:flutter/material.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:local/presentation/widgets/parcel_selector_bar.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class SensorConfigScreen extends StatefulWidget {
  final DashboardHandler handler;

  const SensorConfigScreen({
    super.key,
    required this.handler,
  });

  @override
  State<SensorConfigScreen> createState() => _SensorConfigScreenState();
}

class _SensorConfigScreenState extends State<SensorConfigScreen> {
  final _deviceIdCtrl = TextEditingController();
  final _deviceNameCtrl = TextEditingController();
  final _dateColCtrl = TextEditingController();
  final _dateFormatCtrl = TextEditingController(text: 'yyyy-MM-dd');

  final _tMaxColCtrl = TextEditingController();
  final _tMaxUnitCtrl = TextEditingController(text: 'C');
  final _tMaxScaleCtrl = TextEditingController(text: '1.0');

  final _tMinColCtrl = TextEditingController();
  final _tMinUnitCtrl = TextEditingController(text: 'C');
  final _tMinScaleCtrl = TextEditingController(text: '1.0');

  final _rainColCtrl = TextEditingController();
  final _rainUnitCtrl = TextEditingController(text: 'mm');
  final _rainScaleCtrl = TextEditingController(text: '1.0');

  final _radColCtrl = TextEditingController();
  final _radUnitCtrl = TextEditingController(text: 'MJ/m2');
  final _radScaleCtrl = TextEditingController(text: '1.0');

  final _rhColCtrl = TextEditingController();
  final _rhUnitCtrl = TextEditingController(text: '%');
  final _rhScaleCtrl = TextEditingController(text: '1.0');

  @override
  void dispose() {
    for (final c in [
      _deviceIdCtrl, _deviceNameCtrl, _dateColCtrl, _dateFormatCtrl,
      _tMaxColCtrl, _tMaxUnitCtrl, _tMaxScaleCtrl,
      _tMinColCtrl, _tMinUnitCtrl, _tMinScaleCtrl,
      _rainColCtrl, _rainUnitCtrl, _rainScaleCtrl,
      _radColCtrl, _radUnitCtrl, _radScaleCtrl,
      _rhColCtrl, _rhUnitCtrl, _rhScaleCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _applyBase(DeviceMapping? base) {
    _dateColCtrl.text = base?.dateCol ?? '';
    _dateFormatCtrl.text = base?.dateFormat ?? 'yyyy-MM-dd';
    _tMaxColCtrl.text = base?.tMaxCol ?? '';
    _tMaxUnitCtrl.text = base?.tMaxUnit ?? 'C';
    _tMaxScaleCtrl.text = (base?.tMaxScale ?? 1.0).toString();
    _tMinColCtrl.text = base?.tMinCol ?? '';
    _tMinUnitCtrl.text = base?.tMinUnit ?? 'C';
    _tMinScaleCtrl.text = (base?.tMinScale ?? 1.0).toString();
    _rainColCtrl.text = base?.rainCol ?? '';
    _rainUnitCtrl.text = base?.rainUnit ?? 'mm';
    _rainScaleCtrl.text = (base?.rainScale ?? 1.0).toString();
    _radColCtrl.text = base?.radCol ?? '';
    _radUnitCtrl.text = base?.radUnit ?? 'MJ/m2';
    _radScaleCtrl.text = (base?.radScale ?? 1.0).toString();
    _rhColCtrl.text = base?.rhCol ?? '';
    _rhUnitCtrl.text = base?.rhUnit ?? '%';
    _rhScaleCtrl.text = (base?.rhScale ?? 1.0).toString();
  }

  void _showAddSensorDialog() {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final presets = widget.handler.devicePresets;

    _deviceIdCtrl.clear();
    _deviceNameCtrl.clear();
    _applyBase(null);
    String? baseId; // null == "Outro / Custom" (blank slate)

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            s.sensorNewMappingBtn,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.sensorBaseLabel,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String?>(
                    initialValue: baseId,
                    decoration: const InputDecoration(isDense: true),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(s.sensorBaseCustomOption),
                      ),
                      ...presets.map(
                        (p) => DropdownMenuItem<String?>(
                          value: p.id,
                          child: Text(p.deviceName, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setDialogState(() {
                        baseId = val;
                        final base = val == null
                            ? null
                            : presets.firstWhere((p) => p.id == val);
                        _applyBase(base);
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _deviceIdCtrl,
                    decoration: InputDecoration(
                      labelText: s.sensorIdLabel,
                      hintText: s.sensorIdHint,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _deviceNameCtrl,
                    decoration: InputDecoration(
                      labelText: s.sensorNameLabel,
                      hintText: s.sensorNameHint,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _dateColCtrl,
                          decoration: InputDecoration(labelText: s.sensorDateColLabel),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _dateFormatCtrl,
                          decoration: InputDecoration(labelText: s.sensorDateFormatLabel),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _variableMappingRow(s.tableColTmax, _tMaxColCtrl, _tMaxUnitCtrl, _tMaxScaleCtrl, s),
                  const SizedBox(height: 8),
                  _variableMappingRow(s.tableColTmin, _tMinColCtrl, _tMinUnitCtrl, _tMinScaleCtrl, s),
                  const SizedBox(height: 8),
                  _variableMappingRow(s.tableColRain, _rainColCtrl, _rainUnitCtrl, _rainScaleCtrl, s),
                  const SizedBox(height: 8),
                  _variableMappingRow(s.tableColRad, _radColCtrl, _radUnitCtrl, _radScaleCtrl, s),
                  const SizedBox(height: 8),
                  _variableMappingRow(s.tableColRh, _rhColCtrl, _rhUnitCtrl, _rhScaleCtrl, s),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(s.cancelBtn),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_deviceIdCtrl.text.trim().isEmpty) return;

                final mapping = DeviceMapping(
                  id: _deviceIdCtrl.text.trim(),
                  deviceName: _deviceNameCtrl.text.trim().isEmpty
                      ? _deviceIdCtrl.text.trim()
                      : _deviceNameCtrl.text.trim(),
                  manufacturer: 'Custom',
                  isPreset: false,
                  dateCol: _dateColCtrl.text.trim(),
                  dateFormat: _dateFormatCtrl.text.trim(),
                  tMaxCol: _tMaxColCtrl.text.trim(),
                  tMaxUnit: _tMaxUnitCtrl.text.trim(),
                  tMaxScale: double.tryParse(_tMaxScaleCtrl.text) ?? 1.0,
                  tMinCol: _tMinColCtrl.text.trim(),
                  tMinUnit: _tMinUnitCtrl.text.trim(),
                  tMinScale: double.tryParse(_tMinScaleCtrl.text) ?? 1.0,
                  rainCol: _rainColCtrl.text.trim(),
                  rainUnit: _rainUnitCtrl.text.trim(),
                  rainScale: double.tryParse(_rainScaleCtrl.text) ?? 1.0,
                  radCol: _radColCtrl.text.trim(),
                  radUnit: _radUnitCtrl.text.trim(),
                  radScale: double.tryParse(_radScaleCtrl.text) ?? 1.0,
                  rhCol: _rhColCtrl.text.trim(),
                  rhUnit: _rhUnitCtrl.text.trim(),
                  rhScale: double.tryParse(_rhScaleCtrl.text) ?? 1.0,
                  createdAt: DateTime.now(),
                );

                Navigator.of(ctx).pop();
                final ok = await widget.handler.saveCustomMapping(mapping);
                if (mounted && ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.sensorSavedSuccess)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: OryzaColors.burntOrange,
                foregroundColor: Colors.white,
              ),
              child: Text(s.sensorSaveBtn),
            ),
          ],
        ),
      ),
    );
  }

  Widget _variableMappingRow(
    String label,
    TextEditingController colCtrl,
    TextEditingController unitCtrl,
    TextEditingController scaleCtrl,
    OryzaStrings s,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            controller: colCtrl,
            decoration: InputDecoration(labelText: s.sensorColumnLabel, isDense: true),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 2,
          child: TextField(
            controller: unitCtrl,
            decoration: InputDecoration(labelText: s.sensorUnitLabel, isDense: true),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 2,
          child: TextField(
            controller: scaleCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: s.sensorScaleLabel, isDense: true),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final presets = widget.handler.devicePresets;
    final customMappings = widget.handler.customMappings;

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

              // Screen Header Banner
              _buildHeaderBanner(context, isDark, s),
              const SizedBox(height: 20),

              // Active Custom Mappings
              _buildCustomMappingsSection(context, isDark, s, customMappings),
              const SizedBox(height: 20),

              // Manufacturer Presets
              _buildPresetsSection(context, isDark, s, presets),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context, bool isDark, OryzaStrings s) {
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return Container(
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
            'assets/icons3d/sheild-dynamic-color.png',
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
                  s.sensorConfigTitle.toUpperCase(),
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
                  s.sensorConfigSubtitle,
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
          ElevatedButton.icon(
            onPressed: _showAddSensorDialog,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: Text(
              s.sensorNewMappingBtn,
              style: const TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: OryzaColors.burntOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMappingsSection(
    BuildContext context,
    bool isDark,
    OryzaStrings s,
    List<DeviceMapping> mappings,
  ) {
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                s.sensorMappingsTitle.toUpperCase(),
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                s.sensorActiveCount.replaceAll('{count}', '${mappings.length}'),
                style: const TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: OryzaColors.burntOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (mappings.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  s.sensorNoCustomMappings,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12,
                    color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                  ),
                ),
              ),
            )
          else
            ...mappings.map(
              (m) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? OryzaColors.darkCanvas : const Color(0xFFF9F8F4),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.deviceName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          Text(
                            "ID: ${m.id} • ${s.sensorProtocolLabel}: ${m.manufacturer}",
                            style: const TextStyle(fontSize: 11, fontFamily: 'Ubuntu Sans Mono'),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                      onPressed: () => widget.handler.deleteCustomMapping(m.id),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPresetsSection(
    BuildContext context,
    bool isDark,
    OryzaStrings s,
    List<DeviceMapping> presets,
  ) {
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                s.sensorPresetsTitle.toUpperCase(),
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: presets.map((p) {
              final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;
              return Container(
                width: 320,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? OryzaColors.darkCanvas : const Color(0xFFF9F8F4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            p.manufacturer,
                            style: const TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: OryzaColors.burntOrange,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: OryzaColors.botanicalGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            s.sensorOfficialBadge,
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Ubuntu Sans Mono',
                              color: OryzaColors.botanicalGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.deviceName,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${s.tableColDate}: ${p.dateCol} (${p.dateFormat})",
                      style: TextStyle(fontSize: 10.5, color: textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black26 : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: borderColor.withValues(alpha: 0.6)),
                      ),
                      child: Column(
                        children: [
                          _presetVariableRow(s.tableColTmax, p.tMaxCol, p.tMaxUnit, p.tMaxScale, textSecondary),
                          _presetVariableRow(s.tableColTmin, p.tMinCol, p.tMinUnit, p.tMinScale, textSecondary),
                          _presetVariableRow(s.tableColRain, p.rainCol, p.rainUnit, p.rainScale, textSecondary),
                          _presetVariableRow(s.tableColRad, p.radCol, p.radUnit, p.radScale, textSecondary),
                          _presetVariableRow(s.tableColRh, p.rhCol, p.rhUnit, p.rhScale, textSecondary),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// One row of a preset's raw-column mapping spec sheet: which source column
  /// feeds this canonical variable, its declared unit, and the scale
  /// multiplier applied on ingest (real `DeviceMapping` fields, not
  /// fabricated) — e.g. Dragino/Renke's non-1.0 scale factors are otherwise
  /// invisible to whoever is wiring up the hardware.
  Widget _presetVariableRow(String label, String col, String unit, double scale, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Ubuntu Sans Mono',
                color: textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              col,
              style: const TextStyle(
                fontSize: 9.5,
                fontFamily: 'Ubuntu Sans Mono',
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              unit,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 9.5, fontFamily: 'Ubuntu Sans Mono', color: textSecondary),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '×${scale.toStringAsFixed(scale == scale.roundToDouble() ? 0 : 2)}',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 9.5, fontFamily: 'Ubuntu Sans Mono', color: textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
