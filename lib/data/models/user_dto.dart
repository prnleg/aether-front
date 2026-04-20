import '../../domain/models/user_model.dart';

class UserDto {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;
  final String? steamId;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl = '',
    this.steamId,
  });

  /// Handles both camelCase (Flutter convention) and PascalCase (.NET default).
  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: (json['id'] ?? json['Id'] ?? '') as String,
        name: (json['name'] ?? json['Name'] ?? '') as String,
        email: (json['email'] ?? json['Email'] ?? '') as String,
        profilePictureUrl:
            (json['profilePictureUrl'] ?? json['ProfilePictureUrl'] ?? '') as String,
        steamId: (json['steamId'] ?? json['SteamId']) as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profilePictureUrl': profilePictureUrl,
        'steamId': steamId,
      };

  UserModel toDomain() => UserModel(
        id: id,
        name: name,
        email: email,
        profilePictureUrl: profilePictureUrl,
        steamId: steamId,
      );
}
