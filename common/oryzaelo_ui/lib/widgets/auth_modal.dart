import 'package:flutter/material.dart';
import '../core/i18n.dart';
import '../core/theme.dart';

class AuthModal extends StatefulWidget {
  final bool isDark;
  final bool initialSignUp;

  const AuthModal({
    super.key,
    required this.isDark,
    this.initialSignUp = false,
  });

  static Future<void> show(BuildContext context, {bool isSignUp = false, required bool isDark}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AuthModal(
        isDark: isDark,
        initialSignUp: isSignUp,
      ),
    );
  }

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  late bool _isSignUp;
  String _selectedRole = 'farmer';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialSignUp;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final surfaceColor = widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: widget.isDark ? 0.8 : 0.25),
              offset: const Offset(6, 6),
              blurRadius: 0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Tag & Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? OryzaColors.burntOrange.withValues(alpha: 0.18)
                            : OryzaColors.burntOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: OryzaColors.burntOrange.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        "ASODYA SECURE GATEWAY",
                        style: TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: OryzaColors.burntOrange,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      color: textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  s.authTitle,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                // Tabs: Login vs Sign Up
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFEFECE2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _isSignUp = false;
                            _submitted = false;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: !_isSignUp
                                  ? (widget.isDark ? OryzaColors.darkSurface : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: !_isSignUp
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              s.authLoginTab,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: OryzaTypography.fontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 13,
                                fontWeight: !_isSignUp ? FontWeight.w700 : FontWeight.w500,
                                color: !_isSignUp ? textPrimary : textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _isSignUp = true;
                            _submitted = false;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _isSignUp
                                  ? (widget.isDark ? OryzaColors.darkSurface : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: _isSignUp
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              s.authSignUpTab,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: OryzaTypography.fontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 13,
                                fontWeight: _isSignUp ? FontWeight.w700 : FontWeight.w500,
                                color: _isSignUp ? textPrimary : textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                if (_submitted)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.isDark ? const Color(0xFF1B291B) : const Color(0xFFEAF5EA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF48BB78)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle_outline, color: Color(0xFF48BB78), size: 28),
                        const SizedBox(height: 8),
                        Text(
                          _isSignUp ? "Cadastro registrado com sucesso!" : "Autenticação simulada com sucesso!",
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Redirecionando para o ambiente de testes...",
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  // Role Selector
                  if (_isSignUp) ...[
                    Text(
                      s.authRole,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFF9F8F4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          isExpanded: true,
                          dropdownColor: surfaceColor,
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 13,
                            color: textPrimary,
                          ),
                          items: [
                            DropdownMenuItem(value: 'farmer', child: Text(s.authRoleFarmer)),
                            DropdownMenuItem(value: 'researcher', child: Text(s.authRoleResearcher)),
                            DropdownMenuItem(value: 'edge', child: Text(s.authRoleEdge)),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedRole = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Email
                  Text(
                    s.authEmail,
                    style: TextStyle(
                      fontFamily: OryzaTypography.fontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    style: TextStyle(
                      fontFamily: OryzaTypography.fontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 13,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: "nome@esalq.usp.br",
                      hintStyle: TextStyle(
                        color: textSecondary.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: widget.isDark ? const Color(0xFF141914) : const Color(0xFFF9F8F4),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: OryzaColors.burntOrange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Password
                  Text(
                    s.authPassword,
                    style: TextStyle(
                      fontFamily: OryzaTypography.fontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(
                      fontFamily: OryzaTypography.fontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 13,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      hintStyle: TextStyle(
                        color: textSecondary.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: widget.isDark ? const Color(0xFF141914) : const Color(0xFFF9F8F4),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: OryzaColors.burntOrange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _submitted = true);
                        final nav = Navigator.of(context);
                        Future.delayed(const Duration(milliseconds: 1400), () {
                          if (mounted) nav.pop();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OryzaColors.burntOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isSignUp ? s.authSignUpTab : s.authSubmit,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
