import 'package:flutter/material.dart';

/// Animates its children one by one with a staggered fade+slide entrance.
///
/// Usage:
/// ```dart
/// StaggeredColumn(
///   children: [Text('A'), Text('B'), Text('C')],
/// )
/// ```
class StaggeredColumn extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration interval;
  final double slideOffset;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  const StaggeredColumn({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 400),
    this.interval = const Duration(milliseconds: 80),
    this.slideOffset = 20.0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  State<StaggeredColumn> createState() => _StaggeredColumnState();
}

class _StaggeredColumnState extends State<StaggeredColumn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    final totalDuration = widget.duration +
        widget.interval * (widget.children.length - 1).clamp(0, 999);

    _controller = AnimationController(
      vsync: this,
      duration: totalDuration,
    );

    _buildAnimations();
    _controller.forward();
  }

  void _buildAnimations() {
    final total = _controller.duration!.inMilliseconds.toDouble();
    final dur = widget.duration.inMilliseconds.toDouble();
    final gap = widget.interval.inMilliseconds.toDouble();

    _fadeAnimations = [];
    _slideAnimations = [];

    for (int i = 0; i < widget.children.length; i++) {
      final start = (i * gap) / total;
      final end = ((i * gap) + dur) / total;

      final curved = CurvedAnimation(
        parent: _controller,
        curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
            curve: Curves.easeOutCubic),
      );

      _fadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(curved),
      );

      _slideAnimations.add(
        Tween<Offset>(
          begin: Offset(0, widget.slideOffset),
          end: Offset.zero,
        ).animate(curved),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
          children: List.generate(widget.children.length, (i) {
            return Transform.translate(
              offset: _slideAnimations[i].value,
              child: Opacity(
                opacity: _fadeAnimations[i].value,
                child: widget.children[i],
              ),
            );
          }),
        );
      },
    );
  }
}
