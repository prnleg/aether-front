import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;
  final String? steamId;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl = '',
    this.steamId,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? profilePictureUrl,
    String? steamId,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      steamId: steamId ?? this.steamId,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        profilePictureUrl: json['profilePictureUrl'] as String? ?? '',
        steamId: json['steamId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profilePictureUrl': profilePictureUrl,
        'steamId': steamId,
      };

  @override
  List<Object?> get props => [id, name, email, profilePictureUrl, steamId];
}
