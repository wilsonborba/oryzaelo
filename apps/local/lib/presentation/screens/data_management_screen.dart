import 'dart:convert';
import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/weather_record.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:local/presentation/widgets/parcel_selector_bar.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class DataManagementScreen extends StatefulWidget {
  final DashboardHandler handler;

  const DataManagementScreen({
    super.key,
    required this.handler,
  });

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  final Set<DateTime> _selectedDates = {};
  int _rowsPerPage = 10;
  int _currentPage = 0;

  // Manual entry controllers
  DateTime _manualDate = DateTime.now();
  final _tMaxCtrl = TextEditingController(text: '31.5');
  final _tMinCtrl = TextEditingController(text: '19.8');
  final _rainCtrl = TextEditingController(text: '0.0');
  final _radCtrl = TextEditingController(text: '18.5');
  final _rhCtrl = TextEditingController(text: '72.0');

  @override
  void dispose() {
    _tMaxCtrl.dispose();
    _tMinCtrl.dispose();
    _rainCtrl.dispose();
    _radCtrl.dispose();
    _rhCtrl.dispose();
    super.dispose();
  }

  void _toggleSelectAll(List<DailyWeatherRecord> pageRecords) {
    setState(() {
      final allSelected = pageRecords.every((r) => _selectedDates.contains(r.date));
      if (allSelected) {
        for (final r in pageRecords) {
          _selectedDates.remove(r.date);
        }
      } else {
        for (final r in pageRecords) {
          _selectedDates.add(r.date);
        }
      }
    });
  }

  Future<void> _deleteSelectedRecords() async {
    final s = OryzaI18n.of(context);
    final count = _selectedDates.length;
    if (count == 0) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.tableConfirmDeleteTitle),
        content: Text(
          s.deleteConfirmBody.replaceAll('{count}', '$count'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(s.cancelBtn),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
            ),
            child: Text(s.confirmBtn),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await widget.handler.deleteRecords(_selectedDates.toList());
      if (success) {
        setState(() {
          _selectedDates.clear();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(s.deleteSuccessMsg.replaceAll('{count}', '$count'))),
          );
        }
      }
    }
  }

  void _showManualRecordDialog() {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            s.tableNewRecordBtn,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: math.min(420, MediaQuery.of(context).size.width * 0.86),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.manualRecordDateLabel, style: const TextStyle(fontSize: 12.5)),
                    subtitle: Text(
                      DateFormat('yyyy-MM-dd').format(_manualDate),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    trailing: const Icon(Icons.calendar_today_rounded, size: 20),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _manualDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setDialogState(() => _manualDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tMaxCtrl,
                          decoration: InputDecoration(labelText: s.manualFieldTMax),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _tMinCtrl,
                          decoration: InputDecoration(labelText: s.manualFieldTMin),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _rainCtrl,
                          decoration: InputDecoration(labelText: s.manualFieldRain),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _radCtrl,
                          decoration: InputDecoration(labelText: s.manualFieldRad),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _rhCtrl,
                    decoration: InputDecoration(labelText: s.manualFieldRh),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                final parcel = widget.handler.selectedParcel;
                if (parcel == null) return;

                final rec = DailyWeatherRecord(
                  date: _manualDate,
                  tMax: double.tryParse(_tMaxCtrl.text) ?? 30.0,
                  tMin: double.tryParse(_tMinCtrl.text) ?? 20.0,
                  precipitationMm: double.tryParse(_rainCtrl.text) ?? 0.0,
                  radiationMjM2: double.tryParse(_radCtrl.text) ?? 18.0,
                  relativeHumidityPct: double.tryParse(_rhCtrl.text) ?? 70.0,
                  source: s.manualRecordSourceLabel,
                );

                Navigator.of(ctx).pop();
                final ok = await widget.handler.ingestSingleRecord(rec);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok ? s.manualRecordSavedMsg : s.manualRecordFailedMsg),
                      backgroundColor: ok ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: OryzaColors.burntOrange,
                foregroundColor: Colors.white,
              ),
              child: Text(s.saveRecordBtn),
            ),
          ],
        ),
      ),
    );
  }

  void _showCsvUploadDialog() {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final devices = widget.handler.allDeviceMappings;

    DeviceMapping? selectedDevice;
    String? pickedFileName;
    String? pickedCsvContent;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            s.csvUploadDialogTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: math.min(420, MediaQuery.of(context).size.width * 0.86),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.csvUploadDeviceLabel, style: const TextStyle(fontSize: 12.5)),
                const SizedBox(height: 6),
                DropdownButtonFormField<DeviceMapping>(
                  initialValue: selectedDevice,
                  isExpanded: true,
                  hint: Text(s.csvUploadDeviceHint),
                  decoration: const InputDecoration(isDense: true),
                  items: devices
                      .map(
                        (d) => DropdownMenuItem(
                          value: d,
                          child: Text(
                            d.deviceName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedDevice = val),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['csv'],
                          withData: true,
                        );
                        final file = result?.files.singleOrNull;
                        if (file?.bytes != null) {
                          setDialogState(() {
                            pickedFileName = file!.name;
                            pickedCsvContent = utf8.decode(file.bytes!);
                          });
                        }
                      },
                      icon: const Icon(Icons.upload_file_rounded, size: 16),
                      label: Text(s.csvUploadChooseFileBtn),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        pickedFileName ?? s.csvUploadNoFileSelected,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.of(ctx).pop(),
              child: Text(s.cancelBtn),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      final s = OryzaI18n.of(context);
                      if (selectedDevice == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(s.csvUploadNoDeviceSelectedMsg)),
                        );
                        return;
                      }
                      if (pickedCsvContent == null) return;

                      setDialogState(() => isSubmitting = true);
                      final report = await widget.handler.uploadCsv(
                        deviceId: selectedDevice!.id,
                        csvContent: pickedCsvContent!,
                      );
                      if (!ctx.mounted) return;
                      Navigator.of(ctx).pop();

                      if (!mounted) return;
                      if (report != null) {
                        _showCsvResultDialog(report);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(s.csvUploadFailedMsg),
                            backgroundColor: Colors.red.shade800,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: OryzaColors.burntOrange,
                foregroundColor: Colors.white,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(s.csvUploadSubmitBtn),
            ),
          ],
        ),
      ),
    );
  }

  void _showCsvResultDialog(IngestionReport report) {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final summary = s.csvUploadResultSummary
        .replaceAll('{success}', '${report.successfulRows}')
        .replaceAll('{total}', '${report.totalRows}');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(s.csvUploadResultTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: math.min(420, MediaQuery.of(context).size.width * 0.86),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                summary,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: report.failedRows > 0
                      ? (report.successfulRows > 0 ? Colors.orange.shade800 : Colors.red.shade800)
                      : Colors.green.shade800,
                ),
              ),
              if (report.errors.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(s.csvUploadResultErrorsHeader, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: report.errors
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(e, style: const TextStyle(fontSize: 11.5)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(s.csvUploadCloseBtn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final records = widget.handler.weatherRecords;

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

              // Ingestion Toolbar & Actions
              _buildIngestionActionsHeader(context, isDark, s),
              const SizedBox(height: 16),

              // Data Table or Figma Empty State
              if (records.isEmpty)
                _buildEmptyState(context, isDark, s)
              else
                _buildDataTable(context, isDark, s, records),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngestionActionsHeader(BuildContext context, bool isDark, OryzaStrings s) {
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            offset: const Offset(2, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons3d/file-text-dynamic-color.png',
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.dashNavData.toUpperCase(),
                    style: TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: textColor,
                    ),
                  ),
                  Text(
                    s.dataManagementSubtitle,
                    style: TextStyle(
                      fontFamily: OryzaTypography.fontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 11,
                      color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Action Buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _showManualRecordDialog,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: Text(s.tableNewRecordBtn),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(color: borderColor),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              OutlinedButton.icon(
                onPressed: widget.handler.selectedParcel == null ? null : _showCsvUploadDialog,
                icon: const Icon(Icons.upload_file_rounded, size: 16),
                label: Text(s.csvUploadBtn),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(color: borderColor),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              ElevatedButton.icon(
                onPressed: widget.handler.isOperatingMock
                    ? null
                    : () async {
                        final ok = await widget.handler.populateMockData(days: 75, parcels: 4);
                        if (!mounted) return;
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(s.demoDataLoadedSuccess)),
                          );
                        }
                      },
                icon: widget.handler.isOperatingMock
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.cloud_sync_rounded, size: 16),
                label: Text(s.loadDemoDataBtn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: OryzaColors.botanicalGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 0,
                ),
              ),
              OutlinedButton.icon(
                onPressed: widget.handler.isOperatingMock
                    ? null
                    : () async {
                        final ok = await widget.handler.cleanMockData();
                        if (!mounted) return;
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(s.demoDataCleanedSuccess)),
                          );
                        }
                      },
                icon: const Icon(Icons.delete_sweep_rounded, size: 16, color: Colors.redAccent),
                label: Text(
                  s.cleanDemoDataBtn,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, OryzaStrings s) {
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
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
                    'assets/plants/Jungle_Plant_2.png',
                    width: 180,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                Image.asset(
                  'assets/icons3d/file-text-dynamic-color.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              s.noRecordsFoundTitle,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Text(
                s.noRecordsFoundBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12.5,
                  color: textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => widget.handler.populateMockData(days: 75, parcels: 4),
              icon: const Icon(Icons.flash_on_rounded, size: 16),
              label: Text(s.loadDemoDataBtn),
              style: ElevatedButton.styleFrom(
                backgroundColor: OryzaColors.burntOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: OryzaTypography.monoFontFamily,
        package: 'oryzaelo_ui',
        fontWeight: FontWeight.w800,
        fontSize: 11,
        letterSpacing: 0.4,
      ),
    );
  }

  Widget _buildDataTable(
    BuildContext context,
    bool isDark,
    OryzaStrings s,
    List<DailyWeatherRecord> allRecords,
  ) {
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;

    // Sort descending chronologically
    final sorted = [...allRecords]..sort((a, b) => b.date.compareTo(a.date));

    final totalPages = (sorted.length / _rowsPerPage).ceil();
    if (_currentPage >= totalPages && totalPages > 0) {
      _currentPage = totalPages - 1;
    }

    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, sorted.length);
    final pageRecords = sorted.sublist(startIndex, endIndex);

    final hasSelection = _selectedDates.isNotEmpty;
    final allPageSelected = pageRecords.isNotEmpty && pageRecords.every((r) => _selectedDates.contains(r.date));

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bulk Actions Bar (Shown if 1+ rows selected)
          if (hasSelection)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: OryzaColors.burntOrange.withValues(alpha: 0.12),
                border: Border(bottom: BorderSide(color: OryzaColors.burntOrange.withValues(alpha: 0.4))),
              ),
              child: Row(
                children: [
                  Text(
                    s.tableSelectedCount.replaceAll('{count}', '${_selectedDates.length}'),
                    style: const TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: OryzaColors.burntOrange,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _deleteSelectedRecords,
                    icon: const Icon(Icons.delete_forever_rounded, size: 16),
                    label: Text(s.tableDeleteSelectedBtn),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => setState(() => _selectedDates.clear()),
                    child: Text(s.deselectAllBtn),
                  ),
                ],
              ),
            ),

          // Scrollable Table
          OryzaHorizontalScroller(
            isDark: isDark,
            step: 220,
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: WidgetStateProperty.all(
                isDark ? const Color(0xFF1B201A) : const Color(0xFFF2EFE6),
              ),
              headingRowHeight: 40,
              dataRowMinHeight: 38,
              dataRowMaxHeight: 42,
              columnSpacing: 20,
              horizontalMargin: 16,
              columns: [
                DataColumn(
                  label: Checkbox(
                    value: allPageSelected,
                    onChanged: (_) => _toggleSelectAll(pageRecords),
                  ),
                ),
                DataColumn(label: _headerLabel(s.tableColDate)),
                DataColumn(label: _headerLabel(s.tableColTmax), numeric: true),
                DataColumn(label: _headerLabel(s.tableColTmin), numeric: true),
                DataColumn(label: _headerLabel(s.tableColRain), numeric: true),
                DataColumn(label: _headerLabel(s.tableColRad), numeric: true),
                DataColumn(label: _headerLabel(s.tableColRh), numeric: true),
                DataColumn(label: _headerLabel(s.chartUnitGdd.split(' ')[0]), numeric: true),
                DataColumn(label: _headerLabel(s.tableColSource)),
              ],
              rows: pageRecords.map((r) {
                final isSelected = _selectedDates.contains(r.date);
                final gdd = r.dailyGdd;

                return DataRow(
                  selected: isSelected,
                  onSelectChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedDates.add(r.date);
                      } else {
                        _selectedDates.remove(r.date);
                      }
                    });
                  },
                  cells: [
                    DataCell(
                      Checkbox(
                        value: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedDates.add(r.date);
                            } else {
                              _selectedDates.remove(r.date);
                            }
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Text(
                        DateFormat('yyyy-MM-dd').format(r.date),
                        style: const TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(Text("${r.tMax.toStringAsFixed(1)} °C")),
                    DataCell(Text("${r.tMin.toStringAsFixed(1)} °C")),
                    DataCell(Text("${r.precipitationMm.toStringAsFixed(1)} mm")),
                    DataCell(Text("${r.radiationMjM2.toStringAsFixed(1)} MJ/m²")),
                    DataCell(Text("${r.relativeHumidityPct.toStringAsFixed(0)} %")),
                    DataCell(
                      Text(
                        "${gdd.toStringAsFixed(1)} °C·d",
                        style: const TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? OryzaColors.darkCanvas : OryzaColors.botanicalGreenLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          r.source,
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            color: isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          // Pagination Controls Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: borderColor, width: 1.0)),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.tablePaginationRows,
                      style: TextStyle(fontSize: 11, color: textColor),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _rowsPerPage,
                          isDense: true,
                          dropdownColor: surfaceColor,
                          items: const [
                            DropdownMenuItem(value: 10, child: Text("10")),
                            DropdownMenuItem(value: 25, child: Text("25")),
                            DropdownMenuItem(value: 50, child: Text("50")),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _rowsPerPage = val;
                                _currentPage = 0;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "${startIndex + 1} - $endIndex ${s.tablePaginationOf} ${sorted.length}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 11.5,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: _currentPage > 0
                          ? () => setState(() => _currentPage--)
                          : null,
                      icon: const Icon(Icons.chevron_left_rounded, size: 18),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      style: IconButton.styleFrom(
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: _currentPage < totalPages - 1
                          ? () => setState(() => _currentPage++)
                          : null,
                      icon: const Icon(Icons.chevron_right_rounded, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
