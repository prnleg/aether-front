import 'package:get_it/get_it.dart';
import 'domain/repositories/asset_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/discovery_repository.dart';
import 'data/repositories/mock_asset_repository.dart';
import 'data/repositories/mock_user_repository.dart';
import 'data/repositories/mock_auth_repository.dart';
import 'data/repositories/mock_discovery_repository.dart';
import 'logic/blocs/dashboard/dashboard_bloc.dart';
import 'logic/blocs/account/account_bloc.dart';
import 'logic/blocs/settings/settings_bloc.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/discovery/discovery_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  final settingsRepository = HiveSettingsRepository();
  await settingsRepository.init();
  sl.registerLazySingleton<SettingsRepository>(() => settingsRepository);

  sl.registerLazySingleton<AssetRepository>(() => MockAssetRepository());
  sl.registerLazySingleton<UserRepository>(() => MockUserRepository());
  sl.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  sl.registerLazySingleton<DiscoveryRepository>(() => MockDiscoveryRepository());

  // Blocs
  sl.registerFactory(() => DashboardBloc(sl()));
  sl.registerFactory(() => AccountBloc(sl()));
  sl.registerFactory(() => DiscoveryBloc(repository: sl()));
  sl.registerLazySingleton(() => SettingsBloc(sl()));
  sl.registerLazySingleton(() => AuthBloc(sl()));
}
