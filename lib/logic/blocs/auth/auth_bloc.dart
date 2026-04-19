import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/get_auth_status_use_case.dart';
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
    this._login,
    this._register,
    this._logout,
  ) : super(const AuthState()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);

    add(AuthStatusChanged());
  }

  Future<void> _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    final status = await _getAuthStatus.execute();
    if (status == AuthStatus.authenticated) {
      emit(state.copyWith(
          status: AuthStatus.authenticated, isLoading: false, error: null));
    } else {
      emit(state.copyWith(
          status: AuthStatus.unauthenticated, isLoading: false, error: null));
    }
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
