import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository _repository;
  const UpdateUserUseCase(this._repository);
  Future<void> execute(UserModel user) => _repository.updateUser(user);
}
