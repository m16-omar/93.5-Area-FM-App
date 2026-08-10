import 'package:flutter/material.dart';
import '../../../../common/components/presenter_card.dart';
import '../../../models/presenter_model.dart';

class PresenterCardWidget extends StatelessWidget {
  final PresenterModel presenter;
  final VoidCallback onTap;

  const PresenterCardWidget({
    super.key,
    required this.presenter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PresenterCard(presenter: presenter, onTap: onTap);
  }
}
