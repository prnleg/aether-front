import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final Map<String, String> _inMemoryStorage = {};
  static const _tokenKey = 'auth_token';

  MockAuthRepository();

  @override
  Future<AuthStatus> getAuthStatus() async {
    final token = _inMemoryStorage[_tokenKey];
    return token != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulating a successful login
    const user = UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
    );
    
    _inMemoryStorage[_tokenKey] = 'mock_jwt_token';
    return user;
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    const user = UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
    );
    _inMemoryStorage[_tokenKey] = 'mock_jwt_token';
    return user;
  }

  @override
  Future<void> logout() async {
    _inMemoryStorage.remove(_tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return _inMemoryStorage[_tokenKey];
  }

  @override
  String? getCachedName() => null;
}
