import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);
  Future<UserModel> execute(String email, String password) =>
      _repository.login(email, password);
}
