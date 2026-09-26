import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Wraps horizontally-scrolling content with visible previous/next arrow
/// buttons on either side, instead of relying on an unlabeled swipe gesture
/// that many users won't discover on their own.
///
/// Arrows auto-disable (greyed, non-interactive) at each scroll boundary,
/// and the whole affordance quietly disappears if the content never
/// actually overflows (nothing to scroll).
class OryzaHorizontalScroller extends StatefulWidget {
  final Widget child;
  final bool isDark;

  /// Reuse an existing controller (e.g. one another widget also uses to
  /// auto-scroll-to-current) instead of creating a new one.
  final ScrollController? controller;

  /// Pixels to scroll per arrow tap.
  final double step;

  final EdgeInsetsGeometry? padding;

  const OryzaHorizontalScroller({
    super.key,
    required this.child,
    required this.isDark,
    this.controller,
    this.step = 160,
    this.padding,
  });

  @override
  State<OryzaHorizontalScroller> createState() => _OryzaHorizontalScrollerState();
}

class _OryzaHorizontalScrollerState extends State<OryzaHorizontalScroller> {
  late final ScrollController _controller;
  bool _ownsController = false;
  bool _canScrollLeft = false;
  bool _canScrollRight = false;
  bool _hasOverflow = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = ScrollController();
      _ownsController = true;
    }
    _controller.addListener(_updateArrowState);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateArrowState());
  }

  @override
  void didUpdateWidget(covariant OryzaHorizontalScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Content (e.g. locale text, item count) may have changed size.
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateArrowState());
  }

  void _updateArrowState() {
    if (!mounted || !_controller.hasClients) return;
    final pos = _controller.position;
    final overflow = pos.maxScrollExtent > 0;
    final canLeft = pos.pixels > 4;
    final canRight = pos.pixels < pos.maxScrollExtent - 4;
    if (overflow != _hasOverflow || canLeft != _canScrollLeft || canRight != _canScrollRight) {
      setState(() {
        _hasOverflow = overflow;
        _canScrollLeft = canLeft;
        _canScrollRight = canRight;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateArrowState);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _scrollBy(double delta) {
    if (!_controller.hasClients) return;
    final target = (_controller.offset + delta).clamp(0.0, _controller.position.maxScrollExtent);
    _controller.animateTo(target, duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      padding: widget.padding,
      child: widget.child,
    );

    if (!_hasOverflow) return scrollView;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _arrowButton(
          icon: Icons.chevron_left_rounded,
          onTap: _canScrollLeft ? () => _scrollBy(-widget.step) : null,
        ),
        Expanded(child: scrollView),
        _arrowButton(
          icon: Icons.chevron_right_rounded,
          onTap: _canScrollRight ? () => _scrollBy(widget.step) : null,
        ),
      ],
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback? onTap}) {
    final isDark = widget.isDark;
    final enabled = onTap != null;
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.2),
            ),
            child: Icon(
              icon,
              size: 18,
              color: enabled
                  ? (isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary)
                  : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
          ),
        ),
      ),
    );
  }
}
