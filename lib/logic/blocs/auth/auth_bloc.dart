import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/get_auth_status_use_case.dart';
import '../../../domain/usecases/get_cached_name_use_case.dart';
import '../../../domain/usecases/login_use_case.dart';
import '../../../domain/usecases/logout_use_case.dart';
import '../../../domain/usecases/register_use_case.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAuthStatusUseCase _getAuthStatus;
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final LogoutUseCase _logout;

  AuthBloc(
    this._getAuthStatus,
    GetCachedNameUseCase getCachedName,
    this._login,
    this._register,
    this._logout,
  ) : super(_buildInitialState(getCachedName)) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CancelResuming>(_onCancelResuming);

    add(AuthStatusChanged());
  }

  static AuthState _buildInitialState(GetCachedNameUseCase getCachedName) {
    final name = getCachedName.execute();
    return AuthState(
      isResumingSession: name != null && name.isNotEmpty,
      resumingName: name,
    );
  }

  Future<void> _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    final status = await _getAuthStatus.execute();
    emit(state.copyWith(
      status: status,
      isResumingSession: false,
      isLoading: false,
      error: null,
    ));
  }

  Future<void> _onCancelResuming(
    CancelResuming event,
    Emitter<AuthState> emit,
  ) async {
    await _logout.execute();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _login.execute(event.email, event.password);
      add(AuthStatusChanged());
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          isLoading: false,
          error: 'Login failed. Please check your credentials.'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _register.execute(event.name, event.email, event.password);
      add(AuthStatusChanged());
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          isLoading: false, error: 'Registration failed. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout.execute();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
