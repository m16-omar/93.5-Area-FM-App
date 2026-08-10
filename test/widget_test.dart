import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:area_fm_app/main.dart';
import 'package:area_fm_app/const/app_constants.dart';

void main() {
  setUpAll(() async {
    Hive.init('./test_hive');
    await Hive.openBox(AppConstants.hiveBoxSettings);
    await Hive.openBox(AppConstants.hiveBoxAuth);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('AreaFMApp Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AreaFMApp(),
      ),
    );

    expect(find.byType(AreaFMApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
