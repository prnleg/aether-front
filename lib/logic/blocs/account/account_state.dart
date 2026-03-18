import 'package:equatable/equatable.dart';
import '../../../domain/models/user_model.dart';

abstract class AccountState extends Equatable {
  const AccountState();
  
  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final UserModel user;

  const AccountLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object?> get props => [message];
}
