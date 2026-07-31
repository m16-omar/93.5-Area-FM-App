import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../errors/failures.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('[DIO REQUEST] ${options.method} -> ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('[DIO RESPONSE] ${response.statusCode} -> ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (kDebugMode) {
            print('[DIO ERROR] ${error.type} -> ${error.message}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Failure handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    if (error.response != null) {
      final code = error.response?.statusCode;
      if (code == 401 || code == 403) {
        return const AuthFailure('Unauthorized access. Please login.');
      }
      return ServerFailure('Server returned status code: $code');
    }
    return const ServerFailure('An unexpected networking error occurred.');
  }
}
