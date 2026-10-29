import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_config.dart';
import '../core/constants/app_strings.dart';
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

  bool _validUrl(String value) {
    final uri = Uri.tryParse(value);

    return uri != null &&
        uri.host.isNotEmpty &&
        ['http', 'https'].contains(uri.scheme);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final value = url?.trim() ?? '';
    final localBytes = bytes;

    return Semantics(
      image: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ColoredBox(
              color: colors.surfaceContainerHighest,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final logicalWidth = constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : 600.0;

                  final decodeWidth = (
                      logicalWidth *
                          MediaQuery.devicePixelRatioOf(context)
                  ).round().clamp(64, 1600).toInt();

                  if (localBytes != null && localBytes.isNotEmpty) {
                    return Image.memory(
                      localBytes,
                      fit: fit,
                      width: double.infinity,
                      height: double.infinity,
                      cacheWidth: decodeWidth,
                      gaplessPlayback: true,
                      filterQuality: FilterQuality.medium,
                      frameBuilder: (
                          context,
                          child,
                          frame,
                          synchronouslyLoaded,
                          ) {
                        if (synchronouslyLoaded || frame != null) {
                          return child;
                        }

                        return const AppShimmer();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _networkImage(
                          context,
                          value,
                          decodeWidth,
                        );
                      },
                    );
                  }

                  return _networkImage(
                    context,
                    value,
                    decodeWidth,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _networkImage(
      BuildContext context,
      String value,
      int decodeWidth,
      ) {
    if (!_validUrl(value)) {
      return const _ImageFallback();
    }

    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return CachedNetworkImage(
      key: ValueKey(value),
      imageUrl: value,
      cacheKey: value,
      width: double.infinity,
      height: double.infinity,
      fit: fit,
      memCacheWidth: decodeWidth,
      filterQuality: FilterQuality.medium,
      useOldImageOnUrlChange: false,
      placeholderFadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      fadeInDuration: reduceMotion
          ? Duration.zero
          : AppDurations.imageFade,
      fadeInCurve: Curves.easeOutCubic,
      placeholder: (context, url) => const AppShimmer(),
      errorWidget: (context, url, error) {
        return const _ImageFallback();
      },
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.surfaceContainerHighest,
            colors.surfaceContainerLow,
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.image_outlined,
            size: 26,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}