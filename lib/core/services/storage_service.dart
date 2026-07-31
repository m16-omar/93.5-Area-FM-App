import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class StorageService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(AppConstants.favoritesBox);
    await Hive.openBox(AppConstants.cacheBox);
    await Hive.openBox(AppConstants.settingsBox);
    await Hive.openBox(AppConstants.historyBox);
  }

  static Box get settingsBox => Hive.box(AppConstants.settingsBox);
  static Box get favoritesBox => Hive.box(AppConstants.favoritesBox);
  static Box get cacheBox => Hive.box(AppConstants.cacheBox);
  static Box get historyBox => Hive.box(AppConstants.historyBox);

  static bool isDarkMode() => settingsBox.get('isDarkMode', defaultValue: true);
  static Future<void> setDarkMode(bool val) => settingsBox.put('isDarkMode', val);

  static String getStreamQuality() => settingsBox.get('streamQuality', defaultValue: 'HD (320kbps)');
  static Future<void> setStreamQuality(String val) => settingsBox.put('streamQuality', val);

  static List<String> getFavorites() => List<String>.from(favoritesBox.get('ids', defaultValue: <String>[]));
  static Future<void> toggleFavorite(String id) async {
    final list = getFavorites();
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    await favoritesBox.put('ids', list);
  }
}
