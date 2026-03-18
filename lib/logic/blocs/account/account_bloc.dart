import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_event.dart';
import 'account_state.dart';
import '../../../domain/models/user_model.dart';
import '../../../domain/repositories/user_repository.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final UserRepository _userRepository;

  AccountBloc(this._userRepository) : super(AccountInitial()) {
    on<AccountStarted>(_onAccountStarted);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onAccountStarted(
    AccountStarted event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final user = await _userRepository.getUser();
      emit(AccountLoaded(user));
    } catch (e) {
      emit(const AccountError('Failed to load account data'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<AccountState> emit,
  ) async {
    if (state is AccountLoaded) {
      final currentUser = (state as AccountLoaded).user;
      emit(AccountLoading());
      try {
        final newUser = currentUser.copyWith(
          name: event.name,
          email: event.email,
        );
        await _userRepository.updateUser(newUser);
        emit(AccountLoaded(newUser));
      } catch (e) {
        emit(const AccountError('Failed to update profile'));
        emit(AccountLoaded(currentUser));
      }
    }
  }
}
