import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  MockAuthRepository(this._storage);

  @override
  Future<AuthStatus> getAuthStatus() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulating a successful login
    const user = UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
    );
    
    await _storage.write(key: _tokenKey, value: 'mock_jwt_token');
    return user;
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    const user = UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
    );
    await _storage.write(key: _tokenKey, value: 'mock_jwt_token');
    return user;
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
}
