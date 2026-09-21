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

  final List<Map<String, String>> _devices = [
    {
      'name': 'Raspberry Pi 5',
      'role': 'Gateway de Borda Central',
      'dwg': 'RPI5-DIN-001',
      'blueprintImg': 'assets/blueprint/01_rpi5_blueprint.jpg',
      'explodedImg': 'assets/blueprint/02_rpi5_exploded.jpg',
      'desc': 'Computador de borda quad-core Cortex-A76 @ 2.4GHz com HAT PCIe M.2 NVMe e montagem em trilho DIN de 35mm. Executa o runtime ONNX em 22.4 µs sem ventilador barulhento.',
      'specs': 'ARM Cortex-A76 (4 núcleos) • 4GB LPDDR4X • PCIe 2.0 • GbE • Dual micro-HDMI • Consumo: 5V/5A USB-C PD',
    },
    {
      'name': 'Raspberry Pi Zero 2 W',
      'role': 'Nó de Telemetria Ultracompacto',
      'dwg': 'RPZ2-FLD-002',
      'blueprintImg': 'assets/blueprint/03_rpizero2w_blueprint.jpg',
      'explodedImg': 'assets/blueprint/04_rpizero2w_exploded.jpg',
      'desc': 'Nó de campo de 65x30mm em gabinete IP68 com transceptor RS-485 Modbus, suporte para bateria de lítio 18650 e antena LoRa para comunicação de longo alcance.',
      'specs': 'RP3A0 SiP (4 núcleos A53 @ 1.0GHz) • 512MB RAM • RS-485 Modbus HAT • Célula 18650 • Consumo: < 0.7W',
    },
    {
      'name': 'ESP32-S3 LoRa (OLED)',
      'role': 'Transmissor de Talhão & Rádio',
      'dwg': 'ESP32-LRA-003',
      'blueprintImg': 'assets/blueprint/05_esp32_lora_blueprint.jpg',
      'explodedImg': 'assets/blueprint/06_esp32_lora_exploded.jpg',
      'desc': 'Microcontrolador ESP32-S3 acoplado ao rádio Semtech SX1262 LoRa e display OLED de 0.96". Caixa resistente a UV com visor frontal e prensa-cabos estanques.',
      'specs': 'Xtensa Dual-Core 240MHz • Rádio Semtech SX1262 (915MHz) • OLED 128x64 • Bateria LiPo 3.7V • Deep Sleep < 15µA',
    },
    {
      'name': 'Sonda de Nível Hidrostático',
      'role': 'Sensor de Lâmina d\'Água no Arrozal',
      'dwg': 'HWL-S10-004',
      'blueprintImg': 'assets/blueprint/07_water_sensor_blueprint.jpg',
      'explodedImg': 'assets/blueprint/08_water_sensor_exploded.jpg',
      'desc': 'Sonda submersível em aço inoxidável 316L com diafragma piezorresistivo e cabo ventilado para compensação barométrica contínua na lâmina de água (0 a 10 cm).',
      'specs': 'Corpo Inox 316L • Faixa: 0–1m H₂O • Sinal: RS-485 Modbus RTU • Proteção IP68 submersível • Cabo PUR com respiro',
    },
    {
      'name': 'Sonda de Solo & Lama 7-em-1',
      'role': 'Sensor de Nutrientes & Condutividade',
      'dwg': 'SN7-RS485-005',
      'blueprintImg': 'assets/blueprint/09_soil_probe_blueprint.jpg',
      'explodedImg': 'assets/blueprint/10_soil_probe_exploded.jpg',
      'desc': 'Sensor com 5 agulhas de aço cirúrgico para lama de arrozal. Medição simultânea de Umidade do Solo, Temperatura, Condutividade Elétrica (EC), pH, Nitrogênio, Fósforo e Potássio.',
      'specs': '5 Eletrodos SS316 • Modbus RTU (A+, B-, 9-30V) • FDR Dielectric coil • Resina epóxi impermeável • IP68',
    },
    {
      'name': 'Estação Solar Autônoma',
      'role': 'Gabinete IP67 & Alimentação de Campo',
      'dwg': 'SOL-STA-006',
      'blueprintImg': 'assets/blueprint/11_solar_station_blueprint.jpg',
      'explodedImg': 'assets/blueprint/12_solar_station_exploded.jpg',
      'desc': 'Conjunto autônomo completo para montagem em mastro na beira do dique: painel solar de 50W ajustável, controlador MPPT, bateria LiFePO4 de 12V e trilho DIN.',
      'specs': 'Painel Solar 50W Monocristalino • MPPT Solar Controller • Bateria LiFePO4 12V 20Ah • Caixa IP67 • Protetor contra surtos',
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Warm up image cache for seamless CAD drawing swaps
    for (final dev in _devices) {
      precacheImage(AssetImage(dev['blueprintImg']!), context);
      precacheImage(AssetImage(dev['explodedImg']!), context);
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
              constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 850),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

    final device = _devices[_selectedDevice];
    final activeImage = _showExploded ? device['explodedImg']! : device['blueprintImg']!;
    final modeLabel = _showExploded ? "VISTA EXPLODIDA 3D" : "BLUEPRINT CAD";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      constraints: const BoxConstraints(maxWidth: 1120),
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
                "ENGENHARIA DE HARDWARE IOT",
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
              fontSize: 32,
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
          const SizedBox(height: 28),

          // Device Selector Tabs (6 devices)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_devices.length, (idx) {
                final isSelected = idx == _selectedDevice;
                final dev = _devices[idx];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(dev['name']!),
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
          const SizedBox(height: 20),

          // Perspective Switcher: [ BLUEPRINT CAD ] ⇋ [ VISTA EXPLODIDA 3D ]
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
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

              // Zoom Fullscreen Button
              OutlinedButton.icon(
                onPressed: () => _openFullscreen(activeImage, device['name']!, modeLabel),
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
                  side: BorderSide(color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                  foregroundColor: textPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Interactive CAD Canvas Card
          ScrapbookCard(
            isDark: widget.isDark,
            tag: "DWG: ${device['dwg']}",
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Canvas
                GestureDetector(
                  onTap: () => _openFullscreen(activeImage, device['name']!, modeLabel),
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
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
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

                // CAD Metadata & Title Block
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${device['name']} • ${device['role']}",
                                  style: TextStyle(
                                    fontFamily: OryzaTypography.fontFamily,
                                    package: 'oryzaelo_ui',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  device['desc']!,
                                  style: TextStyle(
                                    fontFamily: OryzaTypography.fontFamily,
                                    package: 'oryzaelo_ui',
                                    fontSize: 13,
                                    color: textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "ESPECIFICAÇÃO: ${device['specs']}",
                              style: TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: OryzaColors.burntOrange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: OryzaColors.burntOrange.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              "ESBOÇO CONCEITUAL IA",
                              style: TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: OryzaColors.burntOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
              color: isSelected ? Colors.white : (widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : (widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
