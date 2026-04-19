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

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        profilePictureUrl: json['profilePictureUrl'] as String? ?? '',
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
