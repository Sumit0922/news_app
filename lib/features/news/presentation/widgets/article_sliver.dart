import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:orbit_news/core/constants/app_tokens.dart';

import '../../domain/article.dart';
import 'article_card.dart';

class ArticleSliver extends StatelessWidget {
  const ArticleSliver({super.key, required this.articles});

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];

        return Column(
          key: ValueKey(article.id),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ArticleCard(article: article),
            if (index < articles.length - 1) AppSpacing.cardGap.verticalSpace,
          ],
        );
      },
    );
  }
}
