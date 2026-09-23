class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://city1051fm.cloud/api';
  static const String liveStreamUrl = 'https://stream.zeno.fm/f3wvbbqmdg8uv';
  static const String podcastsEndpoint = '/podcasts/';
  static const String showsEndpoint = '/shows/';
  static const String newsEndpoint = '/news/';
  static const String newsCategoriesEndpoint = '/news-categories/';
  static const String eventsEndpoint = '/events/';
  static const String chartsEndpoint = '/charts/';
  static const String presentersEndpoint = '/staff/';
  static const String contactEndpoint = '/service-requests/';
  static const String promoteEndpoint = '/promotions/';
  static const String authEndpoint = '/auth/';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
