import 'package:hive_flutter/hive_flutter.dart';

/// Stores auth tokens in a Hive box.
/// Works on all platforms without requiring Keychain entitlements.
/// For production iOS/Android, replace the Hive box with FlutterSecureStorage.
class TokenStorage {
  static const _boxName = 'auth_tokens';
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  static const _nameKey = 'user_name';
  static const _emailKey = 'user_email';
  static const _portfolioIdKey = 'portfolio_id';

  Future<void> writeToken(String token) => _box.put(_tokenKey, token);
  Future<void> writeUserId(String userId) => _box.put(_userIdKey, userId);
  Future<void> writeName(String name) => _box.put(_nameKey, name);
  Future<void> writeEmail(String email) => _box.put(_emailKey, email);
  Future<void> writePortfolioId(String portfolioId) => _box.put(_portfolioIdKey, portfolioId);

  String? readToken() => _box.get(_tokenKey) as String?;
  String? readUserId() => _box.get(_userIdKey) as String?;
  String? readName() => _box.get(_nameKey) as String?;
  String? readEmail() => _box.get(_emailKey) as String?;
  String? readPortfolioId() => _box.get(_portfolioIdKey) as String?;

  Future<void> deleteAll() async {
    await _box.delete(_tokenKey);
    await _box.delete(_userIdKey);
    await _box.delete(_nameKey);
    await _box.delete(_emailKey);
    await _box.delete(_portfolioIdKey);
  }
}
