class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.935areafm.com/v1';
  static const String liveStreamUrl = 'https://stream.zeno.fm/f3wvbbqmdg8uv';
  static const String podcastsEndpoint = '/podcasts';
  static const String showsEndpoint = '/shows';
  static const String newsEndpoint = '/news';
  static const String eventsEndpoint = '/events';
  static const String chartsEndpoint = '/charts';
  static const String presentersEndpoint = '/presenters';
  static const String contactEndpoint = '/contact';
  static const String promoteEndpoint = '/promote';
  static const String authEndpoint = '/auth';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
