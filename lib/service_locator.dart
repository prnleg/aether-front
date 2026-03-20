import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'domain/repositories/asset_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'data/repositories/mock_asset_repository.dart';
import 'data/repositories/mock_user_repository.dart';
import 'data/repositories/mock_auth_repository.dart';
import 'logic/blocs/dashboard/dashboard_bloc.dart';
import 'logic/blocs/account/account_bloc.dart';
import 'logic/blocs/settings/settings_bloc.dart';
import 'logic/blocs/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Repositories
  sl.registerLazySingleton<AssetRepository>(() => MockAssetRepository());
  sl.registerLazySingleton<UserRepository>(() => MockUserRepository());
  sl.registerLazySingleton<AuthRepository>(() => MockAuthRepository(sl()));

  // Blocs
  sl.registerFactory(() => DashboardBloc(sl()));
  sl.registerFactory(() => AccountBloc(sl()));
  sl.registerLazySingleton(() => SettingsBloc());
  sl.registerLazySingleton(() => AuthBloc(sl()));
}

