import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../logic/blocs/dashboard/dashboard_bloc.dart';
import '../../logic/blocs/dashboard/dashboard_event.dart';
import '../../service_locator.dart';
import 'dashboard_page.dart';
import 'assets_page.dart';
import 'account_page.dart';
import 'settings_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  static _MainScaffoldState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainScaffoldState>();

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  void setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const DashboardPage(),
    const AssetsPage(),
    const AccountPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 800;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(DashboardStarted()),
      child: Scaffold(
        body: Row(
          children: [
            if (isWide)
              SizedBox(
                width: 110,
                child: NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: setSelectedIndex,
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Icon(Icons.auto_awesome, size: 40, color: Color(0xFF2E3192)),
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.dashboard_outlined),
                      selectedIcon: const Icon(Icons.dashboard),
                      label: Text(l10n.dashboard),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.account_balance_wallet_outlined),
                      selectedIcon: const Icon(Icons.account_balance_wallet),
                      label: Text(l10n.assets),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.person_outline),
                      selectedIcon: const Icon(Icons.person),
                      label: Text(l10n.account),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.settings_outlined),
                      selectedIcon: const Icon(Icons.settings),
                      label: Text(l10n.settings),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
        bottomNavigationBar: !isWide
            ? BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: setSelectedIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.dashboard_outlined),
                    activeIcon: const Icon(Icons.dashboard),
                    label: l10n.dashboard,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.account_balance_wallet_outlined),
                    activeIcon: const Icon(Icons.account_balance_wallet),
                    label: l10n.assets,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person_outline),
                    activeIcon: const Icon(Icons.person),
                    label: l10n.account,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.settings_outlined),
                    activeIcon: const Icon(Icons.settings),
                    label: l10n.settings,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
