import 'package:flutter/material.dart';

class ThemeIcon extends StatelessWidget {
  const ThemeIcon({super.key, required this.onThemeToggle});

  final VoidCallback onThemeToggle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      padding: EdgeInsets.symmetric(horizontal: 4),
      tooltip: isDark ? 'تفعيل الوضع الفاتح' : 'تفعيل الوضع الداكن',
      onPressed: onThemeToggle,
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
    );
  }
}
