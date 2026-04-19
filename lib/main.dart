import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:aether/l10n/app_localizations.dart';
import 'core/services/biometric_service.dart';
import 'domain/repositories/auth_repository.dart';
import 'logic/blocs/settings/settings_bloc.dart';
import 'logic/blocs/settings/settings_event.dart';
import 'logic/blocs/settings/settings_state.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/account/account_bloc.dart';
import 'logic/blocs/account/account_event.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/router/app_router.dart';
import 'service_locator.dart' as sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await sl.init();
  runApp(const AetherApp());
}

class AetherApp extends StatefulWidget {
  const AetherApp({super.key});

  @override
  State<AetherApp> createState() => _AetherAppState();
}

class _AetherAppState extends State<AetherApp> with WidgetsBindingObserver {
  late final AppRouter _appRouter;
  bool _isLocked = false;
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(sl.sl<AuthBloc>());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.paused) {
      _wasInBackground = true;
    } else if (appState == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      _checkAndLock();
    }
  }

  void _checkAndLock() {
    final settingsState = sl.sl<SettingsBloc>().state;
    final authState = sl.sl<AuthBloc>().state;
    if (settingsState.biometricsEnabled &&
        authState.status == AuthStatus.authenticated) {
      setState(() => _isLocked = true);
      _authenticateToUnlock();
    }
  }

  Future<void> _authenticateToUnlock() async {
    final authenticated = await sl
        .sl<BiometricService>()
        .authenticate('Authenticate to unlock Aether');
    if (authenticated && mounted) {
      setState(() => _isLocked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl.sl<SettingsBloc>()..add(LoadSettings()),
        ),
        BlocProvider(create: (context) => sl.sl<AuthBloc>()),
        BlocProvider(
          create: (context) => sl.sl<AccountBloc>()..add(AccountStarted()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: _appRouter.router,
            title: 'Aether',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('pt'),
            ],
            builder: (context, child) {
              if (_isLocked) {
                return _LockScreen(onUnlock: _authenticateToUnlock);
              }
              return child ?? const SizedBox();
            },
          );
        },
      ),
    );
  }
}

class _LockScreen extends StatelessWidget {
  final Future<void> Function() onUnlock;

  const _LockScreen({required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, color: Colors.white, size: 72),
              const SizedBox(height: 24),
              Text(
                l10n?.vaultHeaderTitle ?? 'Aether Vault',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.biometricReason ?? 'Authenticate to unlock',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: onUnlock,
                icon: const Icon(Icons.fingerprint),
                label: Text(l10n?.biometricLock ?? 'Unlock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2E3192),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
