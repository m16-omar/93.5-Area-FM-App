import 'package:flutter/material.dart';
import '../../../../common/components/show_card.dart';
import '../../../models/show_model.dart';

class ShowCardWidget extends StatelessWidget {
  final ShowModel show;
  final VoidCallback onTap;

  const ShowCardWidget({
    super.key,
    required this.show,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ShowCard(show: show, onTap: onTap);
  }
}
