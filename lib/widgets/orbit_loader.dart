import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/constants/app_tokens.dart';
import '../../core/constants/app_config.dart';
import '../../core/extensions/context_extensions.dart';

// A rotating orbital arc around a stationary news icon. No stock progress widget.
class OrbitLoader extends StatefulWidget {
  const OrbitLoader({super.key, this.size = 64, this.label});
  final double size;
  final String? label;
  @override
  State<OrbitLoader> createState() => _OrbitLoaderState();
}

class _OrbitLoaderState extends State<OrbitLoader>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppDurations.orbit,
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.label ?? AppStrings.loading,
    liveRegion: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: widget.size * 0.38,
                color: context.colors.primary,
              ),
              RotationTransition(
                turns: _controller,
                child: CustomPaint(
                  size: Size.square(widget.size),
                  painter: _OrbitPainter(context.colors.primary),
                ),
              ),
            ],
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.label!,
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    ),
  );
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(3);
    canvas.drawOval(
      rect,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 1.25,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3,
    );
    canvas.drawCircle(Offset(size.width / 2, 3), 3.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) =>
      oldDelegate.color != color;
}
