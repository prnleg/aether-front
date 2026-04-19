import '../repositories/auth_repository.dart';

class GetAuthStatusUseCase {
  final AuthRepository _repository;
  const GetAuthStatusUseCase(this._repository);
  Future<AuthStatus> execute() => _repository.getAuthStatus();
}
