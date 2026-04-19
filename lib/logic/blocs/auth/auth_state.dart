import 'package:equatable/equatable.dart';
import '../../../domain/models/user_model.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isResumingSession;
  final String? resumingName;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isLoading = false,
    this.error,
    this.isResumingSession = false,
    this.resumingName,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isResumingSession,
    String? resumingName,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isResumingSession: isResumingSession ?? this.isResumingSession,
      resumingName: resumingName ?? this.resumingName,
    );
  }

  @override
  List<Object?> get props => [status, user, isLoading, error, isResumingSession, resumingName];
}
