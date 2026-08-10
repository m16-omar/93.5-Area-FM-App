class SettingsModel {
  final bool isDarkMode;
  final bool pushNotifications;
  final bool autoPlayStream;
  final String audioQuality;

  const SettingsModel({
    this.isDarkMode = false,
    this.pushNotifications = true,
    this.autoPlayStream = true,
    this.audioQuality = 'HD (320kbps)',
  });

  SettingsModel copyWith({
    bool? isDarkMode,
    bool? pushNotifications,
    bool? autoPlayStream,
    String? audioQuality,
  }) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      autoPlayStream: autoPlayStream ?? this.autoPlayStream,
      audioQuality: audioQuality ?? this.audioQuality,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      isDarkMode: json['isDarkMode'] ?? false,
      pushNotifications: json['pushNotifications'] ?? true,
      autoPlayStream: json['autoPlayStream'] ?? true,
      audioQuality: json['audioQuality'] ?? 'HD (320kbps)',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'pushNotifications': pushNotifications,
      'autoPlayStream': autoPlayStream,
      'audioQuality': audioQuality,
    };
  }
}
