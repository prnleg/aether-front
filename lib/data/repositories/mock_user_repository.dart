import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<UserModel> getUser() async {
    return const UserModel(
      id: 'user_123',
      name: 'John Doe',
      email: 'john.doe@example.com',
    );
  }

  @override
  Future<void> updateUser(UserModel user) async {}

  @override
  Future<void> updateSteamId(String steamId) async {}
}
