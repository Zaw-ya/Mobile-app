import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/login/data/models/login_response.dart';
import '../services/navigation_service.dart';

class AppUtilities {
  static final AppUtilities _instance = AppUtilities._internal();

  static AppUtilities get instance => _instance;

  factory AppUtilities() {
    return _instance;
  }

  AppUtilities._internal();

  Future<void> initialize() async {
    await _getSavedData();
  }

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final prefs = SharedPreferences;

  String? _serverToken;

  String get serverToken {
    return _serverToken ?? "";
  }

  set serverToken(String token) {
    _serverToken = token;
    setSavedString("serverToken", token);
  }

  bool get isLTR {
    return NavigationService.navigatorKey.currentContext!.locale.languageCode ==
        "en";
  }

  String? _username;

  String get username => _username ?? '';

  set username(String value) {
    _username = value;
    setSavedString("username", value);
  }

  String? _subscriptionTopic;

  String get subscriptionTopic => _subscriptionTopic ?? '';

  set subscriptionTopic(String value) {
    _subscriptionTopic = value;
    setSavedString("subscriptionTopic", value);
  }

  bool? _notifications;

  bool get notifications => _notifications ?? false;

  set notifications(bool value) {
    _notifications = value;
    setSavedBool("notifications", value);
  }

  String? _password;

  String get password => _password ?? '';

  set password(String value) {
    _password = value;
    setSavedString("password", value);
  }

  Future<void> clearData() async {
    _storage.delete(key: "serverToken");
    _storage.delete(key: "userData");

    _storage.delete(key: "notification_userId");
    _storage.delete(key: "notification_userName");
    _storage.delete(key: "notification_address");
    _storage.delete(key: "notification_cityId");
  }

  void setLocality(String code) async {
    NavigationService.navigatorKey.currentContext?.setLocale(Locale(code));
  }

  String getDeviceLanguage() {
    return Platform.localeName.split('_')[0];
  }

  set isLTR(bool x) {
    setSavedString("isLTR", x ? 'true' : 'false');
  }

  LoginResponse? _loginData = LoginResponse();

  LoginResponse get loginData {
    return _loginData!;
  }

  set loginData(LoginResponse x) {
    serverToken = "Bearer ${x.token ?? ""}";
    _loginData = x;
    setSavedString("userData", jsonEncode(x.toJson()));

    debugPrint("saved");
  }

  Future<bool> setSavedString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return true; // Successfully written
    } catch (e, stackTrace) {
      debugPrint('Error saving string value for key "$key": $e');
      debugPrintStack(stackTrace: stackTrace);
      return false; // Indicate failure
    }
  }

  Future<bool> setSavedBool(String key, bool value) async {
    try {
      await _storage.write(key: key, value: value.toString());
      return true; // Successfully written
    } catch (e, stackTrace) {
      debugPrint('Error saving bool value for key "$key": $e');
      debugPrintStack(stackTrace: stackTrace);
      return false; // Indicate failure
    }
  }

  Future<String> getSavedString(String key, String defaultVal) async {
    try {
      final value = await _storage.read(key: key);
      return value ?? defaultVal;
    } catch (e) {
      debugPrint("Decryption failed for [$key]: $e");
      await _storage.delete(key: key); // Optional: remove corrupted value
      return defaultVal;
    }
  }

  Future<bool> getSavedBool(String key, bool defaultVal) async {
    try {
      final value = await _storage.read(key: key);
      return value == 'true' ? true : defaultVal;
    } catch (e, stackTrace) {
      // You can log or handle the error here
      debugPrint('Error reading bool value for key "$key": $e');
      debugPrintStack(stackTrace: stackTrace);
      return defaultVal; // Return default if any error occurs
    }
  }

  Future<void> _getSavedData() async {
    _username = await getSavedString("username", '');
    _password = await getSavedString("password", '');
    _notifications = await getSavedBool("notifications", false);
    _subscriptionTopic = await getSavedString("subscriptionTopic", '');
    _serverToken = await getSavedString("serverToken", '');

    String userData = await getSavedString('userData', '');
    if (userData.isNotEmpty) {
      try {
        _loginData = LoginResponse.fromJson(jsonDecode(userData));
      } catch (e) {
        debugPrint("Failed to parse userData: $e");
        _loginData = LoginResponse(); // Default value to avoid null
      }
    } else {
      _loginData = LoginResponse(); // Default value if no data is saved
    }
  }

  Future<void> clearAllCache() async {
    try {
      // Clear all secure storage
      await _storage.deleteAll();

      // Reset all in-memory variables
      _serverToken = null;
      _username = null;
      _password = null;
      _notifications = null;
      _subscriptionTopic = null;
      _loginData = LoginResponse();

      debugPrint("All cache cleared successfully");
    } catch (e) {
      debugPrint("Failed to clear cache: $e");
    }
  }

  Future<bool> setBool(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(key, value);
    } catch (e, stackTrace) {
      debugPrint('Error saving bool value for key "$key": $e');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  /// Retrieve a boolean value safely with default
  Future<bool> getBool(String key, bool defaultVal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key) ?? defaultVal;
    } catch (e, stackTrace) {
      debugPrint('Error reading bool value for key "$key": $e');
      debugPrintStack(stackTrace: stackTrace);
      return defaultVal;
    }
  }

  Future<bool> setString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(key, value);
    } catch (e, stackTrace) {
      debugPrint('Error saving String value for key "$key": $e');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  Future<String> getString(String key, String defaultVal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key) ?? defaultVal;
    } catch (e, stackTrace) {
      debugPrint('Error reading bool value for key "$key": $e');
      debugPrintStack(stackTrace: stackTrace);
      return defaultVal;
    }
  }

  Future<bool> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(key);
    } catch (e, stackTrace) {
      debugPrint('Error reading bool value for key "$key": $e');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  // ==================== BIOMETRIC ====================

  bool? _biometricEnabled;

  bool get biometricEnabled => _biometricEnabled ?? false;

  Future<bool> isBiometricEnabled() async {
    return await getSavedBool('biometric_enabled', false);
  }

  Future<void> saveBiometricCredentials({
    required String username,
    required String password,
  }) async {
    await setSavedString('biometric_username', username);
    await setSavedString('biometric_password', password);
    await setSavedBool('biometric_enabled', true);
    debugPrint('✅ Biometric credentials saved for: $username');
  }

  Future<Map<String, String>?> getBiometricCredentials() async {
    final username = await getSavedString('biometric_username', '');
    final password = await getSavedString('biometric_password', '');

    if (username.isEmpty || password.isEmpty) {
      debugPrint('⚠️ Biometric credentials not found');
      return null;
    }

    return {'username': username, 'password': password};
  }

  Future<void> clearBiometricCredentials() async {
    await _storage.delete(key: 'biometric_username');
    await _storage.delete(key: 'biometric_password');
    await setSavedBool('biometric_enabled', false);
    debugPrint('🗑️ Biometric credentials cleared');
  }
}
