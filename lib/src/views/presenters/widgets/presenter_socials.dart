import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../common/helpers/url_helper.dart';

class PresenterSocialsWidget extends StatelessWidget {
  final String instagram;
  final String twitter;
  final String facebook;

  const PresenterSocialsWidget({
    super.key,
    this.instagram = '',
    this.twitter = '',
    this.facebook = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (instagram.isNotEmpty)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.instagram, color: Color(0xFFE1306C), size: 20),
            onPressed: () => UrlHelper.launchURL(instagram),
          ),
        if (twitter.isNotEmpty)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.xTwitter, size: 18),
            onPressed: () => UrlHelper.launchURL(twitter),
          ),
        if (facebook.isNotEmpty)
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.facebookF, color: Color(0xFF1877F2), size: 19),
            onPressed: () => UrlHelper.launchURL(facebook),
          ),
      ],
    );
  }
}
