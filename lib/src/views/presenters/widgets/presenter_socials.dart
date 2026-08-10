import 'package:flutter/material.dart';
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
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.purple),
            onPressed: () => UrlHelper.launchURL(instagram),
          ),
        if (twitter.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.flutter_dash_outlined, color: Colors.lightBlue),
            onPressed: () => UrlHelper.launchURL(twitter),
          ),
        if (facebook.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.facebook_outlined, color: Colors.blue),
            onPressed: () => UrlHelper.launchURL(facebook),
          ),
      ],
    );
  }
}
