import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/app_responsive.dart';
import 'app_shimmer.dart';

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    this.url,
    this.bytes,
    this.aspectRatio = 16 / 9,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.semanticLabel = AppStrings.storyImage,
  });

  final String? url;
  final Uint8List? bytes;
  final double aspectRatio;
  final double borderRadius;
  final BoxFit fit;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final background = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Semantics(
      image: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(borderRadius),
          ),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ColoredBox(
              color: background,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final value = url?.trim() ?? '';
                  final localBytes = bytes;

                  final hasLocal = localBytes != null && localBytes.isNotEmpty;

                  final uri = Uri.tryParse(value);

                  final validUrl =
                      uri != null &&
                      uri.host.isNotEmpty &&
                      ['https', 'http'].contains(uri.scheme);

                  if (!hasLocal && !validUrl) {
                    return const _ImageFallback();
                  }

                  final ImageProvider<Object> provider = hasLocal
                      ? MemoryImage(localBytes!)
                      : CachedNetworkImageProvider(value);

                  // Preserve the widget identity during ordinary rebuilds.
                  final sourceKey = value.isNotEmpty ? value : localBytes;

                  final width = constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : 600.0;

                  final decodeWidth =
                      (width * MediaQuery.devicePixelRatioOf(context))
                          .round()
                          .clamp(64, 1600)
                          .toInt();

                  return Image(
                    key: ValueKey(sourceKey),
                    image: ResizeImage.resizeIfNeeded(
                      decodeWidth,
                      null,
                      provider,
                    ),
                    fit: fit,
                    filterQuality: FilterQuality.medium,
                    frameBuilder: (context, child, frame, synchronouslyLoaded) {
                      if (frame == null && !synchronouslyLoaded) {
                        return const AppShimmer();
                      }

                      if (reduceMotion) {
                        return child;
                      }

                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: AppDurations.imageFade,
                        curve: Curves.easeOutCubic,
                        child: child,
                        builder: (context, opacity, image) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              // Remove the shimmer after the fade finishes.
                              if (opacity < 1)
                                Opacity(
                                  opacity: 1 - opacity,
                                  child: const AppShimmer(),
                                ),
                              Opacity(opacity: opacity, child: image),
                            ],
                          );
                        },
                      );
                    },
                    errorBuilder: (_, _, _) {
                      return const _ImageFallback();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colors.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: AppResponsive.icon(30),
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
