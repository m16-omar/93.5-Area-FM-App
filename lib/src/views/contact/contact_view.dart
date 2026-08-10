import 'package:flutter/material.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/helpers/url_helper.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_constants.dart';
import 'widgets/contact_form.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AreaFMAppBar(title: 'Contact Us', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get In Touch With The Studio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Send us your feedback, music requests, or call our direct studio line.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildContactTile(
                    context,
                    icon: Icons.phone_in_talk_rounded,
                    title: 'Studio Line',
                    subtitle: AppConstants.studioLine,
                    onTap: () => UrlHelper.launchPhone(AppConstants.studioLine),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildContactTile(
                    context,
                    icon: Icons.email_rounded,
                    title: 'Email Us',
                    subtitle: AppConstants.contactEmail,
                    onTap: () => UrlHelper.launchEmail(AppConstants.contactEmail),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const ContactFormWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
