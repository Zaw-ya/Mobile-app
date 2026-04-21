import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/app_utilities.dart';
import '../../../core/helpers/biometric_service.dart';
import '../data/models/login_request.dart';
import '../data/repo/login_repo.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(const LoginStates.initial());

  final TextEditingController param = TextEditingController();
  final TextEditingController password = TextEditingController();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  // ==================== VALIDATION ====================

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return "username_required";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "password_required";
    if (value.length < 6) return "password_min_length";
    return null;
  }

  // ==================== LOGIN ====================

  void login() async {
    try {
      emit(const LoginStates.loading());

      if (param.text.isEmpty || password.text.isEmpty) {
        emit(const LoginStates.emptyInput());
        return;
      }

      final trimmedUsername = param.text.trim();

      final response = await _loginRepo.login(LoginRequest(
        username: trimmedUsername,
        password: password.text,
        deviceId: await getUniqueDeviceId(),
      ));

      response.when(
        success: (response) {
          // Save credentials using AppUtilities
          AppUtilities().username = trimmedUsername;
          AppUtilities().password = password.text;
          AppUtilities().loginData = response;
          param.clear();
          password.clear();
          emit(LoginStates.success(response));
        },
        failure: (error) {
          if (error == 'unauthorized_error') {
            emit(LoginStates.error(message: 'unauthorized_error'.tr()));
          } else if (error == 'unexpected_error') {
            emit(LoginStates.error(message: 'unexpected_error'.tr()));
          } else if (error == 'account_not_approved') {
            emit(LoginStates.error(message: 'account_not_approved'.tr()));
          } else {
            emit(LoginStates.error(message: 'login_error'.tr()));
          }
        },
      );
    } catch (e) {
      emit(LoginStates.error(message: e.toString()));
    }
  }

  // ==================== BIOMETRIC ====================

  Future<bool> checkBiometricAvailability() async {
    final isSupported = await BiometricHelper.isBiometricSupported();
    if (!isSupported) return false;
    return await AppUtilities().isBiometricEnabled();
  }

  Future<void> enableBiometricLogin() async {
    try {
      emit(const LoginStates.loading());

      await AppUtilities().saveBiometricCredentials(
        username: AppUtilities().username,
        password: AppUtilities().password,
      );

      emit(const LoginStates.biometricEnabled());
    } catch (e) {
      emit(LoginStates.error(message: e.toString()));
    }
  }

  Future<void> loginWithBiometric() async {
    try {
      emit(const LoginStates.biometricPrompt());

      final isAvailable = await checkBiometricAvailability();
      if (!isAvailable) {
        emit(const LoginStates.biometricNotSetup());
        return;
      }

      final authenticated = await BiometricHelper.authenticate();
      if (!authenticated) {
        emit(const LoginStates.biometricFailed(
          message: 'biometric_authentication_failed',
        ));
        return;
      }

      final credentials = await AppUtilities().getBiometricCredentials();
      if (credentials == null) {
        emit(const LoginStates.error(
          message: 'biometric_credentials_not_found',
        ));
        return;
      }

      // Fill controllers and trigger normal login
      param.text = credentials['username']!;
      password.text = credentials['password']!;
      login();
    } catch (e) {
      emit(LoginStates.error(message: e.toString()));
    }
  }

  Future<void> disableBiometric() async {
    await AppUtilities().clearBiometricCredentials();
  }

  // ==================== DEVICE ID ====================

  Future<String> getUniqueDeviceId() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor!;
    }
  }

  @override
  Future<void> close() {
    param.dispose();
    password.dispose();
    return super.close();
  }
}