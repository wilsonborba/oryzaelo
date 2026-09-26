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
                Icon(
                  Icons.landscape,
                  size: 20,
                  color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                ),
                const SizedBox(width: 8),
                Text(
                  'TALHÃO ATIVO DA FAZENDA',
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
                    tooltip: 'Editar Parâmetros do Talhão',
                    onPressed: () => _showEditParcelDialog(context, selected),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    tooltip: 'Excluir Talhão',
                    onPressed: () => _confirmDeleteParcel(context, selected),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton.icon(
                  onPressed: () => _showCreateParcelDialog(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Novo Talhão'),
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
                          hint: const Text('Selecione um talhão'),
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
                        label: 'VARIETAL',
                        value: selected.riceVariety,
                        icon: Icons.grass,
                      ),
                      // Ecosystem Badge
                      _buildMetricChip(
                        isDark: isDark,
                        label: 'ECOSSISTEMA',
                        value: selected.riceEcosystem,
                        icon: Icons.water_drop_outlined,
                      ),
                      // Area Badge
                      _buildMetricChip(
                        isDark: isDark,
                        label: 'ÁREA',
                        value: '${selected.areaHectares} ha',
                        icon: Icons.square_foot,
                      ),
                      // DAE Badge
                      _buildMetricChip(
                        isDark: isDark,
                        label: 'IDADE (DAE)',
                        value: '${selected.daysAfterSowing} dias',
                        icon: Icons.calendar_today_outlined,
                        highlight: true,
                      ),
                      if (!isCompact) ...[
                        // GPS Badge
                        _buildMetricChip(
                          isDark: isDark,
                          label: 'COORDENADAS',
                          value:
                              '${selected.latitude.toStringAsFixed(3)}°, ${selected.longitude.toStringAsFixed(3)}°',
                          icon: Icons.place_outlined,
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
    required IconData icon,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: highlight
                ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
                : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
          ),
          const SizedBox(width: 6),
          Column(
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
        ],
      ),
    );
  }

  void _showCreateParcelDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: 'Talhão ${handler.parcels.length + 1}');
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
          title: const Text('Cadastrar Novo Talhão de Arroz'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 440,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Identificação do Talhão'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: areaCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Área (ha)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: ecosystem,
                          decoration: const InputDecoration(labelText: 'Ecossistema'),
                          items: const [
                            DropdownMenuItem(value: 'Irrigated', child: Text('Irrigado')),
                            DropdownMenuItem(value: 'Rainfed Lowland', child: Text('Várzea')),
                            DropdownMenuItem(value: 'Upland', child: Text('Sequeiro')),
                          ],
                          onChanged: (v) => setDlgState(() => ecosystem = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: variety,
                    decoration: const InputDecoration(labelText: 'Varietal / Cultivar'),
                    items: const [
                      DropdownMenuItem(value: 'RD43', child: Text('RD43 (Baixo IG - Tailândia)')),
                      DropdownMenuItem(value: 'Chai Nat 1', child: Text('Chai Nat 1 (Alto Potencial)')),
                      DropdownMenuItem(value: 'Khao Dawk Mali 105', child: Text('KDML 105 (Jasmim)')),
                      DropdownMenuItem(value: 'BRS Pampa', child: Text('BRS Pampa (Embrapa Clima)')),
                      DropdownMenuItem(value: 'IR64', child: Text('IR64 (IRRI Referência)')),
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
                          decoration: const InputDecoration(labelText: 'Latitude (°)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: lonCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Longitude (°)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text('Data de Semeadura: '),
                      TextButton.icon(
                        icon: const Icon(Icons.date_range, size: 16),
                        label: Text(sowingDate.toIso8601String().split('T').first),
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
              child: const Text('Cancelar'),
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
                      const SnackBar(content: Text('Talhão cadastrado e sincronizado com o nó de borda!')),
                    );
                  }
                }
              },
              child: const Text('Salvar Talhão'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditParcelDialog(BuildContext context, FarmParcel parcel) {
    final nameCtrl = TextEditingController(text: parcel.name);
    final areaCtrl = TextEditingController(text: parcel.areaHectares.toString());
    DateTime sowingDate = parcel.sowingDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: Text('Editar ${parcel.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome do Talhão'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: areaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Área (ha)'),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Text('Data de Semeadura: '),
                  TextButton.icon(
                    icon: const Icon(Icons.date_range, size: 16),
                    label: Text(sowingDate.toIso8601String().split('T').first),
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
              child: const Text('Cancelar'),
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
                      const SnackBar(content: Text('Talhão atualizado no banco local!')),
                    );
                  }
                }
              },
              child: const Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteParcel(BuildContext context, FarmParcel parcel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Excluir ${parcel.name}?'),
        content: const Text(
          'Esta operação removerá o talhão e todos os seus registros climáticos do nó local do Raspberry Pi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final ok = await handler.deleteParcel(parcel.id);
              if (context.mounted) {
                Navigator.pop(ctx);
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Talhão excluído com sucesso.')),
                  );
                }
              }
            },
            child: const Text('Confirmar Exclusão', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
