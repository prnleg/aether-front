import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_event.dart';
import 'account_state.dart';
import '../../../domain/usecases/get_user_use_case.dart';
import '../../../domain/usecases/update_user_use_case.dart';
import '../../../domain/usecases/update_steam_id_use_case.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetUserUseCase _getUser;
  final UpdateUserUseCase _updateUser;
  final UpdateSteamIdUseCase _updateSteamId;

  AccountBloc(this._getUser, this._updateUser, this._updateSteamId)
      : super(AccountInitial()) {
    on<AccountStarted>(_onAccountStarted);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateSteamId>(_onUpdateSteamId);
  }

  Future<void> _onAccountStarted(
    AccountStarted event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final user = await _getUser.execute();
      emit(AccountLoaded(user));
    } catch (e) {
      debugPrint(e.toString());
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
        await _updateUser.execute(newUser);
        emit(AccountLoaded(newUser));
      } catch (e) {
        debugPrint(e.toString());
        emit(const AccountError('Failed to update profile'));
        emit(AccountLoaded(currentUser));
      }
    }
  }

  Future<void> _onUpdateSteamId(
    UpdateSteamId event,
    Emitter<AccountState> emit,
  ) async {
    if (state is AccountLoaded) {
      final currentUser = (state as AccountLoaded).user;
      try {
        await _updateSteamId.execute(event.steamId);
        emit(AccountLoaded(currentUser.copyWith(steamId: event.steamId)));
      } catch (e) {
        debugPrint(e.toString());
        emit(const AccountError('Failed to update Steam ID'));
        emit(AccountLoaded(currentUser));
      }
    }
  }
}
