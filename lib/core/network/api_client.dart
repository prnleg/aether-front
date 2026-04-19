import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../exceptions/app_exception.dart';
import 'auth_interceptor.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(AuthInterceptor authInterceptor)
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(authInterceptor);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException('Could not reach the server. Check your connection.');
    }

    final statusCode = e.response?.statusCode;
    final message = _extractMessage(e.response?.data) ?? e.message ?? 'Unknown error';

    switch (statusCode) {
      case 401:
        return AuthException(message);
      case 404:
        return NotFoundException(message);
      case 422:
      case 400:
        return ValidationException(message);
      default:
        return UnknownException(message);
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      return (data['message'] ?? data['error'] ?? data['title'])?.toString();
    }
    return null;
  }
}
