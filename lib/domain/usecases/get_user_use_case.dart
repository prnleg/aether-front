import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository _repository;
  const GetUserUseCase(this._repository);
  Future<UserModel> execute() => _repository.getUser();
}
