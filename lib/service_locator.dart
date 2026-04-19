import 'package:get_it/get_it.dart';

// Domain - Repositories (interfaces)
import 'domain/repositories/asset_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/discovery_repository.dart';

// Domain - Use Cases
import 'domain/usecases/get_assets_use_case.dart';
import 'domain/usecases/add_asset_use_case.dart';
import 'domain/usecases/get_net_worth_history_use_case.dart';
import 'domain/usecases/get_user_use_case.dart';
import 'domain/usecases/update_user_use_case.dart';
import 'domain/usecases/login_use_case.dart';
import 'domain/usecases/register_use_case.dart';
import 'domain/usecases/logout_use_case.dart';
import 'domain/usecases/get_auth_status_use_case.dart';
import 'domain/usecases/get_market_assets_use_case.dart';
import 'domain/usecases/get_theme_mode_use_case.dart';
import 'domain/usecases/set_theme_mode_use_case.dart';
import 'domain/usecases/get_locale_use_case.dart';
import 'domain/usecases/set_locale_use_case.dart';
import 'domain/usecases/get_biometrics_enabled_use_case.dart';
import 'domain/usecases/set_biometrics_enabled_use_case.dart';
import 'core/services/biometric_service.dart';

// Data - Data Sources
import 'data/datasources/asset_remote_data_source.dart';

// Data - Repositories (implementations)
import 'data/repositories/mock_asset_repository.dart';
import 'data/repositories/mock_user_repository.dart';
import 'data/repositories/mock_auth_repository.dart';
import 'data/repositories/mock_discovery_repository.dart';
import 'data/repositories/hive_settings_repository.dart';

// BLoCs
import 'logic/blocs/dashboard/dashboard_bloc.dart';
import 'logic/blocs/account/account_bloc.dart';
import 'logic/blocs/settings/settings_bloc.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/discovery/discovery_bloc.dart';
import 'logic/blocs/playground/playground_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Data Sources ---
  sl.registerLazySingleton<AssetRemoteDataSource>(
      () => MockAssetRemoteDataSource());

  // --- Repositories (stateless, always singletons) ---
  sl.registerLazySingleton<AssetRepository>(
      () => MockAssetRepository(sl()));
  sl.registerLazySingleton<UserRepository>(() => MockUserRepository());
  sl.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  sl.registerLazySingleton<DiscoveryRepository>(() => MockDiscoveryRepository());

  // HiveSettingsRepository requires async init before use — created manually
  // and registered after init() so the box is open before anything calls sl<SettingsRepository>().
  final settingsRepository = HiveSettingsRepository();
  await settingsRepository.init();
  sl.registerLazySingleton<SettingsRepository>(() => settingsRepository);

  // --- Use Cases (stateless, always singletons) ---
  sl.registerLazySingleton(() => GetAssetsUseCase(sl()));
  sl.registerLazySingleton(() => AddAssetUseCase(sl()));
  sl.registerLazySingleton(() => GetNetWorthHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetMarketAssetsUseCase(sl()));
  sl.registerLazySingleton(() => GetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => SetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => GetLocaleUseCase(sl()));
  sl.registerLazySingleton(() => SetLocaleUseCase(sl()));
  sl.registerLazySingleton(() => GetBiometricsEnabledUseCase(sl()));
  sl.registerLazySingleton(() => SetBiometricsEnabledUseCase(sl()));
  sl.registerLazySingleton(() => BiometricService());

  // --- Global BLoCs (state must survive page navigation — singletons) ---
  // AuthBloc: controls the entire auth gate.
  // SettingsBloc: controls theme and locale for the whole app.
  // AccountBloc: user profile is needed in AccountPage and SettingsPage simultaneously.
  sl.registerLazySingleton(() => AuthBloc(sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(
      () => SettingsBloc(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(() => AccountBloc(sl(), sl()));

  // --- Page-scoped BLoCs (fresh instance per page mount — factories) ---
  // DashboardBloc: owns dashboard data, created by MainScaffold.
  // DiscoveryBloc: owns market data, created on-demand in AssetsPage.
  sl.registerFactory(() => DashboardBloc(sl(), sl(), sl()));
  sl.registerFactory(
      () => DiscoveryBloc(getMarketAssets: sl()));
  sl.registerFactory(() => PlaygroundBloc());
}
