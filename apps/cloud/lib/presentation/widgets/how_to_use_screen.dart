import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/clipboard_service.dart';

class HowToUseScreen extends StatefulWidget {
  final bool isDark;

  const HowToUseScreen({super.key, required this.isDark});

  @override
  State<HowToUseScreen> createState() => _HowToUseScreenState();
}

class _HowToUseScreenState extends State<HowToUseScreen> {
  int _activeFlowIndex = 0; // 0 = Local Station, 1 = Cloud + AI
  String? _copiedSnippet;

  static const String _curlInstallCmd =
      "curl -fsSL https://oryzaelo.asodya.com/install.sh | bash";

  static const String _cloudPortalUrl = "https://oryzaelo.asodya.com";

  static const String _githubRepoUrl = "https://github.com/wilsonborba/oryzaelo_engine";
  static const String _githubIssuesUrl = "https://github.com/wilsonborba/oryzaelo_engine/issues";

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Failed to launch external url $url: $e");
    }
  }

  Future<void> _copyToClipboard(String text, String snippetId) async {
    try {
      await OryzaClipboard.copy(text);
      if (mounted) {
        setState(() => _copiedSnippet = snippetId);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _copiedSnippet == snippetId) {
            setState(() => _copiedSnippet = null);
          }
        });
      }
    } catch (e) {
      debugPrint("Failed to copy to clipboard: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final textPrimary =
        widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary =
        widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;
    final borderColor =
        widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final surfaceColor =
        widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final canvasColor =
        widget.isDark ? OryzaColors.darkCanvas : OryzaColors.lightCanvas;

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      color: canvasColor,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: isMobile ? 24 : 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header & Breadcrumb ───────────────────────────────────────
              _buildHeader(s, textPrimary, textSecondary, isMobile),
              const SizedBox(height: 28),

              // ── Flow Switcher Tabs (Local vs Cloud) ───────────────────────
              _buildFlowSelector(s, textPrimary, borderColor, surfaceColor, isMobile),
              const SizedBox(height: 32),

              // ── Flow Content Steps ────────────────────────────────────────
              if (_activeFlowIndex == 0)
                _buildLocalFlow(s, textPrimary, textSecondary, borderColor, surfaceColor, isMobile)
              else
                _buildCloudFlow(s, textPrimary, textSecondary, borderColor, surfaceColor, isMobile),

              const SizedBox(height: 48),

              // ── Service Managers Reference Matrix ─────────────────────────
              _buildServiceManagersSection(s, textPrimary, textSecondary, borderColor, surfaceColor, isMobile),
              const SizedBox(height: 36),

              // ── Engine REST API Reference ─────────────────────────────────
              _buildApiRoutesSection(s, textPrimary, textSecondary, borderColor, surfaceColor, isMobile),
              const SizedBox(height: 40),

              // ── GitHub Issues Support CTA ─────────────────────────────────
              _buildGithubSupportCard(s, textPrimary, textSecondary, borderColor, surfaceColor, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(OryzaStrings s, Color textPrimary, Color textSecondary, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: OryzaColors.burntOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: OryzaColors.burntOrange.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_outlined, size: 14, color: OryzaColors.burntOrange),
                  const SizedBox(width: 6),
                  Text(
                    s.howToUseSectionTag,
                    style: TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: OryzaColors.burntOrange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "v1.4.2 • DOCS",
              style: TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          s.howToUseTitle,
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: isMobile ? 26 : 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          s.howToUseSubtitle,
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: isMobile ? 14 : 16,
            height: 1.5,
            color: textSecondary,
          ),
        ),
      ],
    );
  }

  // ── Flow Selector (Local vs Cloud) ─────────────────────────────────────────
  Widget _buildFlowSelector(
    OryzaStrings s,
    Color textPrimary,
    Color borderColor,
    Color surfaceColor,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFlowTabButton(
            label: s.howToUseTabLocal,
            icon: Icons.router_outlined,
            badge: s.howToUseBadgeOffline,
            isSelected: _activeFlowIndex == 0,
            onTap: () => setState(() => _activeFlowIndex = 0),
          ),
          const SizedBox(width: 4),
          _buildFlowTabButton(
            label: s.howToUseTabCloud,
            icon: Icons.cloud_sync_outlined,
            badge: s.howToUseBadgeCloud,
            isSelected: _activeFlowIndex == 1,
            onTap: () => setState(() => _activeFlowIndex = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowTabButton({
    required String label,
    required IconData icon,
    required String badge,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final activeBg = widget.isDark ? const Color(0xFF251F19) : const Color(0xFFEFE8DB);
    final activeColor = OryzaColors.burntOrange;
    final inactiveColor = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: OryzaColors.burntOrange.withValues(alpha: 0.6)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isSelected ? activeColor : inactiveColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? OryzaColors.burntOrange.withValues(alpha: 0.15)
                    : (widget.isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Local Flow Steps ──────────────────────────────────────────────────────
  Widget _buildLocalFlow(
    OryzaStrings s,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Color surfaceColor,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step 1: Installation
        _buildStepCard(
          stepNumber: "01",
          title: s.howToUseLocalStep1Title,
          description: s.howToUseLocalStep1Desc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCodeBox(
                code: _curlInstallCmd,
                snippetId: "local_curl",
                language: "bash",
                s: s,
              ),
              const SizedBox(height: 12),
              _buildCalloutBox(
                type: CalloutType.tip,
                text: s.howToUseLocalStep1Tip,
              ),
            ],
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
        const SizedBox(height: 20),

        // Step 2: Service Manager
        _buildStepCard(
          stepNumber: "02",
          title: s.howToUseLocalStep2Title,
          description: s.howToUseLocalStep2Desc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCodeBox(
                code: s.howToUseLocalStep2Snippet,
                snippetId: "local_systemctl",
                language: "bash",
                s: s,
              ),
              const SizedBox(height: 10),
              Text(
                s.howToUseLocalStep2Note,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12.5,
                  color: textSecondary,
                ),
              ),
            ],
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
        const SizedBox(height: 20),

        // Step 3: Environment Variables & Port
        _buildStepCard(
          stepNumber: "03",
          title: s.howToUseLocalStep3Title,
          description: s.howToUseLocalStep3Desc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCodeBox(
                code: s.howToUseLocalStep3Snippet,
                snippetId: "local_env",
                language: "env",
                s: s,
              ),
              const SizedBox(height: 12),
              _buildCalloutBox(
                type: CalloutType.important,
                text: s.howToUseLocalStep3Callout,
              ),
            ],
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
        const SizedBox(height: 20),

        // Step 4: Local Dashboard Navigation
        _buildStepCard(
          stepNumber: "04",
          title: s.howToUseLocalStep4Title,
          description: s.howToUseLocalStep4Desc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFF3F1E7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language, size: 18, color: OryzaColors.burntOrange),
                            const SizedBox(width: 8),
                            Text(
                              s.howToUseLocalAccessLabel,
                              style: TextStyle(
                                fontFamily: OryzaTypography.fontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SelectableText(
                          "http://<IP-DO-DISPOSITIVO>:8080",
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: OryzaColors.burntOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.howToUseLocalAccessDesc,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 13,
                        height: 1.5,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
        const SizedBox(height: 20),

        // Step 5: Engine API Routes
        _buildStepCard(
          stepNumber: "05",
          title: s.howToUseLocalStep5Title,
          description: s.howToUseLocalStep5Desc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCodeBox(
                code: s.howToUseLocalApiSnippet,
                snippetId: "local_api_curl",
                language: "bash",
                s: s,
              ),
            ],
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
        const SizedBox(height: 20),

        // Step 6: Mock & Evaluation Mode (Testing Without Physical Sensors)
        _buildStepCard(
          stepNumber: "06",
          title: s.howToUseMockTitle,
          description: s.howToUseMockDesc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Option 1: Web UI 1-Click
              Text(
                s.howToUseMockOptionUiTitle,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                s.howToUseMockOptionUiDesc,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12.5,
                  height: 1.5,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFF3F1E7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade900.withValues(alpha: widget.isDark ? 0.3 : 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green.shade700),
                          ),
                          child: Text(
                            s.loadDemoDataBtn,
                            style: TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: widget.isDark ? Colors.green.shade300 : Colors.green.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            s.demoDataLoadedSuccess,
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
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade900.withValues(alpha: widget.isDark ? 0.3 : 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.red.shade700),
                          ),
                          child: Text(
                            s.cleanDemoDataBtn,
                            style: TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: widget.isDark ? Colors.red.shade300 : Colors.red.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            s.demoDataCleanedSuccess,
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
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Option 2: CLI Terminal
              Text(
                s.howToUseMockOptionCliTitle,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                s.howToUseMockOptionCliDesc,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12.5,
                  height: 1.5,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              _buildCodeBox(
                code: s.howToUseMockPopulateSnippet,
                snippetId: "mock_populate_script",
                language: "bash",
                s: s,
              ),
            ],
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
      ],
    );
  }

  // ── Cloud Flow Steps ──────────────────────────────────────────────────────
  Widget _buildCloudFlow(
    OryzaStrings s,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Color surfaceColor,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step 1: Install
        _buildStepCard(
          stepNumber: "01",
          title: s.howToUseCloudStep1Title,
          description: s.howToUseCloudStep1Desc,
          child: _buildCodeBox(
            code: _curlInstallCmd,
            snippetId: "cloud_curl",
            language: "bash",
            s: s,
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
        const SizedBox(height: 20),

        // Step 2: Account Creation
        _buildStepCard(
          stepNumber: "02",
          title: s.howToUseCloudStep2Title,
          description: s.howToUseCloudStep2Desc,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFF3F1E7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.vpn_key_outlined, color: OryzaColors.mustardYellow, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.howToUseCloudAccountTitle,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.howToUseCloudAccountDesc,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 12.5,
                          height: 1.4,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
        const SizedBox(height: 20),

        // Step 3: Link Edge Station
        _buildStepCard(
          stepNumber: "03",
          title: s.howToUseCloudStep3Title,
          description: s.howToUseCloudStep3Desc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCodeBox(
                code: s.howToUseCloudStep3Snippet,
                snippetId: "cloud_env",
                language: "env",
                s: s,
              ),
              const SizedBox(height: 12),
              _buildCalloutBox(
                type: CalloutType.tip,
                text: s.howToUseCloudStep3Tip,
              ),
            ],
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
        const SizedBox(height: 20),

        // Step 4: Cloud Dashboard Navigation
        _buildStepCard(
          stepNumber: "04",
          title: s.howToUseCloudStep4Title,
          description: s.howToUseCloudStep4Desc,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFF3F1E7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_outlined, size: 18, color: OryzaColors.burntOrange),
                        const SizedBox(width: 8),
                        Text(
                          s.howToUseCloudAccessLabel,
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SelectableText(
                          _cloudPortalUrl,
                          onTap: () => _launchExternalUrl(_cloudPortalUrl),
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            color: OryzaColors.burntOrange,
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => _launchExternalUrl(_cloudPortalUrl),
                          borderRadius: BorderRadius.circular(4),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.open_in_new, size: 13, color: OryzaColors.burntOrange),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  s.howToUseCloudAccessDesc,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 13,
                    height: 1.5,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
        const SizedBox(height: 20),

        // Step 5: Agronomic AI Insights
        _buildStepCard(
          stepNumber: "05",
          title: s.howToUseCloudStep5Title,
          description: s.howToUseCloudStep5Desc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: OryzaColors.burntOrange.withValues(alpha: widget.isDark ? 0.08 : 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: OryzaColors.burntOrange.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: OryzaColors.burntOrange, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          s.howToUseCloudAiTitle,
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      s.howToUseCloudAiDesc,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 13,
                        height: 1.5,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          borderColor: borderColor,
          surfaceColor: surfaceColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          isMobile: isMobile,
        ),
      ],
    );
  }

  // ── Step Card Builder ─────────────────────────────────────────────────────
  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String description,
    required Widget child,
    required Color borderColor,
    required Color surfaceColor,
    required Color textPrimary,
    required Color textSecondary,
    required bool isMobile,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: OryzaColors.burntOrange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  stepNumber,
                  style: const TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 13.5,
              height: 1.5,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // ── Service Managers Section ──────────────────────────────────────────────
  Widget _buildServiceManagersSection(
    OryzaStrings s,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Color surfaceColor,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.terminal_outlined, color: OryzaColors.burntOrange, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.howToUseServiceHeading,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          s.howToUseServiceSubtitle,
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: 13.5,
            height: 1.5,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // 3 Cards: systemd, OpenRC, runit
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildServiceCard(
                      name: s.howToUseServiceSystemd,
                      distros: s.howToUseServiceSystemdDesc,
                      cmd: "sudo systemctl enable --now oryzaelo_engine",
                      unitPath: "/etc/systemd/system/oryzaelo_engine.service",
                      docsUrl: "https://systemd.io/",
                      s: s,
                      borderColor: borderColor,
                      surfaceColor: surfaceColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildServiceCard(
                      name: s.howToUseServiceOpenrc,
                      distros: s.howToUseServiceOpenrcDesc,
                      cmd: "sudo rc-update add oryzaelo_engine default\nsudo rc-service oryzaelo_engine start",
                      unitPath: "/etc/init.d/oryzaelo_engine",
                      docsUrl: "https://wiki.alpinelinux.org/wiki/OpenRC",
                      s: s,
                      borderColor: borderColor,
                      surfaceColor: surfaceColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildServiceCard(
                      name: s.howToUseServiceRunit,
                      distros: s.howToUseServiceRunitDesc,
                      cmd: "sudo ln -s /etc/sv/oryzaelo_engine /var/service/",
                      unitPath: "/etc/sv/oryzaelo_engine/run",
                      docsUrl: "https://docs.voidlinux.org/config/services/",
                      s: s,
                      borderColor: borderColor,
                      surfaceColor: surfaceColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildServiceCard(
                    name: s.howToUseServiceSystemd,
                    distros: s.howToUseServiceSystemdDesc,
                    cmd: "sudo systemctl enable --now oryzaelo_engine",
                    unitPath: "/etc/systemd/system/oryzaelo_engine.service",
                    docsUrl: "https://systemd.io/",
                    s: s,
                    borderColor: borderColor,
                    surfaceColor: surfaceColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceCard(
                    name: s.howToUseServiceOpenrc,
                    distros: s.howToUseServiceOpenrcDesc,
                    cmd: "sudo rc-update add oryzaelo_engine default\nsudo rc-service oryzaelo_engine start",
                    unitPath: "/etc/init.d/oryzaelo_engine",
                    docsUrl: "https://wiki.alpinelinux.org/wiki/OpenRC",
                    s: s,
                    borderColor: borderColor,
                    surfaceColor: surfaceColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceCard(
                    name: s.howToUseServiceRunit,
                    distros: s.howToUseServiceRunitDesc,
                    cmd: "sudo ln -s /etc/sv/oryzaelo_engine /var/service/",
                    unitPath: "/etc/sv/oryzaelo_engine/run",
                    docsUrl: "https://docs.voidlinux.org/config/services/",
                    s: s,
                    borderColor: borderColor,
                    surfaceColor: surfaceColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String name,
    required String distros,
    required String cmd,
    required String unitPath,
    required String docsUrl,
    required OryzaStrings s,
    required Color borderColor,
    required Color surfaceColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: OryzaColors.burntOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: OryzaColors.burntOrange,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _launchExternalUrl(docsUrl),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.open_in_new, size: 12, color: OryzaColors.burntOrange),
                      const SizedBox(width: 4),
                      Text(
                        s.howToUseServiceDocsLink,
                        style: const TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: OryzaColors.burntOrange,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            distros,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 12,
              height: 1.4,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          _buildCodeBox(
            code: cmd,
            snippetId: "svc_$name",
            language: "bash",
            s: s,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "${s.howToUseServiceUnitLabel} ",
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 10,
                  color: textSecondary,
                ),
              ),
              Expanded(
                child: SelectableText(
                  unitPath,
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 10,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${s.howToUseServiceDocsLabel} ",
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 10,
                  color: textSecondary,
                ),
              ),
              Expanded(
                child: SelectableText(
                  docsUrl,
                  onTap: () => _launchExternalUrl(docsUrl),
                  style: const TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 10,
                    color: OryzaColors.burntOrange,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Engine API Routes Reference ───────────────────────────────────────────
  Widget _buildApiRoutesSection(
    OryzaStrings s,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Color surfaceColor,
    bool isMobile,
  ) {
    final routes = [
      (
        method: "GET",
        path: "/health",
        desc: s.howToUseApiRouteHealthDesc,
        example: '{"status":"ok","uptime_secs":34120,"temp_c":38.2,"battery_v":12.4}',
      ),
      (
        method: "GET",
        path: "/api/v1/readings",
        desc: s.howToUseApiRouteReadingsDesc,
        example: '{"water_depth_cm":7.5,"soil_temp_c":21.3,"ambient_temp_c":27.8}',
      ),
      (
        method: "GET",
        path: "/api/v1/phenology",
        desc: s.howToUseApiRoutePhenologyDesc,
        example: '{"bbch_stage":25,"accumulated_gdd":432.5,"cultivar":"BRS Querência"}',
      ),
      (
        method: "POST",
        path: "/api/v1/inference",
        desc: s.howToUseApiRouteInferenceDesc,
        example: s.howToUseApiRouteInferenceExample,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.api_outlined, color: OryzaColors.burntOrange, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.howToUseApiHeading,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          s.howToUseApiSubtitle,
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: 13.5,
            height: 1.5,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 16),

        Column(
          children: routes.map((r) {
            final isGet = r.method == "GET";
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: isGet
                              ? OryzaColors.militaryGreen.withValues(alpha: 0.15)
                              : OryzaColors.burntOrange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          r.method,
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isGet ? OryzaColors.militaryGreen : OryzaColors.burntOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SelectableText(
                        r.path,
                        style: TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r.desc,
                    style: TextStyle(
                      fontFamily: OryzaTypography.fontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 12.5,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    r.example,
                    style: TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 11,
                      color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── GitHub Support CTA ────────────────────────────────────────────────────
  Widget _buildGithubSupportCard(
    OryzaStrings s,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Color surfaceColor,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OryzaColors.burntOrange.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: OryzaColors.burntOrange.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: OryzaColors.burntOrange.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bug_report_outlined, color: OryzaColors.burntOrange, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  s.howToUseGithubCtaTitle,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            s.howToUseGithubCtaDesc,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 13.5,
              height: 1.5,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          if (isMobile) ...[
            ElevatedButton.icon(
              onPressed: () => _launchExternalUrl(_githubIssuesUrl),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: Text(s.howToUseGithubBtn),
              style: ElevatedButton.styleFrom(
                backgroundColor: OryzaColors.burntOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                textStyle: const TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    _githubIssuesUrl,
                    onTap: () => _launchExternalUrl(_githubIssuesUrl),
                    style: const TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 11.5,
                      color: OryzaColors.burntOrange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _copiedSnippet == "gh_issue_link" ? Icons.check : Icons.copy,
                    size: 15,
                    color: _copiedSnippet == "gh_issue_link" ? OryzaColors.mustardYellow : textSecondary,
                  ),
                  tooltip: s.howToUseBtnCopy,
                  onPressed: () => _copyToClipboard(_githubIssuesUrl, "gh_issue_link"),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _launchExternalUrl(_githubIssuesUrl),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text(s.howToUseGithubBtn),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OryzaColors.burntOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    textStyle: const TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.link, size: 14, color: OryzaColors.burntOrange),
                      const SizedBox(width: 6),
                      Flexible(
                        child: SelectableText(
                          _githubIssuesUrl,
                          onTap: () => _launchExternalUrl(_githubIssuesUrl),
                          style: const TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 11.5,
                            color: OryzaColors.burntOrange,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _copiedSnippet == "gh_issue_link" ? Icons.check : Icons.copy,
                    size: 15,
                    color: _copiedSnippet == "gh_issue_link" ? OryzaColors.mustardYellow : textSecondary,
                  ),
                  tooltip: s.howToUseBtnCopy,
                  onPressed: () => _copyToClipboard(_githubIssuesUrl, "gh_issue_link"),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                ),
              ],
            ),
          ],
          if (_copiedSnippet == "gh_issue_link") ...[
            const SizedBox(height: 8),
            Text(
              s.howToUseCopiedFeedback,
              style: const TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: OryzaColors.militaryGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Code Box with Copy Button ─────────────────────────────────────────────
  Widget _buildCodeBox({
    required String code,
    required String snippetId,
    required String language,
    required OryzaStrings s,
  }) {
    final isCopied = _copiedSnippet == snippetId;
    final codeBg = widget.isDark ? const Color(0xFF0F1410) : const Color(0xFF1E231E);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: codeBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.isDark ? OryzaColors.darkBorder : Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Colors.white54,
                  ),
                ),
                InkWell(
                  onTap: () => _copyToClipboard(code, snippetId),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCopied ? Icons.check : Icons.copy,
                          size: 13,
                          color: isCopied ? OryzaColors.mustardYellow : Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isCopied ? s.howToUseBtnCopied : s.howToUseBtnCopy,
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isCopied ? OryzaColors.mustardYellow : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code Text
          Padding(
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                code,
                style: const TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12,
                  height: 1.45,
                  color: Color(0xFFD4E0D4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Callout Box (Tip / Important) ─────────────────────────────────────────
  Widget _buildCalloutBox({required CalloutType type, required String text}) {
    final isTip = type == CalloutType.tip;
    final icon = isTip ? Icons.lightbulb_outline : Icons.info_outline;
    final color = isTip ? OryzaColors.militaryGreen : OryzaColors.burntOrange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: widget.isDark ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: color, width: 3.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12.5,
                height: 1.4,
                color: widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum CalloutType { tip, important }
