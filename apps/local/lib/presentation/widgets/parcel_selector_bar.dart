import 'package:flutter/material.dart';
import 'package:local/domain/models/parcel.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Active parcel switcher and management toolbar (CRUD for Parcels).
class ParcelSelectorBar extends StatelessWidget {
  final DashboardHandler handler;

  const ParcelSelectorBar({
    super.key,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selected = handler.selectedParcel;
    final s = OryzaI18n.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ScrapbookCard(
        isDark: isDark,
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  s.parcelActiveLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    fontFamily: 'Ubuntu Sans Mono',
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                // Parcel Actions
                if (selected != null) ...[
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    tooltip: s.parcelEditTooltip,
                    onPressed: () => _showEditParcelDialog(context, selected, s),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    tooltip: s.parcelDeleteTooltip,
                    onPressed: () => _confirmDeleteParcel(context, selected, s),
                  ),
                  const SizedBox(width: 8),
                ],
                if (handler.parcels.isEmpty) ...[
                  OutlinedButton.icon(
                    onPressed: handler.isOperatingMock
                        ? null
                        : () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(s.demoDataLoading)),
                            );
                            final ok = await handler.populateMockData();
                            if (context.mounted && ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(s.demoDataLoadedSuccess),
                                  backgroundColor: Colors.green.shade800,
                                ),
                              );
                            }
                          },
                    icon: const Icon(Icons.cloud_download_outlined, size: 16),
                    label: Text(s.loadDemoDataBtn),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                      side: BorderSide(color: isDark ? Colors.amber.shade700 : Colors.amber.shade500),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton.icon(
                  onPressed: () => _showCreateParcelDialog(context, s),
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(s.parcelNewBtn),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.green.shade800 : Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Parcel Selection Dropdown & Metadata Bar
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 700;

                return Wrap(
                  spacing: 16,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black26 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selected?.id,
                          hint: Text(s.parcelSelectHint),
                          isDense: true,
                          items: handler.parcels.map((p) {
                            return DropdownMenuItem<String>(
                              value: p.id,
                              child: Text(
                                '${p.name} (${p.riceVariety})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Ubuntu Sans',
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (id) {
                            if (id != null) {
                              final p = handler.parcels.firstWhere((e) => e.id == id);
                              handler.selectParcel(p);
                            }
                          },
                        ),
                      ),
                    ),

                    if (selected != null) ...[
                      // Cultivar Badge
                      _buildMetricChip(
                        isDark: isDark,
                        label: s.parcelVarietalLabel,
                        value: selected.riceVariety,
                      ),
                      // Ecosystem Badge
                      _buildMetricChip(
                        isDark: isDark,
                        label: s.parcelEcosystemLabel,
                        value: selected.riceEcosystem,
                      ),
                      // Area Badge
                      _buildMetricChip(
                        isDark: isDark,
                        label: s.parcelAreaLabel,
                        value: '${selected.areaHectares} ha',
                      ),
                      // DAE Badge
                      _buildMetricChip(
                        isDark: isDark,
                        label: s.parcelAgeLabel,
                        value: '${selected.daysAfterSowing} ${s.settingsDaysUnit}',
                        highlight: true,
                      ),
                      if (!isCompact) ...[
                        // GPS Badge
                        _buildMetricChip(
                          isDark: isDark,
                          label: s.parcelCoordsLabel,
                          value:
                              '${selected.latitude.toStringAsFixed(3)}°, ${selected.longitude.toStringAsFixed(3)}°',
                        ),
                      ],
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required bool isDark,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlight
            ? (isDark
                ? Colors.green.shade900.withValues(alpha: 0.3)
                : Colors.green.shade50)
            : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03)),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: highlight
              ? (isDark ? Colors.green.shade700 : Colors.green.shade300)
              : (isDark ? Colors.white12 : Colors.black12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              fontFamily: 'Ubuntu Sans Mono',
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'Ubuntu Sans',
              color: highlight
                  ? (isDark ? Colors.green.shade200 : Colors.green.shade900)
                  : (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateParcelDialog(BuildContext context, OryzaStrings s) {
    final nameCtrl = TextEditingController(text: s.parcelDefaultName.replaceAll('{n}', '${handler.parcels.length + 1}'));
    final areaCtrl = TextEditingController(text: '12.5');
    final latCtrl = TextEditingController(text: '14.882');
    final lonCtrl = TextEditingController(text: '100.451');
    String variety = 'RD43';
    String ecosystem = 'Irrigated';
    DateTime sowingDate = DateTime.now().subtract(const Duration(days: 42));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: Text(s.parcelCreateDialogTitle),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 440,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(labelText: s.parcelNameFieldLabel),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: areaCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: s.parcelAreaFieldLabel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: ecosystem,
                          decoration: InputDecoration(labelText: s.parcelEcosystemFieldLabel),
                          items: [
                            DropdownMenuItem(value: 'Irrigated', child: Text(s.parcelEcosystemIrrigated)),
                            DropdownMenuItem(value: 'Rainfed Lowland', child: Text(s.parcelEcosystemLowland)),
                            DropdownMenuItem(value: 'Upland', child: Text(s.parcelEcosystemUpland)),
                          ],
                          onChanged: (v) => setDlgState(() => ecosystem = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: variety,
                    decoration: InputDecoration(labelText: s.parcelVarietalFieldLabel),
                    items: [
                      DropdownMenuItem(value: 'RD43', child: Text(s.parcelVarietyRd43)),
                      DropdownMenuItem(value: 'Chai Nat 1', child: Text(s.parcelVarietyChaiNat1)),
                      DropdownMenuItem(value: 'Khao Dawk Mali 105', child: Text(s.parcelVarietyKdml105)),
                      DropdownMenuItem(value: 'BRS Pampa', child: Text(s.parcelVarietyBrsPampa)),
                      DropdownMenuItem(value: 'IR64', child: Text(s.parcelVarietyIr64)),
                    ],
                    onChanged: (v) => setDlgState(() => variety = v!),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: latCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: s.parcelLatitudeLabel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: lonCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: s.parcelLongitudeLabel),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(s.parcelSowingDateLabel),
                      TextButton(
                        child: Text(sowingDate.toIso8601String().split('T').first),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: sowingDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setDlgState(() => sowingDate = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(s.cancelBtn),
            ),
            ElevatedButton(
              onPressed: () async {
                final ok = await handler.createParcel(
                  name: nameCtrl.text.trim(),
                  areaHectares: double.tryParse(areaCtrl.text) ?? 1.0,
                  latitude: double.tryParse(latCtrl.text) ?? 0.0,
                  longitude: double.tryParse(lonCtrl.text) ?? 0.0,
                  riceEcosystem: ecosystem,
                  riceVariety: variety,
                  sowingDate: sowingDate,
                );
                if (context.mounted) {
                  Navigator.pop(ctx);
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(s.parcelCreatedSuccess)),
                    );
                  }
                }
              },
              child: Text(s.parcelSaveBtn),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditParcelDialog(BuildContext context, FarmParcel parcel, OryzaStrings s) {
    final nameCtrl = TextEditingController(text: parcel.name);
    final areaCtrl = TextEditingController(text: parcel.areaHectares.toString());
    DateTime sowingDate = parcel.sowingDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: Text(s.parcelEditDialogTitle.replaceAll('{name}', parcel.name)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: s.parcelNameFieldLabel),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: areaCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: s.parcelAreaFieldLabel),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(s.parcelSowingDateLabel),
                  TextButton(
                    child: Text(sowingDate.toIso8601String().split('T').first),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: sowingDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setDlgState(() => sowingDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(s.cancelBtn),
            ),
            ElevatedButton(
              onPressed: () async {
                final updated = parcel.copyWith(
                  name: nameCtrl.text.trim(),
                  areaHectares: double.tryParse(areaCtrl.text) ?? parcel.areaHectares,
                  sowingDate: sowingDate,
                );
                final ok = await handler.updateParcel(updated);
                if (context.mounted) {
                  Navigator.pop(ctx);
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(s.parcelUpdatedSuccess)),
                    );
                  }
                }
              },
              child: Text(s.parcelUpdateBtn),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteParcel(BuildContext context, FarmParcel parcel, OryzaStrings s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.parcelDeleteDialogTitle.replaceAll('{name}', parcel.name)),
        content: Text(s.parcelDeleteDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(s.cancelBtn),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final ok = await handler.deleteParcel(parcel.id);
              if (context.mounted) {
                Navigator.pop(ctx);
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.parcelDeletedSuccess)),
                  );
                }
              }
            },
            child: Text(s.parcelConfirmDeleteBtn, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
