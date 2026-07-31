abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again later.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network settings.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load cached data from local storage.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed or session expired.']);
}
