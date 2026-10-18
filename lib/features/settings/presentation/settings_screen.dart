import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_news/widgets/app_text.dart';
import 'package:orbit_news/widgets/orbit_loader.dart';
import 'package:orbit_news/widgets/responsive_body.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_tokens.dart';
import '../../../core/errors/failure_message.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/app_responsive.dart';
import '../../auth/presentation/auth_view_model.dart';
import '../domain/preferences_repository.dart';
import 'theme_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final auth = ref.watch(authProvider);

    ref.listen(authProvider.select((state) => state.error), (_, error) {
      if (error != null && context.mounted) {
        context.showMessage(error);
      }
    });

    return PopScope(
      canPop: !auth.busy,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ResponsiveBody(
            maxWidth: 720,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.space(AppSpacing.lg),
                AppResponsive.space(AppSpacing.uz),
                AppResponsive.space(AppSpacing.lg),
                MediaQuery.paddingOf(context).bottom +
                    AppResponsive.space(AppSpacing.lg),
              ),
              children: [
                const AppText(
                  AppStrings.settings,
                  variant: AppTextStyle.heading,
                ),
                SizedBox(height: AppResponsive.space(AppSpacing.md)),
                const AppText(
                  AppStrings.appearance,
                  variant: AppTextStyle.title,
                ),
                const AppText(
                  AppStrings.themeSubtitle,
                  variant: AppTextStyle.small,
                ),
                SizedBox(height: AppResponsive.space(AppSpacing.md)),
                Wrap(
                  spacing: AppResponsive.space(AppSpacing.sm),
                  runSpacing: AppResponsive.space(AppSpacing.sm),
                  children: ReadingTheme.values.map((value) {
                    return ChoiceChip(
                      label: Text(switch (value) {
                        ReadingTheme.light => AppStrings.light,
                        ReadingTheme.dark => AppStrings.dark,
                        ReadingTheme.system => AppStrings.system,
                      }),
                      showCheckmark: false,
                      avatar: Icon(switch (value) {
                        ReadingTheme.light => Icons.light_mode_outlined,
                        ReadingTheme.dark => Icons.dark_mode_outlined,
                        ReadingTheme.system => Icons.brightness_auto_outlined,
                      }, size: AppResponsive.icon(18)),
                      selected: value == theme,
                      onSelected: auth.busy
                          ? null
                          : (_) async {
                              try {
                                await ref
                                    .read(themeProvider.notifier)
                                    .setTheme(value);
                              } catch (error) {
                                if (context.mounted) {
                                  context.showMessage(failureMessage(error));
                                }
                              }
                            },
                    );
                  }).toList(),
                ),
                SizedBox(height: AppResponsive.space(AppSpacing.sm)),
                const Divider(),
                SizedBox(height: AppResponsive.space(AppSpacing.sm)),
                const AppText(AppStrings.account, variant: AppTextStyle.title),
                SizedBox(height: AppResponsive.space(AppSpacing.xs)),
                AppText(auth.email ?? '', variant: AppTextStyle.small),
                SizedBox(height: AppResponsive.space(AppSpacing.sm)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: auth.busy
                        ? null
                        : () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text(AppStrings.logout),
                                  content: const Text(AppStrings.logoutBody),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext, false);
                                      },
                                      child: const Text(AppStrings.cancel),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext, true);
                                      },
                                      child: const Text(AppStrings.logout),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (!context.mounted || confirmed != true) {
                              return;
                            }

                            await ref.read(authProvider.notifier).signOut();
                          },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(AppStrings.logout),
                  ),
                ),
                SizedBox(height: AppResponsive.space(AppSpacing.sm)),
                const Divider(),
                SizedBox(height: AppResponsive.space(AppSpacing.sm)),
                const AppText(AppStrings.about, variant: AppTextStyle.title),
                SizedBox(height: AppResponsive.space(AppSpacing.md)),
                const AppText(
                  AppStrings.aboutBody,
                  variant: AppTextStyle.small,
                ),
                SizedBox(height: AppResponsive.space(AppSpacing.md)),
                const Divider(),
                SizedBox(height: AppResponsive.space(AppSpacing.md)),
                const AppText(
                  AppStrings.sourceCredit,
                  variant: AppTextStyle.caption,
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
                child: Card(
                  margin: EdgeInsets.all(AppResponsive.space(AppSpacing.lg)),
                  child: Padding(
                    padding: EdgeInsets.all(AppResponsive.space(AppSpacing.lg)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 48,
                          height: 48,
                          child: OrbitLoader(size: 48),
                        ),
                        SizedBox(height: AppResponsive.space(AppSpacing.md)),
                        const AppText(
                          'Logging out...',
                          variant: AppTextStyle.small,
                          align: TextAlign.center,
                        ),
                      ],
                    ),
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
