import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState()) {
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
    final status = await _authRepository.getAuthStatus();
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
      await _authRepository.login(event.email, event.password);
      add(AuthStatusChanged());
    } catch (e) {
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
      await _authRepository.register(event.name, event.email, event.password);
      add(AuthStatusChanged());
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, error: 'Registration failed. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
