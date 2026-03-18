import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser();
  Future<void> updateUser(UserModel user);
}
