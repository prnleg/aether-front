import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Wraps [LocalAuthentication] so the rest of the app never imports local_auth directly.
/// Swap this implementation when moving to a real backend that handles auth tokens.
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Returns true if the device supports biometric authentication.
  Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (e) {
      debugPrint('BiometricService.isAvailable: $e');
      return false;
    }
  }

  /// Prompts the user with a biometric dialog.
  /// Returns true if authentication succeeded.
  Future<bool> authenticate(String localizedReason) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      debugPrint('BiometricService.authenticate: $e');
      return false;
    }
  }
}
