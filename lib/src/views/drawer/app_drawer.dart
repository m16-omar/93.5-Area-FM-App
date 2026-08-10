import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/drawer_header.dart';
import 'widgets/drawer_item.dart';
import 'widgets/drawer_footer.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeaderWidget(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerItemWidget(
                  icon: Icons.home_rounded,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/home');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.radio_rounded,
                  title: 'Live Radio',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/radio_player');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.mic_rounded,
                  title: 'Shows & Schedule',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/shows');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.podcasts_rounded,
                  title: 'Podcasts',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/podcasts');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.newspaper_rounded,
                  title: 'News & Blog',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/blog');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.leaderboard_rounded,
                  title: 'Top 10 Music Charts',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/charts');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.event_rounded,
                  title: 'Station Events',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/events');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.people_outline_rounded,
                  title: 'Presenters',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/presenters');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.video_library_rounded,
                  title: 'Videos',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/videos');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.campaign_rounded,
                  title: 'Advertise / Promote',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/promote');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.contact_support_rounded,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/contact');
                  },
                ),
                DrawerItemWidget(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
              ],
            ),
          ),
          const DrawerFooterWidget(),
        ],
      ),
    );
  }
}
