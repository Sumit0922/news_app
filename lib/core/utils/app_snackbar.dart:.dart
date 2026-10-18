import 'package:flutter/material.dart';

final appMessengerKey = GlobalKey<ScaffoldMessengerState>();

void showAppSnackbar(String message) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final messenger = appMessengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  });
}
