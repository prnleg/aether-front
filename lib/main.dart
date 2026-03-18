import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'presentation/pages/main_scaffold.dart';
import 'logic/blocs/settings/settings_bloc.dart';
import 'logic/blocs/settings/settings_state.dart';
import 'presentation/theme/app_theme.dart';
import 'service_locator.dart' as sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sl.init();
  runApp(const AetherApp());
}

class AetherApp extends StatelessWidget {
  const AetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.sl<SettingsBloc>(),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
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
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}
