import 'package:flutter/foundation.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_dto.dart';
import '../../core/network/api_client.dart';
import '../../core/services/token_storage.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiClient _api;
  final TokenStorage _tokenStorage;

  UserRepositoryImpl(this._api, this._tokenStorage);

  @override
  Future<UserModel> getUser() async {
    try {
      final response = await _api.get('/api/auth/me');
      final user = UserDto.fromJson(response.data as Map<String, dynamic>).toDomain();
      // Keep local cache in sync.
      await _tokenStorage.writeName(user.name);
      await _tokenStorage.writeEmail(user.email);
      return user;
    } catch (e) {
      debugPrint('UserRepositoryImpl.getUser: $e');
      // Fall back to locally stored credentials so AccountPage isn't blank
      // while /api/auth/me is being implemented.
      final userId = _tokenStorage.readUserId() ?? '';
      final name = _tokenStorage.readName() ?? '';
      final email = _tokenStorage.readEmail() ?? '';
      if (userId.isEmpty) rethrow;
      return UserModel(id: userId, name: name, email: email);
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    // TODO: add PATCH /api/users/me endpoint to backend.
    await _tokenStorage.writeName(user.name);
    await _tokenStorage.writeEmail(user.email);
  }

  @override
  Future<void> updateSteamId(String steamId) async {
    await _api.patch('/api/users/me/steam-id', data: {'steamId': steamId});
  }
}
