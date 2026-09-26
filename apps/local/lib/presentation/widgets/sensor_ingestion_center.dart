import 'package:flutter/material.dart';
import 'package:local/domain/models/device_mapping.dart';
import 'package:local/domain/models/weather_record.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Sensor Configuration (CRUD) and Ingestion Center (CSV + Single Record).
class SensorIngestionCenter extends StatefulWidget {
  final DashboardHandler handler;

  const SensorIngestionCenter({
    super.key,
    required this.handler,
  });

  @override
  State<SensorIngestionCenter> createState() => _SensorIngestionCenterState();
}

class _SensorIngestionCenterState extends State<SensorIngestionCenter> {
  String? _selectedDeviceId;
  final TextEditingController _csvContentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.handler.allDeviceMappings.isNotEmpty) {
      _selectedDeviceId = widget.handler.allDeviceMappings.first.id;
    }
  }

  @override
  void didUpdateWidget(covariant SensorIngestionCenter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedDeviceId == null && widget.handler.allDeviceMappings.isNotEmpty) {
      _selectedDeviceId = widget.handler.allDeviceMappings.first.id;
    }
  }

  @override
  void dispose() {
    _csvContentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allDevices = widget.handler.allDeviceMappings;
    final s = OryzaI18n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Demonstration & Evaluation Mode Banner (1-Click Populate / Clean)
        _buildMockDataBanner(context, s, isDark),

        // Top Toolbar: Presets & Custom Mapping CRUD
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 850;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Presets & Mappings Panel
                      Expanded(
                        child: _buildDeviceListPanel(context, allDevices, isDark),
                      ),
                      const SizedBox(width: 16),
                      // CSV Ingestion Dropzone
                      Expanded(
                        child: _buildCsvIngestionPanel(context, allDevices, isDark),
                      ),
                    ],
                  )
                else ...[
                  _buildDeviceListPanel(context, allDevices, isDark),
                  const SizedBox(height: 16),
                  _buildCsvIngestionPanel(context, allDevices, isDark),
                ],

                const SizedBox(height: 16),

                // Single Manual Telemetry Record Entry Form
                _buildSingleRecordPanel(context, isDark),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeviceListPanel(
    BuildContext context,
    List<DeviceMapping> devices,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sensors, size: 18, color: isDark ? Colors.green.shade300 : Colors.green.shade800),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'DISPOSITIVOS E PRESETS DE SENSORES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Ubuntu Sans Mono',
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddMappingDialog(context),
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Novo Mapeamento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.green.shade800 : Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Presets de calibração para estações meteorológicas comerciais e gateways RS485/Modbus.',
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Ubuntu Sans',
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          ...devices.map((dev) {
            final isPreset = dev.id.startsWith('preset_');
            final isSelected = dev.id == _selectedDeviceId;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? Colors.green.shade900.withValues(alpha: 0.3) : Colors.green.shade50)
                    : (isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02)),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? (isDark ? Colors.green.shade700 : Colors.green.shade400)
                      : (isDark ? Colors.white12 : Colors.black12),
                ),
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: dev.id,
                    groupValue: _selectedDeviceId,
                    onChanged: (val) => setState(() => _selectedDeviceId = val),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              dev.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Ubuntu Sans',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: isPreset
                                    ? (isDark ? Colors.blue.shade900.withValues(alpha: 0.4) : Colors.blue.shade100)
                                    : (isDark ? Colors.purple.shade900.withValues(alpha: 0.4) : Colors.purple.shade100),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isPreset ? 'PRESET OFICIAL' : 'CUSTOMIZADO',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Ubuntu Sans Mono',
                                  color: isPreset
                                      ? (isDark ? Colors.blue.shade300 : Colors.blue.shade800)
                                      : (isDark ? Colors.purple.shade300 : Colors.purple.shade800),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${dev.manufacturer} ${dev.model} • ${dev.mappings.length} métricas mapeadas',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Ubuntu Sans Mono',
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isPreset) ...[
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 16),
                      tooltip: 'Remover Mapeamento',
                      onPressed: () => widget.handler.deleteCustomMapping(dev.id),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCsvIngestionPanel(
    BuildContext context,
    List<DeviceMapping> devices,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.upload_file, size: 18, color: isDark ? Colors.green.shade300 : Colors.green.shade800),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'INGESTÃO RESILIENTE DE DADOS CSV',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Ubuntu Sans Mono',
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Cole as linhas do arquivo CSV meteorológico para processamento determinístico e validação no SQLite.',
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Ubuntu Sans',
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          // CSV Text Area
          TextField(
            controller: _csvContentCtrl,
            maxLines: 6,
            style: const TextStyle(fontSize: 11, fontFamily: 'Ubuntu Sans Mono'),
            decoration: InputDecoration(
              hintText: 'Date,T_max,T_min,Precipitation,Solar_Rad,RH\n2026-09-15,33.5,23.1,12.0,19.5,82.0\n...',
              filled: true,
              fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: widget.handler.isLoading || _selectedDeviceId == null ? null : _submitCsv,
            icon: widget.handler.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.cloud_upload_outlined, size: 18),
            label: Text(widget.handler.isLoading ? 'Processando e Validando...' : 'Processar e Validar CSV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.green.shade800 : Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleRecordPanel(BuildContext context, bool isDark) {
    final dateCtrl = TextEditingController(text: DateTime.now().toIso8601String().split('T').first);
    final tMaxCtrl = TextEditingController(text: '32.5');
    final tMinCtrl = TextEditingController(text: '23.0');
    final rainCtrl = TextEditingController(text: '0.0');
    final radCtrl = TextEditingController(text: '19.2');
    final rhCtrl = TextEditingController(text: '78.0');
    final sourceCtrl = TextEditingController(text: 'Manual_Field_Scout');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.edit_calendar, size: 18, color: isDark ? Colors.green.shade300 : Colors.green.shade800),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ENTRADA AVULSA DE LEITURA METEOROLÓGICA (TÉCNICO DE CAMPO)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Ubuntu Sans Mono',
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: 130,
                    child: TextField(
                      controller: dateCtrl,
                      decoration: const InputDecoration(labelText: 'Data (AAAA-MM-DD)', isDense: true),
                      style: const TextStyle(fontSize: 11, fontFamily: 'Ubuntu Sans Mono'),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: tMaxCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'T_max (°C)', isDense: true),
                      style: const TextStyle(fontSize: 11, fontFamily: 'Ubuntu Sans Mono'),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: tMinCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'T_min (°C)', isDense: true),
                      style: const TextStyle(fontSize: 11, fontFamily: 'Ubuntu Sans Mono'),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: rainCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Chuva (mm)', isDense: true),
                      style: const TextStyle(fontSize: 11, fontFamily: 'Ubuntu Sans Mono'),
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: TextField(
                      controller: radCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Radiação (MJ/m²)', isDense: true),
                      style: const TextStyle(fontSize: 11, fontFamily: 'Ubuntu Sans Mono'),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: rhCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'UR (%)', isDense: true),
                      style: const TextStyle(fontSize: 11, fontFamily: 'Ubuntu Sans Mono'),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: TextField(
                      controller: sourceCtrl,
                      decoration: const InputDecoration(labelText: 'Origem/Sensor', isDense: true),
                      style: const TextStyle(fontSize: 11, fontFamily: 'Ubuntu Sans Mono'),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final date = DateTime.tryParse(dateCtrl.text.trim()) ?? DateTime.now();
                      final rec = DailyWeatherRecord(
                        date: date,
                        tMax: double.tryParse(tMaxCtrl.text) ?? 30.0,
                        tMin: double.tryParse(tMinCtrl.text) ?? 22.0,
                        precipitationMm: double.tryParse(rainCtrl.text) ?? 0.0,
                        radiationMjM2: double.tryParse(radCtrl.text) ?? 18.0,
                        relativeHumidityPct: double.tryParse(rhCtrl.text) ?? 75.0,
                        source: sourceCtrl.text.trim(),
                      );
                      final ok = await widget.handler.ingestSingleRecord(rec);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ok
                                ? 'Registro diário inserido e validado com sucesso!'
                                : 'Erro ao persistir registro diário.'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.add_task, size: 16),
                    label: const Text('Registrar Coleta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.blue.shade800 : Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submitCsv() async {
    final content = _csvContentCtrl.text.trim();
    if (content.isEmpty || _selectedDeviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe o conteúdo do CSV e selecione um preset.')),
      );
      return;
    }

    final report = await widget.handler.uploadCsv(
      deviceId: _selectedDeviceId!,
      csvContent: content,
    );

    if (mounted && report != null) {
      _showValidationReportDialog(context, report);
    }
  }

  void _showValidationReportDialog(BuildContext context, IngestionReport report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              report.failedRows == 0 ? Icons.check_circle : Icons.warning_amber,
              color: report.failedRows == 0 ? Colors.green : Colors.amber,
            ),
            const SizedBox(width: 8),
            const Text('Relatório de Ingestão e Validação'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Linhas lidas no CSV: ${report.totalRows}'),
            Text(
              '• Linhas persistidas no SQLite: ${report.successfulRows}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Linhas rejeitadas por inconsistência: ${report.failedRows}',
              style: TextStyle(
                color: report.failedRows > 0 ? Colors.red : Colors.grey,
                fontWeight: report.failedRows > 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (report.errors.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Erros de Validação Fisiológica:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: report.errors
                        .map(
                          (err) => Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text(
                              '• $err',
                              style: const TextStyle(fontSize: 11, color: Colors.red),
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
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddMappingDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: 'Sensor Customizado LoRa');
    final mfgCtrl = TextEditingController(text: 'Maker/Dragino');
    final modelCtrl = TextEditingController(text: 'RS485-Node');
    final descCtrl = TextEditingController(text: 'Estação meteorológica personalizada');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo Mapeamento de Sensores'),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome do Mapeamento')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: mfgCtrl, decoration: const InputDecoration(labelText: 'Fabricante'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: modelCtrl, decoration: const InputDecoration(labelText: 'Modelo'))),
                ],
              ),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descrição')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final mapping = DeviceMapping(
                id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                manufacturer: mfgCtrl.text.trim(),
                model: modelCtrl.text.trim(),
                description: descCtrl.text.trim(),
                mappings: const [
                  MappingEntry(columnName: 'T_max', targetMetric: 't_max', unit: 'Celsius'),
                  MappingEntry(columnName: 'T_min', targetMetric: 't_min', unit: 'Celsius'),
                  MappingEntry(columnName: 'Precipitation', targetMetric: 'precipitation_mm', unit: 'Millimeter'),
                  MappingEntry(columnName: 'Radiation', targetMetric: 'radiation_mj_m2', unit: 'MegaJoulePerM2'),
                  MappingEntry(columnName: 'RH', targetMetric: 'relative_humidity_pct', unit: 'Percent'),
                ],
              );
              final ok = await widget.handler.saveCustomMapping(mapping);
              if (context.mounted) {
                Navigator.pop(ctx);
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mapeamento customizado salvo com sucesso!')),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // ── Mock & Test Data Actions ─────────────────────────────────────────────

  Widget _buildMockDataBanner(BuildContext context, OryzaStrings s, bool isDark) {
    final isOperating = widget.handler.isOperatingMock;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E281F) : const Color(0xFFEBF5EE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.green.shade800 : Colors.green.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.green.shade900 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.science_outlined,
                  size: 20,
                  color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.howToUseMockTitle.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        fontFamily: 'Ubuntu Sans Mono',
                        color: isDark ? Colors.green.shade300 : Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.howToUseMockDesc,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Ubuntu Sans',
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Populate Button
              ElevatedButton.icon(
                onPressed: isOperating ? null : () => _handlePopulateMockData(context, s),
                icon: isOperating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.cloud_download_outlined, size: 18),
                label: Text(
                  isOperating ? s.demoDataLoading : s.loadDemoDataBtn,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Ubuntu Sans'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.green.shade700 : Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              // Clean / Factory Reset Button
              OutlinedButton.icon(
                onPressed: isOperating ? null : () => _confirmCleanMockData(context, s),
                icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                label: Text(
                  s.cleanDemoDataBtn,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Ubuntu Sans'),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.red.shade300 : Colors.red.shade700,
                  side: BorderSide(
                    color: isDark ? Colors.red.shade800 : Colors.red.shade300,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handlePopulateMockData(BuildContext context, OryzaStrings s) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s.demoDataLoading),
        duration: const Duration(seconds: 2),
      ),
    );

    final ok = await widget.handler.populateMockData();
    if (context.mounted) {
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.demoDataLoadedSuccess),
            backgroundColor: Colors.green.shade800,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.handler.errorMessage ?? 'Falha ao popular dados.'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    }
  }

  void _confirmCleanMockData(BuildContext context, OryzaStrings s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            Text(s.confirmCleanTitle),
          ],
        ),
        content: Text(s.confirmCleanDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(s.cancelBtn),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(s.demoDataCleaning),
                  duration: const Duration(seconds: 2),
                ),
              );

              final ok = await widget.handler.cleanMockData();
              if (context.mounted) {
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(s.demoDataCleanedSuccess),
                      backgroundColor: Colors.blueGrey.shade800,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.handler.errorMessage ?? 'Falha ao limpar dados.'),
                      backgroundColor: Colors.red.shade800,
                    ),
                  );
                }
              }
            },
            child: Text(s.confirmBtn),
          ),
        ],
      ),
    );
  }
}
