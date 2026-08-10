import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String toFormattedString([String format = 'MMM dd, yyyy']) {
    return DateFormat(format).format(this);
  }

  String toTimeString() {
    return DateFormat('hh:mm a').format(this);
  }

  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 7) {
      return toFormattedString();
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
