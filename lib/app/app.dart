import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_news/core/utils/app_snackbar.dart:.dart';
import 'package:orbit_news/widgets/app_screen_util.dart';
import 'package:orbit_news/widgets/state_panel.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/settings/domain/preferences_repository.dart';
import '../features/settings/presentation/theme_view_model.dart';
import 'providers.dart';
import 'router.dart';

class OrbitApp extends ConsumerStatefulWidget {
  const OrbitApp({super.key});

  @override
  ConsumerState<OrbitApp> createState() => _OrbitAppState();
}

class _OrbitAppState extends ConsumerState<OrbitApp> {
  bool _firstFrameReleased = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.deferFirstFrame();
  }

  void _releaseNativeSplash() {
    if (_firstFrameReleased) return;

    _firstFrameReleased = true;
    WidgetsBinding.instance.allowFirstFrame();
  }

  @override
  void dispose() {
    _releaseNativeSplash();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialization = ref.watch(localStoreInitializationProvider);

    return initialization.when(
      skipLoadingOnRefresh: false,
      skipLoadingOnReload: false,
      loading: () => const SizedBox.shrink(),
      data: (_) {
        _releaseNativeSplash();

        return const _ReadyApp();
      },
      error: (error, stackTrace) {
        _releaseNativeSplash();

        return _StartupErrorApp(
          onRetry: () {
            ref.invalidate(localStoreInitializationProvider);
          },
        );
      },
    );
  }
}

class _ReadyApp extends ConsumerWidget {
  const _ReadyApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingTheme = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return AppScreenUtil(
      builder: (context) {
        return MaterialApp.router(
          title: AppStrings.appName,
          scaffoldMessengerKey: appMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: switch (readingTheme) {
            ReadingTheme.system => ThemeMode.system,
            ReadingTheme.light => ThemeMode.light,
            ReadingTheme.dark => ThemeMode.dark,
          },
          routerConfig: router,
        );
      },
    );
  }
}

class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppScreenUtil(
      builder: (context) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: Scaffold(
            body: SafeArea(
              child: StatePanel(
                icon: Icons.storage_rounded,
                title: AppStrings.appName,
                message: AppStrings.startupError,
                action: AppStrings.retry,
                onAction: onRetry,
              ),
            ),
          ),
        );
      },
    );
  }
}
