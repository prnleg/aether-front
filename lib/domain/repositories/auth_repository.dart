import '../models/user_model.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

abstract class AuthRepository {
  Future<AuthStatus> getAuthStatus();
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> logout();
  Future<String?> getToken();
}
