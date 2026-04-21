import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/register_request.dart';
import '../data/repo/register_repo.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final RegisterRepo _registerRepo;

  RegisterCubit(this._registerRepo) : super(const RegisterStates.initial());

  // ==================== VALIDATION ====================

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'field_required';
    if (!isValidName(value.trim())) return 'invalid_name';
    return null;
  }

  // Old logic: only alpha characters
  bool isValidName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z]+$');
    return nameRegex.hasMatch(name);
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return 'field_required';
    if (!isValidUsername(value.trim())) return 'username_in_english';
    return null;
  }

  // Old logic: English alphanumeric only
  bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return usernameRegex.hasMatch(username);
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'field_required';
    if (!isValidEmail(value.trim())) return 'invalid_email';
    return null;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'field_required';
    if (!isValidPhoneFormat(value.trim())) return 'phone_number_invalid_format';
    if (value.trim().length < 6) return 'phone_number_too_short';
    return null;
  }

  bool isValidPhoneFormat(String phoneNumber) {
    final phoneRegex = RegExp(r'^\d+$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'field_required';
    if (value.length < 6) return 'password_too_short';
    return null;
  }

  String? validateConfirmPassword(String password, String? value) {
    if (value == null || value.isEmpty) return 'field_required';
    if (value != password) return 'passwords_do_not_match';
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return 'field_required';
    return null;
  }

  // Old logic: birthday is required
  String? validateBirthday(String? value) {
    if (value == null || value.trim().isEmpty) return 'field_required';
    return null;
  }

  // ==================== REGISTER ====================

  Future<void> register({required RegisterRequest registerRequest}) async {
    emit(const RegisterStates.loading());

    final result = await _registerRepo.register(registerRequest);

    result.when(
      success: (response) {
        emit(RegisterStates.success(response));
      },
      failure: (error) {
        emit(RegisterStates.error(message: _mapError(error)));
      },
    );
  }

  String _mapError(String error) {
    switch (error) {
      case 'username_exists_error':
        return 'username_exists_error'.tr();
      default:
        return 'register_error'.tr();
    }
  }
}