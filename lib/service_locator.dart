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
import 'domain/usecases/update_steam_id_use_case.dart';
import 'domain/usecases/login_use_case.dart';
import 'domain/usecases/register_use_case.dart';
import 'domain/usecases/logout_use_case.dart';
import 'domain/usecases/get_auth_status_use_case.dart';
import 'domain/usecases/get_cached_name_use_case.dart';
import 'domain/usecases/get_discovery_items_use_case.dart';
import 'domain/usecases/sync_steam_inventory_use_case.dart';
import 'domain/usecases/approve_discovery_item_use_case.dart';
import 'domain/usecases/reject_discovery_item_use_case.dart';
import 'domain/usecases/get_theme_mode_use_case.dart';
import 'domain/usecases/set_theme_mode_use_case.dart';
import 'domain/usecases/get_locale_use_case.dart';
import 'domain/usecases/set_locale_use_case.dart';
import 'domain/usecases/get_biometrics_enabled_use_case.dart';
import 'domain/usecases/set_biometrics_enabled_use_case.dart';
import 'domain/usecases/get_currency_use_case.dart';
import 'domain/usecases/set_currency_use_case.dart';
import 'domain/usecases/delete_asset_use_case.dart';
import 'core/services/biometric_service.dart';

// Network & Services
import 'core/network/api_client.dart';
import 'core/network/auth_interceptor.dart';
import 'core/services/token_storage.dart';

// Data - Data Sources
import 'data/datasources/asset_remote_data_source.dart';
import 'data/datasources/asset_remote_data_source_impl.dart';
import 'data/datasources/discovery_remote_data_source.dart';
import 'data/datasources/discovery_remote_data_source_impl.dart';

// Data - Repositories (implementations)
import 'data/repositories/asset_repository_impl.dart';
import 'data/repositories/discovery_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
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
  // --- Network & Token Storage ---
  final tokenStorage = TokenStorage();
  await tokenStorage.init();
  sl.registerLazySingleton<TokenStorage>(() => tokenStorage);
  sl.registerLazySingleton(() => AuthInterceptor(tokenStorage));
  sl.registerLazySingleton(() => ApiClient(sl()));

  // --- Data Sources ---
  sl.registerLazySingleton<AssetRemoteDataSource>(
      () => AssetRemoteDataSourceImpl(sl<ApiClient>(), sl<TokenStorage>()));
  sl.registerLazySingleton<DiscoveryRemoteDataSource>(
      () => DiscoveryRemoteDataSourceImpl(sl<ApiClient>()));

  // --- Repositories ---
  sl.registerLazySingleton<AssetRepository>(() => AssetRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<ApiClient>(), sl<TokenStorage>()));
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(sl<ApiClient>(), sl<TokenStorage>()));
  sl.registerLazySingleton<DiscoveryRepository>(
      () => DiscoveryRepositoryImpl(sl<DiscoveryRemoteDataSource>()));

  // HiveSettingsRepository requires async init — created manually before registration.
  final settingsRepository = HiveSettingsRepository();
  await settingsRepository.init();
  sl.registerLazySingleton<SettingsRepository>(() => settingsRepository);

  // --- Use Cases (stateless, always singletons) ---
  sl.registerLazySingleton(() => GetAssetsUseCase(sl()));
  sl.registerLazySingleton(() => AddAssetUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAssetUseCase(sl()));
  sl.registerLazySingleton(() => GetNetWorthHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSteamIdUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedNameUseCase(sl()));
  sl.registerLazySingleton(() => GetDiscoveryItemsUseCase(sl()));
  sl.registerLazySingleton(() => SyncSteamInventoryUseCase(sl()));
  sl.registerLazySingleton(() => ApproveDiscoveryItemUseCase(sl()));
  sl.registerLazySingleton(() => RejectDiscoveryItemUseCase(sl()));
  sl.registerLazySingleton(() => GetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => SetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => GetLocaleUseCase(sl()));
  sl.registerLazySingleton(() => SetLocaleUseCase(sl()));
  sl.registerLazySingleton(() => GetBiometricsEnabledUseCase(sl()));
  sl.registerLazySingleton(() => SetBiometricsEnabledUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrencyUseCase(sl()));
  sl.registerLazySingleton(() => SetCurrencyUseCase(sl()));
  sl.registerLazySingleton(() => BiometricService());

  // --- Global BLoCs (state must survive page navigation — singletons) ---
  sl.registerLazySingleton(() => AuthBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(
      () => SettingsBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(
      () => AccountBloc(sl(), sl(), sl()));

  // --- Page-scoped BLoCs (fresh instance per page mount — factories) ---
  sl.registerFactory(() => DashboardBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => DiscoveryBloc(
        getItems: sl(),
        sync: sl(),
        approve: sl(),
        reject: sl(),
      ));
  sl.registerFactory(() => PlaygroundBloc());
}
