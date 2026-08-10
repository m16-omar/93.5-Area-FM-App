import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_model.dart';
import '../services/storage_service.dart';

class SettingsNotifier extends Notifier<SettingsModel> {
  @override
  SettingsModel build() {
    return SettingsModel(isDarkMode: StorageService.getThemeMode());
  }

  void toggleTheme(bool isDark) {
    StorageService.saveThemeMode(isDark);
    state = state.copyWith(isDarkMode: isDark);
  }

  void toggleNotifications(bool enabled) {
    state = state.copyWith(pushNotifications: enabled);
  }

  void toggleAutoPlay(bool enabled) {
    state = state.copyWith(autoPlayStream: enabled);
  }

  void setAudioQuality(String quality) {
    state = state.copyWith(audioQuality: quality);
  }
}

final settingsNotifierProvider = NotifierProvider<SettingsNotifier, SettingsModel>(SettingsNotifier.new);

final themeModeProvider = Provider<bool>((ref) {
  return ref.watch(settingsNotifierProvider).isDarkMode;
});
