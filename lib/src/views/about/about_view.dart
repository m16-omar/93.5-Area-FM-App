import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../../const/app_constants.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../routes/route_names.dart';
import '../../services/share_service.dart';

class AboutView extends ConsumerWidget {
  const AboutView({super.key});

  Future<void> _launchExternalUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardBg = isDark ? const Color(0xFF0B1B22) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AreaFMAppBar(
        title: 'About 93.5 AREA FM',
        showBack: true,
        foregroundColor: primaryTextColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Brand Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF085264),
                    Color(0xFF0B6B82),
                    Color(0xFF0E3846),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF085264).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    AppAssets.logo,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '93.5 AREA FM',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Tagline Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'ONE VOICE, EVERY AREA',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Frequency & Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00E676),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '93.5 MHz • LAGOS, NIGERIA',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Station Story
            Text(
              'OUR STORY',
              style: GoogleFonts.inter(
                color: isDark ? const Color(0xFF00A3FF) : const Color(0xFF0B6B82),
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to 93.5 AREA FM',
                    style: GoogleFonts.poppins(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '93.5 AREA FM is Nigeria\'s premier urban contemporary radio station, broadcasting hit music, authentic news, engaging talk shows, and culture straight from the vibrant heart of Lagos.\n\nFrom the streets to the executive offices, our mission is to unite every community through the power of sound, storytelling, and non-stop entertainment — staying true to our promise: One Voice, Every Area.',
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white70 : const Color(0xFF374151),
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Station Pillars Grid
            Text(
              'WHAT WE STAND FOR',
              style: GoogleFonts.inter(
                color: isDark ? const Color(0xFF00A3FF) : const Color(0xFF0B6B82),
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PillarCard(
                    isDark: isDark,
                    icon: Icons.music_note_rounded,
                    iconColor: AppColors.primary,
                    title: 'Hit Music',
                    description: 'Afrobeats, Hip-hop, Amapiano & Global hits non-stop.',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PillarCard(
                    isDark: isDark,
                    icon: Icons.newspaper_rounded,
                    iconColor: const Color(0xFF00A3FF),
                    title: 'Real News',
                    description: 'Timely, unbiased news bulletins and investigative reports.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PillarCard(
                    isDark: isDark,
                    icon: Icons.mic_external_on_rounded,
                    iconColor: const Color(0xFF00E676),
                    title: 'Street Pulse',
                    description: 'Authentic conversations reflecting real community voices.',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PillarCard(
                    isDark: isDark,
                    icon: Icons.podcasts_rounded,
                    iconColor: const Color(0xFFFF9100),
                    title: 'Top Podcasts',
                    description: 'Exclusive on-demand audio series and interviews.',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 4. Station Facts & Specifications
            Text(
              'BROADCAST SPECIFICATIONS',
              style: GoogleFonts.inter(
                color: isDark ? const Color(0xFF00A3FF) : const Color(0xFF0B6B82),
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cardBorder),
              ),
              child: Column(
                children: [
                  _SpecRow(isDark: isDark, label: 'Frequency', value: '93.5 MHz FM'),
                  Divider(color: cardBorder, height: 16),
                  _SpecRow(isDark: isDark, label: 'Broadcast City', value: 'Lagos, Nigeria'),
                  Divider(color: cardBorder, height: 16),
                  _SpecRow(isDark: isDark, label: 'Station Format', value: 'Urban Contemporary / Hit Radio'),
                  Divider(color: cardBorder, height: 16),
                  _SpecRow(isDark: isDark, label: 'Language', value: 'English, Pidgin & Street Lingua'),
                  Divider(color: cardBorder, height: 16),
                  _SpecRow(isDark: isDark, label: 'Digital Streaming', value: '24/7 Global Ultra HD Stream'),
                  Divider(color: cardBorder, height: 16),
                  _SpecRow(isDark: isDark, label: 'App Version', value: 'v1.2.0 (Build 108)'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. Interactive Navigation & Actions
            Text(
              'EXPLORE & CONNECT',
              style: GoogleFonts.inter(
                color: isDark ? const Color(0xFF00A3FF) : const Color(0xFF0B6B82),
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cardBorder),
              ),
              child: Column(
                children: [
                  _ActionTile(
                    isDark: isDark,
                    icon: Icons.people_outline_rounded,
                    iconColor: const Color(0xFF0B6B82),
                    title: 'Meet Our On-Air Presenters',
                    subtitle: 'Discover the voices behind your favorite shows',
                    onTap: () => context.push(RouteNames.presenters),
                  ),
                  Divider(color: cardBorder, height: 1),
                  _ActionTile(
                    isDark: isDark,
                    icon: Icons.language_rounded,
                    iconColor: const Color(0xFF00A3FF),
                    title: 'Visit Official Website',
                    subtitle: 'areafm.ng',
                    onTap: () => _launchExternalUrl('https://areafm.ng'),
                  ),
                  Divider(color: cardBorder, height: 1),
                  _ActionTile(
                    isDark: isDark,
                    icon: Icons.phone_in_talk_rounded,
                    iconColor: const Color(0xFF00E676),
                    title: 'Studio Hotline & Shoutouts',
                    subtitle: AppConstants.studioLine,
                    onTap: () => _launchExternalUrl('tel:${AppConstants.studioLine}'),
                  ),
                  Divider(color: cardBorder, height: 1),
                  _ActionTile(
                    isDark: isDark,
                    icon: Icons.mail_outline_rounded,
                    iconColor: AppColors.primary,
                    title: 'Contact & Advertising',
                    subtitle: AppConstants.contactEmail,
                    onTap: () => context.push(RouteNames.contact),
                  ),
                  Divider(color: cardBorder, height: 1),
                  _ActionTile(
                    isDark: isDark,
                    icon: Icons.share_rounded,
                    iconColor: const Color(0xFFFF9100),
                    title: 'Share 93.5 AREA FM App',
                    subtitle: 'Spread the word with family & friends',
                    onTap: () => ShareService.shareContent(
                      'Listen to 93.5 AREA FM - One Voice, Every Area! Download our mobile app now: https://areafm.ng/app',
                      subject: '93.5 AREA FM App',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 6. Social Channels
            Center(
              child: Text(
                'FOLLOW US EVERYWHERE',
                style: GoogleFonts.inter(
                  color: secondaryTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialCircleButton(
                  icon: Icons.camera_alt_outlined,
                  color: const Color(0xFFE1306C),
                  onTap: () => _launchExternalUrl(AppConstants.instagramUrl),
                ),
                const SizedBox(width: 16),
                _SocialCircleButton(
                  icon: Icons.alternate_email_rounded,
                  color: const Color(0xFF1DA1F2),
                  onTap: () => _launchExternalUrl(AppConstants.twitterUrl),
                ),
                const SizedBox(width: 16),
                _SocialCircleButton(
                  icon: Icons.facebook_rounded,
                  color: const Color(0xFF1877F2),
                  onTap: () => _launchExternalUrl(AppConstants.facebookUrl),
                ),
                const SizedBox(width: 16),
                _SocialCircleButton(
                  icon: Icons.play_arrow_rounded,
                  color: const Color(0xFFFF0000),
                  onTap: () => _launchExternalUrl(AppConstants.youtubeUrl),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // 7. Footer Copyright
            Center(
              child: Column(
                children: [
                  Text(
                    '© 2026 93.5 AREA FM. All Rights Reserved.',
                    style: GoogleFonts.inter(
                      color: secondaryTextColor,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lagos, Nigeria • Streamed Globally',
                    style: GoogleFonts.inter(
                      color: secondaryTextColor.withValues(alpha: 0.7),
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _PillarCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.inter(
              color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;

  const _SpecRow({
    required this.isDark,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
              fontSize: 12.5,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
          fontSize: 11.5,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
        size: 20,
      ),
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialCircleButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
