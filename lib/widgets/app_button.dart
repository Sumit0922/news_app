import 'package:flutter/material.dart';
import '../../core/constants/app_tokens.dart';
import 'orbit_loader.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (busy)
          const OrbitLoader(size: 22)
        else if (icon != null)
          Icon(icon, size: 20),
        if (busy || icon != null) const SizedBox(width: AppSpacing.sm),
        Flexible(child: Text(label)),
      ],
    ),
  );
}
