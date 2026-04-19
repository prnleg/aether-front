import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../pages/main_scaffold.dart';
import '../pages/main/dashboard_page.dart';
import '../pages/main/assets_page.dart';
import '../pages/main/discovery_hub_page.dart';
import '../pages/main/playground_page.dart';
import '../pages/main/account_page.dart';
import '../pages/main/settings_page.dart';
import '../pages/assets/add_asset_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../../logic/blocs/discovery/discovery_bloc.dart';
import '../../logic/blocs/playground/playground_bloc.dart';
import '../../service_locator.dart';

class AppRouter {
  final AuthBloc authBloc;
  static int _previousIndex = 0;

  AppRouter(this.authBloc);

  static int getSelectedIndex(String location) {
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/assets')) return 1;
    if (location.startsWith('/playground')) return 2;
    if (location.startsWith('/account')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  static Page<dynamic> _buildPageWithTransition(
      BuildContext context, GoRouterState state, Widget child) {
    final int newIndex = getSelectedIndex(state.matchedLocation);
    final bool isReverse = newIndex < _previousIndex;
    _previousIndex = newIndex;

    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: Offset(isReverse ? -1.0 : 1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }

  late final router = GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final bool isAuthenticated = authBloc.state.status == AuthStatus.authenticated;
      final bool isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/assets',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const AssetsPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddAssetPage(),
              ),
              GoRoute(
                path: 'discovery',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<DiscoveryBloc>(),
                  child: const DiscoveryHubPage(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/playground',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              BlocProvider(
                create: (_) => sl<PlaygroundBloc>(),
                child: const PlaygroundPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/account',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const AccountPage(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
