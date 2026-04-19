import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aether/l10n/app_localizations.dart';
import '../../../core/services/biometric_service.dart';
import '../../../logic/blocs/settings/settings_bloc.dart';
import '../../../logic/blocs/settings/settings_event.dart';
import '../../../logic/blocs/settings/settings_state.dart';
import '../../../logic/blocs/account/account_bloc.dart';
import '../../../logic/blocs/account/account_state.dart';
import '../../../service_locator.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _toggleBiometrics(
    BuildContext context,
    bool value,
    AppLocalizations l10n,
  ) async {
    final biometricService = sl<BiometricService>();
    final available = await biometricService.isAvailable();

    if (!available) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.biometricsNotAvailable)),
        );
      }
      return;
    }

    if (value) {
      final authenticated =
          await biometricService.authenticate(l10n.biometricReason);
      if (authenticated && context.mounted) {
        context.read<SettingsBloc>().add(const BiometricToggled(true));
      }
    } else {
      if (context.mounted) {
        context.read<SettingsBloc>().add(const BiometricToggled(false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.vaultTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildVaultHeader(isDark, l10n),
              const SizedBox(height: 30),
              _buildSectionHeader(l10n.securitySection),
              _buildSettingsTile(
                context,
                title: l10n.biometricLock,
                subtitle: l10n.biometricSubtitle,
                icon: Icons.fingerprint,
                trailing: Switch.adaptive(
                  value: settingsState.biometricsEnabled,
                  onChanged: (value) =>
                      _toggleBiometrics(context, value, l10n),
                  activeThumbColor: const Color(0xFF2E3192),
                ),
              ),
              _buildSettingsTile(
                context,
                title: l10n.twoFactorAuth,
                subtitle: l10n.twoFactorSubtitle,
                icon: Icons.security,
                onTap: () {},
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(l10n.preferencesSection),
              _buildSettingsTile(
                context,
                title: l10n.primaryCurrency,
                subtitle: _currencySubtitle(settingsState.locale),
                icon: Icons.payments_outlined,
                onTap: () => _showCurrencyPicker(context, l10n),
              ),
              _buildSettingsTile(
                context,
                title: l10n.appearance,
                subtitle: isDark ? l10n.darkMode : l10n.lightMode,
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                trailing: Switch.adaptive(
                  value: isDark,
                  onChanged: (_) {
                    HapticFeedback.lightImpact();
                    context.read<SettingsBloc>().add(ToggleTheme());
                  },
                  activeThumbColor: const Color(0xFF2E3192),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(l10n.apiConnections),
              BlocBuilder<AccountBloc, AccountState>(
                builder: (context, accountState) {
                  final userName = accountState is AccountLoaded
                      ? accountState.user.name
                      : 'User';
                  return _buildSettingsTile(
                    context,
                    title: l10n.steamInventoryApi,
                    subtitle: l10n.connectedAs(userName),
                    icon: FontAwesomeIcons.steam,
                    onTap: () => HapticFeedback.lightImpact(),
                  );
                },
              ),
              _buildSettingsTile(
                context,
                title: l10n.exchangeApiKeys,
                subtitle: l10n.exchangeApiSubtitle,
                icon: Icons.api,
                onTap: () => HapticFeedback.lightImpact(),
              ),
              const SizedBox(height: 40),
              Center(
                child: TextButton(
                  onPressed: () => HapticFeedback.lightImpact(),
                  child: Text(
                    l10n.deleteAccount,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _currencySubtitle(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'USD (\$)';
      case 'pt':
        return 'BRL (R\$)';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  Widget _buildVaultHeader(bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3192).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.lock_person, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          Text(
            l10n.vaultHeaderTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.vaultHeaderSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF2E3192)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.selectCurrency,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildCurrencyItem('USD', l10n.usdName, '\$', onTap: () {
                HapticFeedback.lightImpact();
                context
                    .read<SettingsBloc>()
                    .add(const ChangeLanguage(Locale('en')));
                Navigator.pop(context);
              }),
              _buildCurrencyItem('BRL', l10n.brlName, 'R\$', onTap: () {
                HapticFeedback.lightImpact();
                context
                    .read<SettingsBloc>()
                    .add(const ChangeLanguage(Locale('pt')));
                Navigator.pop(context);
              }),
              _buildCurrencyItem('EUR', l10n.eurName, '€', onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              }),
              _buildCurrencyItem('BTC', l10n.btcName, '₿', onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrencyItem(String code, String name, String symbol,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF2E3192).withValues(alpha: 0.1),
        child: Text(symbol, style: const TextStyle(color: Color(0xFF2E3192))),
      ),
      title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(name),
      onTap: onTap,
    );
  }
}
