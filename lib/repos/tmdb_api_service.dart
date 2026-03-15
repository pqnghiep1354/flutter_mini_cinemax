import 'package:dio/dio.dart';
import '../config/app_constants.dart';
import '../config/env_config.dart';

class TmdbApiService {
  static final TmdbApiService _instance = TmdbApiService._internal();
  factory TmdbApiService() => _instance;

  late final Dio _dio;

  TmdbApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.tmdbBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] =
              'Bearer ${EnvConfig.tmdbReadAccessToken}';
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: {
          'language': 'en-US',
          ...?queryParameters,
        },
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['status_message'] ?? 'Unknown error';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled.');
      default:
        return Exception('Network error. Please check your connection.');
    }
  }
}
