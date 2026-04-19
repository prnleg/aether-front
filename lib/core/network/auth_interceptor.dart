import 'package:dio/dio.dart';
import '../services/token_storage.dart';

/// Reads the stored JWT on every request and injects the Authorization header.
/// Skips auth routes so login/register never send a stale token.
class AuthInterceptor extends Interceptor {
  static const _skipPaths = ['/api/auth/login', '/api/auth/register'];

  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final shouldSkip = _skipPaths.any((p) => options.path.contains(p));
    if (!shouldSkip) {
      final token = _tokenStorage.readToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
