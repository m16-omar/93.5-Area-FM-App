import 'package:flutter/material.dart';
import '../../const/app_colors.dart';

class SnackbarHelper {
  SnackbarHelper._();

  static void showSuccess(BuildContext context, String message) {
    _show(context, message: message, backgroundColor: AppColors.success, icon: Icons.check_circle_outline);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message: message, backgroundColor: AppColors.error, icon: Icons.error_outline);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message: message, backgroundColor: AppColors.info, icon: Icons.info_outline);
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
