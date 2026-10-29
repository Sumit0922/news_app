import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/errors/failure_message.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/orbit_loader.dart';
import '../../../widgets/responsive_body.dart';
import '../../auth/presentation/auth_view_model.dart';
import '../domain/preferences_repository.dart';
import 'theme_view_model.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _savingTheme = false;
  bool _logoutDialogOpen = false;

  Future<void> _changeTheme(ReadingTheme value) async {
    if (_savingTheme ||
        ref.read(authProvider).busy ||
        value == ref.read(themeProvider)) {
      return;
    }

    setState(() => _savingTheme = true);

    try {
      await ref.read(themeProvider.notifier).setTheme(value);
    } catch (error) {
      if (mounted) {
        context.showMessage(failureMessage(error));
      }
    } finally {
      if (mounted) {
        setState(() => _savingTheme = false);
      }
    }
  }

  Future<void> _confirmLogout() async {
    if (_logoutDialogOpen || _savingTheme || ref.read(authProvider).busy) {
      return;
    }

    setState(() => _logoutDialogOpen = true);

    bool? confirmed;

    try {
      confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          final theme = Theme.of(dialogContext);
          final colors = theme.colorScheme;

          return AlertDialog(
            backgroundColor: colors.surface,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: colors.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 21,
                    color: colors.error,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Ready to leave?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            content: Text(
              AppStrings.logoutBody,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text(AppStrings.cancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.error,
                  foregroundColor: colors.onError,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text(AppStrings.logout),
              ),
            ],
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() => _logoutDialogOpen = false);
      }
    }

    if (!mounted || confirmed != true) return;

    await ref.read(authProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final readingTheme = ref.watch(themeProvider);
    final auth = ref.watch(authProvider);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final disabled = auth.busy || _savingTheme || _logoutDialogOpen;

    final textScale = MediaQuery.textScalerOf(context).scale(12) / 12;

    final bottomPadding =
        MediaQuery.paddingOf(context).bottom +
        110 +
        (textScale > 1 ? (textScale - 1) * 32 : 0);

    ref.listen(authProvider.select((state) => state.error), (previous, error) {
      if (error != null && error != previous && mounted) {
        context.showMessage(error);
      }
    });

    return PopScope(
      canPop: !auth.busy,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ResponsiveBody(
            maxWidth: 640,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
              children: [
                Text(
                  'MAKE IT YOURS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  AppStrings.settings,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  'A reading experience that feels like you.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),

                _SettingsSection(
                  icon: Icons.palette_outlined,
                  title: AppStrings.appearance,
                  subtitle: AppStrings.themeSubtitle,
                  trailing: _savingTheme ? const OrbitLoader(size: 18) : null,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final largeText =
                          MediaQuery.textScalerOf(context).scale(12) > 18;

                      final columns = constraints.maxWidth < 270 || largeText
                          ? 1
                          : 3;

                      const gap = 8.0;

                      final itemWidth =
                          (constraints.maxWidth - gap * (columns - 1)) /
                          columns;

                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: ReadingTheme.values
                            .map((value) {
                              return SizedBox(
                                width: itemWidth,
                                child: _ThemeOption(
                                  value: value,
                                  selected: readingTheme == value,
                                  disabled: disabled,
                                  onTap: () => _changeTheme(value),
                                ),
                              );
                            })
                            .toList(growable: false),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                _SettingsSection(
                  icon: Icons.person_outline_rounded,
                  title: AppStrings.account,
                  subtitle: 'Your current session',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: colors.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.alternate_email_rounded,
                                size: 18,
                                color: colors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Signed in as',
                                    style: theme.textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    auth.email ?? '—',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: disabled ? null : _confirmLogout,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.error,
                          side: BorderSide(
                            color: colors.error.withValues(alpha: 0.22),
                          ),
                        ),
                        icon: const Icon(Icons.logout_rounded, size: 17),
                        label: const Text(AppStrings.logout),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                const _SettingsSection(
                  icon: Icons.auto_awesome_outlined,
                  title: AppStrings.about,
                  subtitle: 'A wider perspective, every day.',
                  child: _AboutContent(),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 13,
                      color: colors.primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${AppStrings.appName} · ${AppStrings.tagline}',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (auth.busy) ...[
            const Positioned.fill(
              child: ModalBarrier(dismissible: false, color: Colors.black38),
            ),
            Center(
              child: Semantics(
                liveRegion: true,
                label: 'Logging out',
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 22,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const OrbitLoader(size: 36),
                      const SizedBox(height: 12),
                      Text('Logging out…', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.value,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final ReadingTheme value;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  String get _label => switch (value) {
    ReadingTheme.system => AppStrings.system,
    ReadingTheme.light => AppStrings.light,
    ReadingTheme.dark => AppStrings.dark,
  };

  IconData get _icon => switch (value) {
    ReadingTheme.system => Icons.brightness_auto_rounded,
    ReadingTheme.light => Icons.light_mode_rounded,
    ReadingTheme.dark => Icons.dark_mode_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 240);

    return Semantics(
      button: true,
      selected: selected,
      enabled: !disabled,
      label: '$_label theme',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: disabled || selected ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeInOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? colors.primary.withValues(alpha: 0.08)
                  : colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? colors.primary.withValues(alpha: 0.65)
                    : colors.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: selected ? 1 : 0,
                  ),
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  builder: (context, progress, child) {
                    return Transform.translate(
                      offset: Offset(0, -2 * progress),
                      child: Transform.scale(
                        scale: 1 + 0.08 * progress,
                        child: child,
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: duration,
                    curve: Curves.easeInOutCubic,
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: selected
                          ? colors.primary
                          : colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      _icon,
                      size: 17,
                      color: selected
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: Curves.easeInOutCubic,
                  style: (theme.textTheme.labelMedium ??
                      const TextStyle(fontSize: 11))
                      .copyWith(
                    color: selected
                        ? colors.primary
                        : colors.onSurfaceVariant,
                    fontWeight:
                    selected ? FontWeight.w800 : FontWeight.w500,
                  ),
                  child: Text(
                    _label,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOutCubic,
                  width: selected ? 18 : 5,
                  height: 4,
                  decoration: BoxDecoration(
                    color: selected
                        ? colors.primary
                        : colors.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.aboutBody,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.65),
        ),
        const SizedBox(height: 12),
        Divider(
          height: 1,
          color: colors.outlineVariant.withValues(alpha: 0.45),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 14,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                AppStrings.sourceCredit,
                style: theme.textTheme.labelSmall?.copyWith(height: 1.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
