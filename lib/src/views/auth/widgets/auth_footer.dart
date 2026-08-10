import 'package:flutter/material.dart';
import '../../../../const/app_colors.dart';

class AuthFooterWidget extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback onActionTap;

  const AuthFooterWidget({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(questionText, style: const TextStyle(color: Colors.grey)),
        TextButton(
          onPressed: onActionTap,
          child: Text(
            actionText,
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
