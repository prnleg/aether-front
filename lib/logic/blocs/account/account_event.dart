import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class AccountStarted extends AccountEvent {}

class UpdateProfile extends AccountEvent {
  final String? name;
  final String? email;

  const UpdateProfile({this.name, this.email});

  @override
  List<Object> get props => [name ?? '', email ?? ''];
}

class UpdateSteamId extends AccountEvent {
  final String steamId;

  const UpdateSteamId(this.steamId);

  @override
  List<Object> get props => [steamId];
}
