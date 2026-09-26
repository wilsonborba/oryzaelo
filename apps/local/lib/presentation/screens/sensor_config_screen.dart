import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/metric_type.dart';
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

/// Per-metric column/unit/scale text controllers, live only while its
/// checkbox is selected in the add/edit dialog.
class _MetricFieldControllers {
  final colCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final scaleCtrl = TextEditingController(text: '1.0');

  void applyFrom(MetricColumnMapping? m, MetricType type) {
    colCtrl.text = m?.columnName ?? '';
    unitCtrl.text = m?.unit ?? type.canonicalUnit;
    scaleCtrl.text = (m?.scale ?? 1.0).toString();
  }

  MetricColumnMapping toMapping(MetricType type) {
    return MetricColumnMapping(
      metricType: type,
      columnName: colCtrl.text.trim(),
      unit: unitCtrl.text.trim(),
      scale: double.tryParse(scaleCtrl.text) ?? 1.0,
    );
  }

  void dispose() {
    colCtrl.dispose();
    unitCtrl.dispose();
    scaleCtrl.dispose();
  }
}

class _SensorConfigScreenState extends State<SensorConfigScreen> {
  final _deviceIdCtrl = TextEditingController();
  final _deviceNameCtrl = TextEditingController();
  final _dateColCtrl = TextEditingController();
  final _dateFormatCtrl = TextEditingController(text: 'yyyy-MM-dd');

  final Map<MetricType, _MetricFieldControllers> _metricCtrls = {
    for (final t in MetricType.values) t: _MetricFieldControllers(),
  };
  final Set<MetricType> _selectedMetrics = {};

  @override
  void dispose() {
    _deviceIdCtrl.dispose();
    _deviceNameCtrl.dispose();
    _dateColCtrl.dispose();
    _dateFormatCtrl.dispose();
    for (final c in _metricCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _metricLabel(MetricType type, OryzaStrings s) {
    switch (type) {
      case MetricType.tMax:
        return s.tableColTmax;
      case MetricType.tMin:
        return s.tableColTmin;
      case MetricType.rainfall:
        return s.tableColRain;
      case MetricType.radiation:
        return s.tableColRad;
      case MetricType.humidity:
        return s.tableColRh;
    }
  }

  void _applyBase(DeviceMapping? base) {
    _dateColCtrl.text = base?.dateCol ?? '';
    _dateFormatCtrl.text = base?.dateFormat ?? 'yyyy-MM-dd';
    _selectedMetrics
      ..clear()
      ..addAll(base?.metricTypes() ?? []);
    for (final type in MetricType.values) {
      _metricCtrls[type]!.applyFrom(base?.metric(type), type);
    }
  }

  /// Opens the add/edit dialog. `existing` is null when registering a brand
  /// new sensor; when editing, the dialog is pre-filled and the id field is
  /// locked (the backend id is the primary key).
  void _showSensorDialog({DeviceMapping? existing}) {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final presets = widget.handler.devicePresets;
    final isEditing = existing != null;

    _deviceIdCtrl.text = existing?.id ?? '';
    _deviceNameCtrl.text = existing?.deviceName ?? '';
    _applyBase(existing);
    String? baseId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            isEditing ? s.sensorEditMappingTitle : s.sensorNewMappingBtn,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: math.min(520, MediaQuery.of(context).size.width * 0.9),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isEditing) ...[
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
                          final base = val == null ? null : presets.firstWhere((p) => p.id == val);
                          _deviceNameCtrl.text = base?.deviceName ?? '';
                          _applyBase(base);
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextField(
                    controller: _deviceIdCtrl,
                    enabled: !isEditing,
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
                  const SizedBox(height: 16),
                  Text(
                    s.sensorMetricsPickLabel,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    s.sensorMetricsPickHint,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: MetricType.values.map((type) {
                      final selected = _selectedMetrics.contains(type);
                      return FilterChip(
                        label: Text(_metricLabel(type, s)),
                        selected: selected,
                        onSelected: (val) {
                          setDialogState(() {
                            if (val) {
                              _selectedMetrics.add(type);
                            } else {
                              _selectedMetrics.remove(type);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  ...MetricType.values.where((t) => _selectedMetrics.contains(t)).map(
                        (type) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _variableMappingRow(
                            _metricLabel(type, s),
                            _metricCtrls[type]!.colCtrl,
                            _metricCtrls[type]!.unitCtrl,
                            _metricCtrls[type]!.scaleCtrl,
                            s,
                          ),
                        ),
                      ),
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
                if (_deviceIdCtrl.text.trim().isEmpty || _selectedMetrics.isEmpty) return;

                final mapping = DeviceMapping(
                  id: _deviceIdCtrl.text.trim(),
                  deviceName: _deviceNameCtrl.text.trim().isEmpty
                      ? _deviceIdCtrl.text.trim()
                      : _deviceNameCtrl.text.trim(),
                  manufacturer: existing?.manufacturer ?? 'Custom',
                  isPreset: false,
                  dateCol: _dateColCtrl.text.trim(),
                  dateFormat: _dateFormatCtrl.text.trim(),
                  metrics: _selectedMetrics.map((t) => _metricCtrls[t]!.toMapping(t)).toList(),
                  createdAt: existing?.createdAt ?? DateTime.now(),
                );

                Navigator.of(ctx).pop();
                final ok = await widget.handler.saveCustomMapping(mapping);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok ? s.sensorSavedSuccess : s.sensorSaveFailedMsg),
                      backgroundColor: ok ? Colors.green.shade800 : Colors.red.shade800,
                    ),
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

  void _confirmDelete(DeviceMapping mapping) {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(s.sensorDeleteConfirmTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(s.sensorDeleteConfirmBody.replaceAll('{name}', mapping.deviceName)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(s.cancelBtn)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final ok = await widget.handler.deleteCustomMapping(mapping.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok ? s.sensorDeletedSuccess : s.sensorDeleteFailedMsg),
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

  /// Full CRUD over one metric's own raw reading history for the currently
  /// selected parcel: list what this specific sensor has reported, and
  /// delete an individual bad reading (the day's aggregate is recomputed
  /// automatically afterward).
  void _showReadingsDialog(MetricType metricType) {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          void reload() => setDialogState(() {});

          return AlertDialog(
            backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              s.sensorReadingsHistoryTitle.replaceAll('{metric}', _metricLabel(metricType, s)),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: math.min(420, MediaQuery.of(context).size.width * 0.86),
              height: 360,
              child: FutureBuilder(
                future: widget.handler.fetchSensorReadings(metricType),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final readings = snapshot.data ?? [];
                  if (readings.isEmpty) {
                    return Center(child: Text(s.sensorReadingsEmpty));
                  }
                  return ListView.separated(
                    itemCount: readings.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final r = readings[i];
                      return ListTile(
                        dense: true,
                        title: Text(
                          '${r.value.toStringAsFixed(2)} ${metricType.canonicalUnit}',
                          style: const TextStyle(fontFamily: 'Ubuntu Sans Mono', fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          '${DateFormat('yyyy-MM-dd HH:mm').format(r.recordedAt)} • ${r.sensorId}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                          onPressed: () async {
                            final ok = await widget.handler.deleteSensorReading(id: r.id, metricType: metricType);
                            if (ok) reload();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              ElevatedButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(s.sensorReadingsCloseBtn)),
            ],
          );
        },
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
    final unitField = TextField(
      controller: unitCtrl,
      decoration: InputDecoration(labelText: s.sensorUnitLabel, isDense: true),
    );
    final scaleField = TextField(
      controller: scaleCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: s.sensorScaleLabel, isDense: true),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Below ~340px, three squeezed text fields become too narrow to use
        // (floating labels clip). Stack "column" on its own row and pair
        // unit/scale on a second row instead.
        if (constraints.maxWidth < 340) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              TextField(
                controller: colCtrl,
                decoration: InputDecoration(labelText: s.sensorColumnLabel, isDense: true),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: unitField),
                  const SizedBox(width: 8),
                  Expanded(child: scaleField),
                ],
              ),
            ],
          );
        }

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
            Expanded(flex: 2, child: unitField),
            const SizedBox(width: 6),
            Expanded(flex: 2, child: scaleField),
          ],
        );
      },
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
      child: Wrap(
        spacing: 14,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons3d/sheild-dynamic-color.png',
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.sensorConfigTitle.toUpperCase(),
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
                      s.sensorConfigSubtitle,
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
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => _showSensorDialog(),
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
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

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
                    color: textSecondary,
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
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: m.metrics
                                .map(
                                  (metric) => InkWell(
                                    borderRadius: BorderRadius.circular(4),
                                    onTap: () => _showReadingsDialog(metric.metricType),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: OryzaColors.botanicalGreen.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _metricLabel(metric.metricType, s),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Ubuntu Sans Mono',
                                          color: OryzaColors.botanicalGreen,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: s.sensorEditMappingTitle,
                      onPressed: () => _showSensorDialog(existing: m),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(m),
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

          LayoutBuilder(
            builder: (context, constraints) {
              // Cap the card at 320px on wide screens, but never wider than
              // the available space — a fixed 320px card doesn't fit inside
              // a ~288px content area on the smallest (320px) phones.
              final cardWidth = math.min(320.0, constraints.maxWidth);

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: presets.map((p) {
                  final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;
                  return Container(
                    width: cardWidth,
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
                            children: p.metrics
                                .map(
                                  (m) => _presetVariableRow(
                                    _metricLabel(m.metricType, s),
                                    m.columnName,
                                    m.unit,
                                    m.scale,
                                    textSecondary,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
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
