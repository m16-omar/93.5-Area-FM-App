class AppConstants {
  static const String appName = 'Area 93.5 FM';
  static const String appFrequency = '93.5 FM';
  static const String appTagline = 'The Voice of the City • 24/7 Live Stream';
  
  // API & Web Endpoints (Django REST Framework)
  static const String apiBaseUrl = 'https://area-93-5-fm-web.vercel.app/api/v1';
  static const String webUrl = 'https://area-93-5-fm-web.vercel.app';
  static const String facebookUrl = 'https://facebook.com/areafm935';
  static const String twitterUrl = 'https://twitter.com/areafm935';
  static const String instagramUrl = 'https://instagram.com/areafm935';
  
  // Audio Live Stream URLs
  static const String defaultStreamUrl = 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=lofi-study-112191.mp3';
  static const String hdStreamUrl = 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=lofi-study-112191.mp3';
  static const String fallbackStreamUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  // Contact Info
  static const String studioPhone = '+234 800 935 AREA';
  static const String whatsappNumber = '+2348009352732';
  static const String studioEmail = 'studio@areafm.com';

  // Hive Box Keys
  static const String favoritesBox = 'favorites_box';
  static const String cacheBox = 'cache_box';
  static const String settingsBox = 'settings_box';
  static const String historyBox = 'history_box';
}
