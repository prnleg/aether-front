import 'package:flutter/foundation.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response_dto.dart';
import '../models/user_dto.dart';
import '../../core/network/api_client.dart';
import '../../core/services/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _api;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._api, this._tokenStorage);

  @override
  Future<AuthStatus> getAuthStatus() async {
    final token = _tokenStorage.readToken();
    if (token == null) return AuthStatus.unauthenticated;

    // If /api/auth/me is ready, use it to validate the token.
    // Until then, treat a stored token as authenticated.
    try {
      await _api.get('/api/auth/me');
      return AuthStatus.authenticated;
    } catch (e) {
      debugPrint('getAuthStatus /auth/me: $e');
      // Token exists but endpoint not ready — stay authenticated so the user
      // doesn't get logged out every cold start. Remove this fallback once
      // /api/auth/me is implemented.
      return AuthStatus.authenticated;
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _api.post(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );

    final dto = AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
    await _tokenStorage.writeToken(dto.token);
    await _tokenStorage.writeUserId(dto.userId);
    await _tokenStorage.writeEmail(dto.email);
    await _tokenStorage.writePortfolioId(dto.portfolioId);

    return _fetchMeOrFallback(userId: dto.userId, email: dto.email);
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final response = await _api.post(
      '/api/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );

    final dto = AuthResponseDto.fromJson(response.data as Map<String, dynamic>);
    await _tokenStorage.writeToken(dto.token);
    await _tokenStorage.writeUserId(dto.userId);
    await _tokenStorage.writeEmail(dto.email);
    await _tokenStorage.writePortfolioId(dto.portfolioId);
    await _tokenStorage.writeName(name); // persist the name the user just typed

    return _fetchMeOrFallback(userId: dto.userId, email: dto.email, name: name);
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.deleteAll();
  }

  @override
  Future<String?> getToken() async => _tokenStorage.readToken();

  @override
  String? getCachedName() => _tokenStorage.readName();

  Future<UserModel> _fetchMeOrFallback({
    required String userId,
    required String email,
    String? name,
  }) async {
    try {
      final response = await _api.get('/api/auth/me');
      final user = UserDto.fromJson(response.data as Map<String, dynamic>).toDomain();
      // Cache the name so UserRepositoryImpl can serve it offline too.
      await _tokenStorage.writeName(user.name);
      return user;
    } catch (e) {
      debugPrint('_fetchMe failed (endpoint not ready?): $e');
      return UserModel(id: userId, name: name ?? '', email: email);
    }
  }
}
