import 'dart:async';

import 'package:flutter/material.dart';

import '../core/errors/failure_message.dart';

class StatePanel extends StatefulWidget {
  const StatePanel({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.onAction,
    this.secondaryAction,
    this.onSecondaryAction,
  });

  final IconData icon;
  final String title;
  final String message;

  final String? action;
  final FutureOr<void> Function()? onAction;

  final String? secondaryAction;
  final VoidCallback? onSecondaryAction;

  @override
  State<StatePanel> createState() => _StatePanelState();
}

class _StatePanelState extends State<StatePanel> {
  bool _busy = false;
  bool _coolingDown = false;

  Timer? _cooldown;

  Future<void> _runAction() async {
    if (_busy || _coolingDown || widget.onAction == null) {
      return;
    }

    setState(() => _busy = true);

    try {
      await widget.onAction!.call();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)
            ?.showSnackBar(SnackBar(content: Text(failureMessage(error))));
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _coolingDown = true;
        });

        _cooldown?.cancel();

        _cooldown = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _coolingDown = false);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _cooldown?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.13),
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.primaryContainer,
                        colors.primaryContainer.withValues(alpha: 0.35),
                      ],
                    ),
                  ),
                  child: Icon(widget.icon, size: 27, color: colors.primary),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
              if (widget.action != null) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _busy || _coolingDown || widget.onAction == null
                      ? null
                      : _runAction,
                  icon: _busy
                      ? SizedBox.square(
                          dimension: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.8,
                            color: colors.onSurfaceVariant,
                          ),
                        )
                      : const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(
                    _busy
                        ? 'Updating…'
                        : _coolingDown
                        ? 'Please wait'
                        : widget.action!,
                  ),
                ),
              ],
              if (widget.secondaryAction != null) ...[
                const SizedBox(height: 4),
                TextButton(
                  onPressed: _busy ? null : widget.onSecondaryAction,
                  child: Text(widget.secondaryAction!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
