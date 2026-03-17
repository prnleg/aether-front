import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_event.dart';
import 'account_state.dart';
import '../../data/models/user_model.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<AccountStarted>(_onAccountStarted);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onAccountStarted(
    AccountStarted event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      // Mock user fetching
      await Future.delayed(const Duration(milliseconds: 500));
      const user = UserModel(
        id: 'user_123',
        name: 'John Doe',
        email: 'john.doe@example.com',
      );
      emit(const AccountLoaded(user));
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
        await Future.delayed(const Duration(milliseconds: 500));
        final newUser = currentUser.copyWith(
          name: event.name,
          email: event.email,
        );
        emit(AccountLoaded(newUser));
      } catch (e) {
        emit(const AccountError('Failed to update profile'));
        emit(AccountLoaded(currentUser));
      }
    }
  }
}
