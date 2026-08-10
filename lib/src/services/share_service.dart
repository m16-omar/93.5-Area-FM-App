import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareContent(String text, {String? subject}) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }

  static Future<void> shareShow(String showTitle, String airTime) async {
    final text = 'Tune in to "$showTitle" on 93.5 Area FM ($airTime)! Download the app now.';
    await SharePlus.instance.share(ShareParams(text: text, subject: 'Listen to 93.5 Area FM'));
  }

  static Future<void> shareNews(String title, String summary) async {
    final text = 'Read "$title" on 93.5 Area FM News: $summary';
    await SharePlus.instance.share(ShareParams(text: text, subject: title));
  }
}
