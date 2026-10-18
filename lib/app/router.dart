import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbit_news/widgets/state_panel.dart';

import '../core/constants/app_strings.dart';
import '../features/auth/presentation/auth_view_model.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/news/domain/article.dart';
import '../features/news/presentation/article_screen.dart';
import '../features/news/presentation/bookmarks_screen.dart';
import '../features/news/presentation/home_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'app_shell.dart';

class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.listen(
    authProvider.select((state) => state.email),
    (_, _) => refresh.refresh(),
  );
  final router = GoRouter(
    initialLocation: '/discover',
    refreshListenable: refresh,
    redirect: (context, state) {
      final signedIn = ref.read(authProvider).email != null;
      final atLogin = state.matchedLocation == '/login';
      if (!signedIn && !atLogin) return '/login';
      if (signedIn && atLogin) return '/discover';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/discover', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved',
                builder: (_, _) => const BookmarksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/article/:id',
        builder: (_, state) => ArticleScreen(
          id: int.tryParse(state.pathParameters['id'] ?? ''),
          initialArticle: state.extra is Article
              ? state.extra as Article
              : null,
        ),
      ),
    ],
    errorBuilder: (context, _) => Scaffold(
      body: SafeArea(
        child: StatePanel(
          icon: Icons.wrong_location_outlined,
          title: AppStrings.noResults,
          message: AppStrings.storyMissing,
          action: AppStrings.backToFeed,
          onAction: () => context.go('/discover'),
        ),
      ),
    ),
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
