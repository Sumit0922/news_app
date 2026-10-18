import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_tokens.dart';
import '../../core/utils/app_responsive.dart';

class GlassBottomNav extends StatefulWidget {
  const GlassBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<GlassBottomNav> createState() => _GlassBottomNavState();
}

class _GlassBottomNavState extends State<GlassBottomNav> {
  double? _dragX;

  static const _labels = [
    AppStrings.discover,
    AppStrings.bookmarks,
    AppStrings.settings,
  ];

  static const _icons = [
    Icons.explore_outlined,
    Icons.bookmarks_outlined,
    Icons.tune_rounded,
  ];

  static const _activeIcons = [
    Icons.explore_rounded,
    Icons.bookmarks_rounded,
    Icons.tune_rounded,
  ];

  void _select(int index) {
    if (index != widget.selectedIndex) {
      widget.onSelected(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = scheme.brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final iconSize = AppResponsive.icon(20);

    final labelHeight =
        MediaQuery.textScalerOf(context)
            .scale(AppFontSizes.caption.sp) *
            1.25;

    final height = math.max(
      48.0,
      math.max(
        AppResponsive.space(48),
        iconSize + labelHeight + 12,
      ),
    );

    final radius = AppResponsive.radius(26);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: dark ? 0.28 : 0.13),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: dark ? 0.82 : 0.76),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: scheme.onSurface.withValues(alpha: dark ? 0.15 : 0.08),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SizedBox(
                height: height,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final itemWidth = width / _labels.length;

                    final rtl = Directionality.of(context) == TextDirection.rtl;

                    double logicalX(double x) {
                      return rtl ? width - x : x;
                    }

                    final indicatorStart = _dragX == null
                        ? itemWidth * widget.selectedIndex
                        : (logicalX(_dragX!) - itemWidth / 2)
                              .clamp(0.0, width - itemWidth)
                              .toDouble();

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragStart: (details) {
                        setState(() {
                          _dragX = details.localPosition.dx;
                        });
                      },
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _dragX = details.localPosition.dx;
                        });
                      },
                      onHorizontalDragCancel: () {
                        setState(() {
                          _dragX = null;
                        });
                      },
                      onHorizontalDragEnd: (_) {
                        final index = (logicalX(_dragX ?? 0) / itemWidth)
                            .floor()
                            .clamp(0, _labels.length - 1)
                            .toInt();

                        setState(() {
                          _dragX = null;
                        });

                        _select(index);
                      },
                      child: Stack(
                        children: [
                          AnimatedPositionedDirectional(
                            duration: reduceMotion || _dragX != null
                                ? Duration.zero
                                : AppDurations.normal,
                            curve: Curves.easeOutCubic,
                            start: indicatorStart,
                            top: 0,
                            bottom: 0,
                            width: itemWidth,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(
                                  alpha: dark ? 0.25 : 0.12,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppResponsive.radius(22),
                                ),
                                border: Border.all(
                                  color: scheme.primary.withValues(alpha: 0.12),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: List.generate(_labels.length, (index) {
                              final selected = index == widget.selectedIndex;

                              final color = selected
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant;

                              return Expanded(
                                child: Semantics(
                                  button: true,
                                  selected: selected,
                                  label: _labels[index],
                                  onTap: () => _select(index),
                                  excludeSemantics: true,
                                  child: Material(
                                    color: AppColors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                        AppResponsive.radius(22),
                                      ),
                                      onTap: () => _select(index),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              selected
                                                  ? _activeIcons[index]
                                                  : _icons[index],
                                              size: iconSize,
                                              color: color,
                                            ),
                                            3.verticalSpace,
                                            Text(
                                              _labels[index],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: color,
                                                    fontWeight: selected
                                                        ? FontWeight.w800
                                                        : FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
