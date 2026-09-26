import 'dart:convert';
import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/metric_type.dart';
import 'package:local/domain/models/sensor_reading.dart';
import 'package:local/domain/models/weather_record.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:local/presentation/widgets/parcel_selector_bar.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

enum DataViewMode {
  dailySummary,
  sensorHistory,
}

class DataManagementScreen extends StatefulWidget {
  final DashboardHandler handler;

  const DataManagementScreen({super.key, required this.handler});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  DataViewMode _viewMode = DataViewMode.dailySummary;
  MetricType _selectedHistoryMetric = MetricType.rainfall;
  List<SensorReading>? _cachedReadings;
  bool _isLoadingReadings = false;

  final Set<DateTime> _selectedDates = {};
  int _rowsPerPage = 10;
  int _currentPage = 0;

  int _historyRowsPerPage = 10;
  int _historyCurrentPage = 0;
  DateTime? _historyStartDate;
  DateTime? _historyEndDate;
  TimeOfDay? _historyStartTime;
  TimeOfDay? _historyEndTime;
  String? _historySensorFilter;

  void _clearHistoryFilters() {
    setState(() {
      _historyStartDate = null;
      _historyEndDate = null;
      _historyStartTime = null;
      _historyEndTime = null;
      _historySensorFilter = null;
      _historyCurrentPage = 0;
    });
  }

  Future<void> _loadSensorReadings() async {
    final parcelId = widget.handler.selectedParcel?.id;
    if (parcelId == null) {
      setState(() {
        _cachedReadings = [];
        _isLoadingReadings = false;
      });
      return;
    }
    setState(() => _isLoadingReadings = true);
    final readings = await widget.handler.fetchSensorReadings(_selectedHistoryMetric);
    if (mounted) {
      setState(() {
        _cachedReadings = readings;
        _isLoadingReadings = false;
      });
    }
  }

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
      final allSelected = pageRecords.every(
        (r) => _selectedDates.contains(r.date),
      );
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
        content: Text(s.deleteConfirmBody.replaceAll('{count}', '$count')),
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
      final success = await widget.handler.deleteRecords(
        _selectedDates.toList(),
      );
      if (success) {
        setState(() {
          _selectedDates.clear();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.deleteSuccessMsg.replaceAll('{count}', '$count')),
            ),
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
          backgroundColor: isDark
              ? OryzaColors.darkSurface
              : OryzaColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
                    title: Text(
                      s.manualRecordDateLabel,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                    subtitle: Text(
                      DateFormat('yyyy-MM-dd').format(_manualDate),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    trailing: const Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                    ),
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
                          decoration: InputDecoration(
                            labelText: s.manualFieldTMax,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _tMinCtrl,
                          decoration: InputDecoration(
                            labelText: s.manualFieldTMin,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
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
                          decoration: InputDecoration(
                            labelText: s.manualFieldRain,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _radCtrl,
                          decoration: InputDecoration(
                            labelText: s.manualFieldRad,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _rhCtrl,
                    decoration: InputDecoration(labelText: s.manualFieldRh),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
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
                final parcel = widget.handler.selectedParcel;
                if (parcel == null) return;

                final entry = ManualWeatherEntry(
                  date: _manualDate,
                  tMax: double.tryParse(_tMaxCtrl.text) ?? 30.0,
                  tMin: double.tryParse(_tMinCtrl.text) ?? 20.0,
                  precipitationMm: double.tryParse(_rainCtrl.text) ?? 0.0,
                  radiationMjM2: double.tryParse(_radCtrl.text) ?? 18.0,
                  relativeHumidityPct: double.tryParse(_rhCtrl.text) ?? 70.0,
                  source: s.manualRecordSourceLabel,
                );

                Navigator.of(ctx).pop();
                final ok = await widget.handler.ingestSingleRecord(entry);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ok ? s.manualRecordSavedMsg : s.manualRecordFailedMsg,
                      ),
                      backgroundColor: ok
                          ? Colors.green.shade800
                          : Colors.red.shade800,
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
          backgroundColor: isDark
              ? OryzaColors.darkSurface
              : OryzaColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
                Text(
                  s.csvUploadDeviceLabel,
                  style: const TextStyle(fontSize: 12.5),
                ),
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
                            '${d.deviceName} (${d.metrics.map((m) => m.metricType.name).join(", ")})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setDialogState(() => selectedDevice = val),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final chooseButton = OutlinedButton.icon(
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
                    );
                    final fileNameText = Text(
                      pickedFileName ?? s.csvUploadNoFileSelected,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    );

                    // Below ~300px the button alone can exceed the dialog's
                    // content width; stack instead of forcing both onto one row.
                    if (constraints.maxWidth < 300) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          chooseButton,
                          const SizedBox(height: 8),
                          fileNameText,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        chooseButton,
                        const SizedBox(width: 10),
                        Expanded(child: fileNameText),
                      ],
                    );
                  },
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
                          SnackBar(
                            content: Text(s.csvUploadNoDeviceSelectedMsg),
                          ),
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
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
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
        backgroundColor: isDark
            ? OryzaColors.darkSurface
            : OryzaColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          s.csvUploadResultTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
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
                      ? (report.successfulRows > 0
                            ? Colors.orange.shade800
                            : Colors.red.shade800)
                      : Colors.green.shade800,
                ),
              ),
              if (report.errors.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  s.csvUploadResultErrorsHeader,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
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
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 11.5),
                              ),
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

              // View Mode Switcher: Visão Diária vs Histórico por Sensor
              _buildViewModeSwitcher(context, isDark, s),
              const SizedBox(height: 12),

              if (_viewMode == DataViewMode.dailySummary) ...[
                if (records.isEmpty)
                  _buildEmptyState(context, isDark, s)
                else
                  _buildDataTable(context, isDark, s, records),
              ] else ...[
                _buildSensorHistorySection(context, isDark, s),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngestionActionsHeader(
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons3d/file-text-dynamic-color.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.dashNavData.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 11,
                          color: isDark
                              ? OryzaColors.darkTextSecondary
                              : OryzaColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: widget.handler.selectedParcel == null
                    ? null
                    : _showCsvUploadDialog,
                icon: const Icon(Icons.upload_file_rounded, size: 16),
                label: Text(s.csvUploadBtn),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(color: borderColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: widget.handler.isOperatingMock
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final ok = await widget.handler.populateMockData(
                          days: 75,
                          parcels: 4,
                        );
                        if (!mounted) return;
                        if (ok) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(s.demoDataLoadedSuccess)),
                          );
                        }
                      },
                icon: widget.handler.isOperatingMock
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.cloud_sync_rounded, size: 16),
                label: Text(s.loadDemoDataBtn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: OryzaColors.botanicalGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: 0,
                ),
              ),
              OutlinedButton.icon(
                onPressed: widget.handler.isOperatingMock
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final ok = await widget.handler.cleanMockData();
                        if (!mounted) return;
                        if (ok) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(s.demoDataCleanedSuccess)),
                          );
                        }
                      },
                icon: const Icon(
                  Icons.delete_sweep_rounded,
                  size: 16,
                  color: Colors.redAccent,
                ),
                label: Text(
                  s.cleanDemoDataBtn,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.redAccent.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
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
                color: isDark
                    ? OryzaColors.darkTextPrimary
                    : OryzaColors.lightTextPrimary,
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
              onPressed: () =>
                  widget.handler.populateMockData(days: 75, parcels: 4),
              icon: const Icon(Icons.flash_on_rounded, size: 16),
              label: Text(s.loadDemoDataBtn),
              style: ElevatedButton.styleFrom(
                backgroundColor: OryzaColors.burntOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
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

  Widget _buildMetricCell(double? val, String unit, bool isDark) {
    if (val == null) {
      return const Text('—');
    }
    return Text(
      "${unit == '%' ? val.toStringAsFixed(0) : val.toStringAsFixed(1)} $unit",
      style: const TextStyle(
        fontFamily: OryzaTypography.monoFontFamily,
        package: 'oryzaelo_ui',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDataTable(
    BuildContext context,
    bool isDark,
    OryzaStrings s,
    List<DailyWeatherRecord> allRecords,
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
    final allPageSelected =
        pageRecords.isNotEmpty &&
        pageRecords.every((r) => _selectedDates.contains(r.date));

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
                border: Border(
                  bottom: BorderSide(
                    color: OryzaColors.burntOrange.withValues(alpha: 0.4),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    s.tableSelectedCount.replaceAll(
                      '{count}',
                      '${_selectedDates.length}',
                    ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
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
          LayoutBuilder(
            builder: (context, constraints) {
              return OryzaHorizontalScroller(
                isDark: isDark,
                step: 220,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                  ),
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
                      DataColumn(
                        columnWidth: const IntrinsicColumnWidth(flex: 1.2),
                        label: _headerLabel(s.tableColDate),
                      ),
                      DataColumn(
                        columnWidth: const IntrinsicColumnWidth(flex: 1.0),
                        label: _headerLabel(s.tableColTmax),
                        numeric: true,
                      ),
                      DataColumn(
                        columnWidth: const IntrinsicColumnWidth(flex: 1.0),
                        label: _headerLabel(s.tableColTmin),
                        numeric: true,
                      ),
                      DataColumn(
                        columnWidth: const IntrinsicColumnWidth(flex: 1.0),
                        label: _headerLabel(s.tableColRain),
                        numeric: true,
                      ),
                      DataColumn(
                        columnWidth: const IntrinsicColumnWidth(flex: 1.0),
                        label: _headerLabel(s.tableColRad),
                        numeric: true,
                      ),
                      DataColumn(
                        columnWidth: const IntrinsicColumnWidth(flex: 1.0),
                        label: _headerLabel(s.tableColRh),
                        numeric: true,
                      ),
                      DataColumn(
                        columnWidth: const IntrinsicColumnWidth(flex: 1.1),
                        label: _headerLabel(s.chartUnitGdd.split(' ')[0]),
                        numeric: true,
                      ),
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd').format(r.date),
                            style: const TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (r.isPartial) ...[
                            const SizedBox(width: 6),
                            Tooltip(
                              message: s.tablePartialDayTooltip,
                              child: Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    DataCell(_buildMetricCell(r.tMax, '°C', isDark)),
                    DataCell(_buildMetricCell(r.tMin, '°C', isDark)),
                    DataCell(_buildMetricCell(r.precipitationMm, 'mm', isDark)),
                    DataCell(_buildMetricCell(r.radiationMjM2, 'MJ/m²', isDark)),
                    DataCell(_buildMetricCell(r.relativeHumidityPct, '%', isDark)),
                    DataCell(
                      Text(
                        gdd != null ? "${gdd.toStringAsFixed(1)} °C·d" : '—',
                        style: const TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
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
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          s.tablePaginationRows,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: textColor),
                        ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
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

  Widget _buildViewModeSwitcher(BuildContext context, bool isDark, OryzaStrings s) {
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(4),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            _buildModeTab(
              title: s.dataTabDaily,
              icon: Icons.calendar_today_rounded,
              isSelected: _viewMode == DataViewMode.dailySummary,
              isDark: isDark,
              onTap: () => setState(() => _viewMode = DataViewMode.dailySummary),
            ),
            _buildModeTab(
              title: s.dataTabReadings,
              icon: Icons.history_rounded,
              isSelected: _viewMode == DataViewMode.sensorHistory,
              isDark: isDark,
              onTap: () {
                setState(() => _viewMode = DataViewMode.sensorHistory);
                _loadSensorReadings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeTab({
    required String title,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final activeBg = isDark
        ? OryzaColors.botanicalGreen.withValues(alpha: 0.25)
        : OryzaColors.botanicalGreen.withValues(alpha: 0.12);
    final activeColor = isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen;
    final inactiveColor = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: activeColor.withValues(alpha: 0.4))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? activeColor : inactiveColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorHistorySection(BuildContext context, bool isDark, OryzaStrings s) {
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;

    final metrics = [
      (MetricType.rainfall, s.tableColRain),
      (MetricType.tMax, s.tableColTmax),
      (MetricType.tMin, s.tableColTmin),
      (MetricType.radiation, s.tableColRad),
      (MetricType.humidity, s.tableColRh),
    ];

    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final allReadings = _cachedReadings ?? [];
    final availableSensors = allReadings.map((r) => r.sensorId).toSet().toList()..sort();

    final filteredReadings = allReadings.where((r) {
      if (_historyStartDate != null) {
        final start = DateTime(_historyStartDate!.year, _historyStartDate!.month, _historyStartDate!.day);
        if (r.recordedAt.isBefore(start)) return false;
      }
      if (_historyEndDate != null) {
        final end = DateTime(_historyEndDate!.year, _historyEndDate!.month, _historyEndDate!.day, 23, 59, 59, 999);
        if (r.recordedAt.isAfter(end)) return false;
      }
      if (_historyStartTime != null) {
        final timeMin = r.recordedAt.hour * 60 + r.recordedAt.minute;
        final startMin = _historyStartTime!.hour * 60 + _historyStartTime!.minute;
        if (timeMin < startMin) return false;
      }
      if (_historyEndTime != null) {
        final timeMin = r.recordedAt.hour * 60 + r.recordedAt.minute;
        final endMin = _historyEndTime!.hour * 60 + _historyEndTime!.minute;
        if (timeMin > endMin) return false;
      }
      if (_historySensorFilter != null && _historySensorFilter!.isNotEmpty) {
        if (r.sensorId != _historySensorFilter) return false;
      }
      return true;
    }).toList();

    final hasActiveFilters = _historyStartDate != null ||
        _historyEndDate != null ||
        _historyStartTime != null ||
        _historyEndTime != null ||
        (_historySensorFilter != null && _historySensorFilter!.isNotEmpty);

    final totalPages = (filteredReadings.length / _historyRowsPerPage).ceil();
    if (_historyCurrentPage >= totalPages && totalPages > 0) {
      _historyCurrentPage = totalPages - 1;
    }
    final startIndex = _historyCurrentPage * _historyRowsPerPage;
    final endIndex = (startIndex + _historyRowsPerPage).clamp(0, filteredReadings.length);
    final pageReadings = filteredReadings.sublist(startIndex, endIndex);

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
          // Metric selector chips header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  s.tableColMetric.toUpperCase(),
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                ...metrics.map((m) {
                  final isSelected = _selectedHistoryMetric == m.$1;
                  return ChoiceChip(
                    label: Text(
                      m.$2,
                      style: TextStyle(
                        fontFamily: OryzaTypography.monoFontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: OryzaColors.botanicalGreen.withValues(alpha: 0.2),
                    backgroundColor: isDark ? OryzaColors.darkCanvas : OryzaColors.lightCanvas,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedHistoryMetric = m.$1;
                          _historyCurrentPage = 0;
                        });
                        _loadSensorReadings();
                      }
                    },
                  );
                }),
              ],
            ),
          ),

          // Filter Toolbar (Date range, Time range, Sensor filter, Clear button)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B15) : const Color(0xFFFAF8F5),
              border: Border(bottom: BorderSide(color: borderColor, width: 0.8)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Date Range Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    side: BorderSide(
                      color: (_historyStartDate != null || _historyEndDate != null)
                          ? OryzaColors.burntOrange
                          : borderColor,
                    ),
                  ),
                  icon: const Icon(Icons.date_range_rounded, size: 14),
                  label: Text(
                    _historyStartDate == null && _historyEndDate == null
                        ? s.filterDateRange
                        : '${_historyStartDate != null ? DateFormat('yyyy-MM-dd').format(_historyStartDate!) : ''} → ${_historyEndDate != null ? DateFormat('yyyy-MM-dd').format(_historyEndDate!) : ''}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                      initialDateRange: _historyStartDate != null && _historyEndDate != null
                          ? DateTimeRange(start: _historyStartDate!, end: _historyEndDate!)
                          : null,
                    );
                    if (picked != null) {
                      setState(() {
                        _historyStartDate = picked.start;
                        _historyEndDate = picked.end;
                        _historyCurrentPage = 0;
                      });
                    }
                  },
                ),

                // Time Filter Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    side: BorderSide(
                      color: (_historyStartTime != null || _historyEndTime != null)
                          ? OryzaColors.burntOrange
                          : borderColor,
                    ),
                  ),
                  icon: const Icon(Icons.access_time_rounded, size: 14),
                  label: Text(
                    _historyStartTime == null && _historyEndTime == null
                        ? s.filterTimeRange
                        : '${_historyStartTime != null ? _historyStartTime!.format(context) : '00:00'} - ${_historyEndTime != null ? _historyEndTime!.format(context) : '23:59'}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: () => _showTimeRangeFilterDialog(context, isDark, s),
                ),

                // Sensor Dropdown Filter
                if (availableSensors.length > 1)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _historySensorFilter != null ? OryzaColors.burntOrange : borderColor,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _historySensorFilter,
                          isDense: true,
                          dropdownColor: surfaceColor,
                          hint: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 160),
                            child: Text(
                              s.filterAllSensors,
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 160),
                                child: Text(
                                  s.filterAllSensors,
                                  style: const TextStyle(fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            ...availableSensors.map(
                              (sId) => DropdownMenuItem<String?>(
                                value: sId,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 160),
                                  child: Text(
                                    sId.replaceAll('preset_', '').replaceAll('mapping_', ''),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontFamily: OryzaTypography.monoFontFamily,
                                      package: 'oryzaelo_ui',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _historySensorFilter = val;
                              _historyCurrentPage = 0;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                // Clear Filters Button
                if (hasActiveFilters)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: OryzaColors.burntOrange,
                    ),
                    onPressed: _clearHistoryFilters,
                    icon: const Icon(Icons.clear_rounded, size: 14),
                    label: Text(
                      s.filterClear,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),

          if (_isLoadingReadings)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (allReadings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(36),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sensors_off_outlined,
                      size: 36,
                      color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.sensorReadingsEmpty,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 13,
                        color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredReadings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(36),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.filter_alt_off_rounded,
                      size: 36,
                      color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.filterClear,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 13,
                        color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _clearHistoryFilters,
                      child: Text(s.filterClear),
                    ),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                return OryzaHorizontalScroller(
                  isDark: isDark,
                  step: 220,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        isDark ? const Color(0xFF1B201A) : const Color(0xFFF2EFE6),
                      ),
                      headingRowHeight: 40,
                      dataRowMinHeight: 38,
                      dataRowMaxHeight: 42,
                      columnSpacing: 24,
                      horizontalMargin: 16,
                      columns: [
                        DataColumn(
                          columnWidth: const IntrinsicColumnWidth(flex: 1.5),
                          label: _headerLabel(s.tableColTimestamp),
                        ),
                        DataColumn(
                          columnWidth: const IntrinsicColumnWidth(flex: 1.5),
                          label: _headerLabel(s.tableColSource),
                        ),
                        DataColumn(
                          columnWidth: const IntrinsicColumnWidth(flex: 1.5),
                          label: _headerLabel(s.tableColValue),
                          numeric: true,
                        ),
                        DataColumn(
                          columnWidth: const IntrinsicColumnWidth(flex: 0.8),
                          label: _headerLabel(s.tableColActions),
                        ),
                      ],
                      rows: pageReadings.map((r) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                DateFormat('yyyy-MM-dd HH:mm').format(r.recordedAt),
                                style: const TextStyle(
                                  fontFamily: OryzaTypography.monoFontFamily,
                                  package: 'oryzaelo_ui',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
                                  r.sensorId,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontFamily: OryzaTypography.monoFontFamily,
                                    package: 'oryzaelo_ui',
                                    color: isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                "${r.value.toStringAsFixed(1)} ${r.metricType.canonicalUnit}",
                                style: const TextStyle(
                                  fontFamily: OryzaTypography.monoFontFamily,
                                  package: 'oryzaelo_ui',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.redAccent),
                                tooltip: s.tableColActions,
                                onPressed: () async {
                                  final ok = await widget.handler.deleteSensorReading(
                                    id: r.id,
                                    metricType: r.metricType,
                                  );
                                  if (ok) {
                                    await _loadSensorReadings();
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),

          // Pagination Controls Footer for Sensor History
          if (filteredReadings.isNotEmpty)
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
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            s.tablePaginationRows,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: textColor),
                          ),
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
                              value: _historyRowsPerPage,
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
                                    _historyRowsPerPage = val;
                                    _historyCurrentPage = 0;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${startIndex + 1} - $endIndex ${s.tablePaginationOf} ${filteredReadings.length}${hasActiveFilters ? ' (${allReadings.length})' : ''}",
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
                        key: const Key('history_pagination_prev'),
                        style: IconButton.styleFrom(
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: _historyCurrentPage > 0
                            ? () => setState(() => _historyCurrentPage--)
                            : null,
                        icon: const Icon(Icons.chevron_left_rounded, size: 18),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        key: const Key('history_pagination_next'),
                        style: IconButton.styleFrom(
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: _historyCurrentPage < totalPages - 1
                            ? () => setState(() => _historyCurrentPage++)
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

  Future<void> _showTimeRangeFilterDialog(BuildContext context, bool isDark, OryzaStrings s) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(s.filterTimeRange, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                title: const Text('00:00 - 23:59 (Dia Todo)', style: TextStyle(fontSize: 12)),
                onTap: () {
                  setState(() {
                    _historyStartTime = null;
                    _historyEndTime = null;
                    _historyCurrentPage = 0;
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                dense: true,
                title: const Text('00:00 - 12:00 (Manhã)', style: TextStyle(fontSize: 12)),
                onTap: () {
                  setState(() {
                    _historyStartTime = const TimeOfDay(hour: 0, minute: 0);
                    _historyEndTime = const TimeOfDay(hour: 12, minute: 0);
                    _historyCurrentPage = 0;
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                dense: true,
                title: const Text('12:00 - 18:00 (Tarde)', style: TextStyle(fontSize: 12)),
                onTap: () {
                  setState(() {
                    _historyStartTime = const TimeOfDay(hour: 12, minute: 0);
                    _historyEndTime = const TimeOfDay(hour: 18, minute: 0);
                    _historyCurrentPage = 0;
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                dense: true,
                title: const Text('18:00 - 23:59 (Noite)', style: TextStyle(fontSize: 12)),
                onTap: () {
                  setState(() {
                    _historyStartTime = const TimeOfDay(hour: 18, minute: 0);
                    _historyEndTime = const TimeOfDay(hour: 23, minute: 59);
                    _historyCurrentPage = 0;
                  });
                  Navigator.pop(ctx);
                },
              ),
              const Divider(),
              ListTile(
                dense: true,
                leading: const Icon(Icons.tune_rounded, size: 16),
                title: const Text('Horário Inicial Personalizado', style: TextStyle(fontSize: 12)),
                subtitle: Text(_historyStartTime?.format(context) ?? '00:00', style: const TextStyle(fontSize: 11)),
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: _historyStartTime ?? const TimeOfDay(hour: 6, minute: 0),
                  );
                  if (t != null) {
                    setState(() {
                      _historyStartTime = t;
                      _historyCurrentPage = 0;
                    });
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.tune_rounded, size: 16),
                title: const Text('Horário Final Personalizado', style: TextStyle(fontSize: 12)),
                subtitle: Text(_historyEndTime?.format(context) ?? '23:59', style: const TextStyle(fontSize: 11)),
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: _historyEndTime ?? const TimeOfDay(hour: 18, minute: 0),
                  );
                  if (t != null) {
                    setState(() {
                      _historyEndTime = t;
                      _historyCurrentPage = 0;
                    });
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
