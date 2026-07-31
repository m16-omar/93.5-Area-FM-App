import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:area_fm_app/core/theme/app_theme.dart';
import 'package:area_fm_app/features/about/presentation/screens/about_screen.dart';

void main() {
  testWidgets('AreaFMApp Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AboutScreen(),
        ),
      ),
    );

    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.text('AREA 93.5 FM'), findsOneWidget);
  });
}
