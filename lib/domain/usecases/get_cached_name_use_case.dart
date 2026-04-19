import '../repositories/auth_repository.dart';

class GetCachedNameUseCase {
  final AuthRepository _repository;
  const GetCachedNameUseCase(this._repository);
  String? execute() => _repository.getCachedName();
}
