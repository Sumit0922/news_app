import 'package:flutter/material.dart';
import 'package:orbit_news/core/constants/app_config.dart';
import 'package:orbit_news/core/constants/app_tokens.dart';

class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, this.child});

  final Widget? child;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.orbit,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final tickerEnabled = TickerMode.valuesOf(context).enabled;

    if (reduceMotion || !tickerEnabled) {
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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = colors.brightness == Brightness.dark;

    final base = colors.surfaceContainerHighest;

    final highlight = dark
        ? Color.lerp(base, colors.onSurface, 0.10)!
        : Color.lerp(base, colors.surface, 0.75)!;

    final shape =
        widget.child ??
        const ColoredBox(color: AppColors.white, child: SizedBox.expand());

    if (MediaQuery.disableAnimationsOf(context)) {
      return ExcludeSemantics(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(base, BlendMode.srcIn),
          child: shape,
        ),
      );
    }

    return ExcludeSemantics(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          child: shape,
          builder: (context, child) {
            final position = _controller.value * 4;

            return ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(-3 + position, 0),
                  end: Alignment(-1 + position, 0),
                  colors: [base, highlight, base],
                  stops: const [0, 0.5, 1],
                ).createShader(bounds);
              },
              child: child,
            );
          },
        ),
      ),
    );
  }
}
