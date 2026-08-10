import 'package:hive_flutter/hive_flutter.dart';
import '../../const/app_constants.dart';

class StorageService {
  StorageService._();

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(AppConstants.hiveBoxSettings);
    await Hive.openBox(AppConstants.hiveBoxAuth);
  }

  static Box get settingsBox => Hive.box(AppConstants.hiveBoxSettings);
  static Box get authBox => Hive.box(AppConstants.hiveBoxAuth);

  static Future<void> saveThemeMode(bool isDark) async {
    await settingsBox.put('isDarkMode', isDark);
  }

  static bool getThemeMode() {
    return settingsBox.get('isDarkMode', defaultValue: false);
  }

  static bool isFirstLaunch() {
    return settingsBox.get('firstLaunchDone', defaultValue: false) == false;
  }

  static Future<void> setFirstLaunchDone() async {
    await settingsBox.put('firstLaunchDone', true);
  }
}
