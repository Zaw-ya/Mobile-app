import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Check if biometrics are supported on device
  static Future<bool> isBiometricSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      debugPrint("Error checking biometric support: $e");
      return false;
    }
  }

  /// Get available biometrics (fingerprint, face, etc.)
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint("Error fetching available biometrics: $e");
      return [];
    }
  }

  /// Authenticate user with biometrics OR fallback to device PIN/Passcode
  static Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint("Biometric auth error: ${e.code} - ${e.message}");
      return false;
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return false;
    }
  }

  /// Helper: return best label for UI
  static Future<String> getPreferredBiometricLabel() async {
    final biometrics = await getAvailableBiometrics();
    if (biometrics.contains(BiometricType.face)) return "Face ID";
    if (biometrics.contains(BiometricType.fingerprint)) return "Fingerprint";
    return "Biometric / Passcode";
  }
}