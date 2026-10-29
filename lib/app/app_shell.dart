import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_strings.dart';
import '../widgets/glass_bottom_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _select(int index) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (index == navigationShell.currentIndex) return;

    navigationShell.goBranch(
      index,
      initialLocation: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final keyboardOpen =
        MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 58,
        titleSpacing: 20,
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 19,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
        actions: [
          if (MediaQuery.sizeOf(context).width >= 700)
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Center(
                child: Text(
                  AppStrings.tagline,
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: navigationShell,
      ),
      bottomNavigationBar: keyboardOpen
          ? null
          : SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 10),
        child: Align(
          heightFactor: 1,
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: GlassBottomNav(
              selectedIndex: navigationShell.currentIndex,
              onSelected: _select,
            ),
          ),
        ),
      ),
    );
  }
}