import '../../domain/models/user_model.dart';

class UserDto {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl = '',
  });

  /// Handles both camelCase (Flutter convention) and PascalCase (.NET default).
  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: (json['id'] ?? json['Id'] ?? '') as String,
        name: (json['name'] ?? json['Name'] ?? '') as String,
        email: (json['email'] ?? json['Email'] ?? '') as String,
        profilePictureUrl:
            (json['profilePictureUrl'] ?? json['ProfilePictureUrl'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profilePictureUrl': profilePictureUrl,
      };

  UserModel toDomain() => UserModel(
        id: id,
        name: name,
        email: email,
        profilePictureUrl: profilePictureUrl,
      );
}
