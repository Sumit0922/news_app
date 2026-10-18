import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orbit_news/widgets/app_text.dart';
import 'package:orbit_news/widgets/glass_bottom_nav.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_tokens.dart';
import '../core/utils/app_responsive.dart';


class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _select(int index) {
    FocusManager.instance.primaryFocus?.unfocus();

    navigationShell.goBranch(index, initialLocation: false);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    final wide = MediaQuery.sizeOf(context).width >= AppSpacing.compactWidth;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: AppResponsive.space(48),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, size: AppResponsive.icon(24)),
            SizedBox(width: AppResponsive.space(AppSpacing.sm)),
            const AppText(AppStrings.appName, variant: AppTextStyle.title),
          ],
        ),
        actions: [
          if (wide)
            const Padding(
              padding: EdgeInsets.only(right: AppSpacing.lg),
              child: Center(
                child: AppText(
                  AppStrings.tagline,
                  variant: AppTextStyle.caption,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(bottom: false, child: navigationShell),
      bottomNavigationBar: keyboardOpen
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SafeArea(
                top: false,
                minimum: EdgeInsets.fromLTRB(
                  AppResponsive.space(20),
                  0,
                  AppResponsive.space(20),
                  6,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: GlassBottomNav(
                      selectedIndex: navigationShell.currentIndex,
                      onSelected: _select,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
