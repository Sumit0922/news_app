import '../constants/app_strings.dart';

abstract final class Validators {
  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.emailRequired;
    if (text.length > 254 ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(text)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    if (value.trim().isEmpty || value.length < 8 || value.length > 72) {
      return AppStrings.passwordInvalid;
    }
    return null;
  }
}
