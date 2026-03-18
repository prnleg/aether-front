import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<UserModel> getUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const UserModel(
      id: 'user_123',
      name: 'John Doe',
      email: 'john.doe@example.com',
    );
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
