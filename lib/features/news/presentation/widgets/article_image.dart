import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:orbit_news/widgets/app_cached_image.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.url,
    this.bytes,
    this.aspectRatio = 16 / 9,
  });

  final String url;
  final Uint8List? bytes;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AppCachedImage(url: url, bytes: bytes, aspectRatio: aspectRatio ,fit :BoxFit.cover);
  }
}
