import 'package:flutter/material.dart';

import '../../core/constants/app_tokens.dart';
import 'app_button.dart';
import 'app_text.dart';

class StatePanel extends StatelessWidget {
  const StatePanel({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String message;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacing.lg),
            AppText(
              title,
              variant: AppTextStyle.title,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              message,
              variant: AppTextStyle.small,
              align: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: action!, onPressed: onAction),
            ],
          ],
        ),
      ),
    ),
  );
}
