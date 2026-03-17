import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl = '',
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? profilePictureUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, email, profilePictureUrl];
}
