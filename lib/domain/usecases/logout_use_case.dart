import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);
  Future<void> execute() => _repository.logout();
}
