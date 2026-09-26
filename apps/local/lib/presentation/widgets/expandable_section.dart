import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Reusable scrapbook collapsible section container.
class ExpandableSection extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? tag;
  final IconData icon;
  final Widget child;
  final Widget? trailing;
  final bool initialExpanded;

  const ExpandableSection({
    super.key,
    required this.title,
    this.subtitle,
    this.tag,
    required this.icon,
    required this.child,
    this.trailing,
    this.initialExpanded = true,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ScrapbookCard(
        isDark: isDark,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Bar
            InkWell(
              onTap: _toggle,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.green.shade900.withValues(alpha: 0.3)
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Colors.green.shade800 : Colors.green.shade200,
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 20,
                        color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Ubuntu Sans',
                                ),
                              ),
                              if (widget.tag != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white10
                                        : Colors.black.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isDark ? Colors.white24 : Colors.black12,
                                    ),
                                  ),
                                  child: Text(
                                    widget.tag!,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                      fontFamily: 'Ubuntu Sans Mono',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                fontFamily: 'Ubuntu Sans',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.trailing != null) ...[
                      widget.trailing!,
                      const SizedBox(width: 8),
                    ],
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Collapsible Content
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
