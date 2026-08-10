import 'package:flutter/material.dart';

class SocialLoginButtonWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialLoginButtonWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
