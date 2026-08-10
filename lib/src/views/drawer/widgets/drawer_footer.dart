import 'package:flutter/material.dart';

class DrawerFooterWidget extends StatelessWidget {
  const DrawerFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Version 1.0.0+1 • 93.5 Area FM',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[500], fontSize: 11),
      ),
    );
  }
}
