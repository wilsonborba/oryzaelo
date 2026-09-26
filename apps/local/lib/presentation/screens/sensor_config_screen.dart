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
  String _protocol = 'LoRaWAN';

  @override
  void dispose() {
    _deviceIdCtrl.dispose();
    _deviceNameCtrl.dispose();
    super.dispose();
  }

  void _showAddSensorDialog() {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _deviceIdCtrl,
                  decoration: InputDecoration(
                    labelText: s.sensorIdLabel,
                    hintText: "ex: lora-node-station-01",
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _deviceNameCtrl,
                  decoration: InputDecoration(
                    labelText: s.sensorNameLabel,
                    hintText: "ex: Davis Vantage Pro2 Várzea",
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _protocol,
                  decoration: InputDecoration(labelText: s.sensorProtocolLabel),
                  items: const [
                    DropdownMenuItem(value: 'LoRaWAN', child: Text('LoRaWAN (US915 / AS923)')),
                    DropdownMenuItem(value: 'RS485/Modbus', child: Text('RS485 / Modbus RTU')),
                    DropdownMenuItem(value: 'MQTT', child: Text('MQTT / JSON Telemetry')),
                    DropdownMenuItem(value: 'Analog', child: Text('Analógico 4-20mA / 0-5V')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => _protocol = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(s.cancelBtn),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_deviceIdCtrl.text.isEmpty) return;

                final mapping = DeviceMapping(
                  id: _deviceIdCtrl.text.trim(),
                  name: _deviceNameCtrl.text.trim().isEmpty
                      ? _deviceIdCtrl.text.trim()
                      : _deviceNameCtrl.text.trim(),
                  manufacturer: _protocol,
                  model: 'Custom_Edge_Driver',
                  description: 'Custom sensor mapping configured via dashboard',
                  mappings: [
                    const MappingEntry(columnName: 't_max', targetMetric: 'temperature_max', unit: 'celsius'),
                    const MappingEntry(columnName: 't_min', targetMetric: 'temperature_min', unit: 'celsius'),
                    const MappingEntry(columnName: 'water_level', targetMetric: 'hydrostatic_depth', unit: 'cm'),
                  ],
                );

                Navigator.of(ctx).pop();
                final ok = await widget.handler.saveCustomMapping(mapping);
                if (mounted && ok) {
                  _deviceIdCtrl.clear();
                  _deviceNameCtrl.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mapeamento de sensor salvo com sucesso.")),
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
              const Icon(Icons.hub_rounded, size: 18, color: OryzaColors.burntOrange),
              const SizedBox(width: 8),
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
                "${mappings.length} ativos",
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
                  "Nenhum sensor customizado registrado no nó de borda.",
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
                    const Icon(Icons.sensors, size: 18, color: OryzaColors.botanicalGreen),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.name,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          Text(
                            "ID: ${m.id} • Protocolo: ${m.manufacturer}",
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
              const Icon(Icons.bookmark_border_rounded, size: 18, color: OryzaColors.mustardYellow),
              const SizedBox(width: 8),
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
              return Container(
                width: 280,
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
                        Text(
                          p.manufacturer,
                          style: const TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: OryzaColors.burntOrange,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: OryzaColors.botanicalGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "OFICIAL",
                            style: TextStyle(
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
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Modelo: ${p.model}",
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
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
}
