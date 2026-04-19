import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);
  Future<UserModel> execute(String name, String email, String password) =>
      _repository.register(name, email, password);
}
