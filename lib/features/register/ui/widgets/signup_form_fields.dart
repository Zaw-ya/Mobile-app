import 'package:app/generated/fonts.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/input_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../location/data/models/city_response.dart';
import '../../../location/data/models/country_response.dart';
import '../../../location/logic/location_cubit.dart';
import '../../../location/ui/gate_keeper_location_selector.dart';
import '../../logic/register_cubit.dart';
import 'gender_selector.dart';

class SignupFormFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final RegisterCubit cubit;
  final String? selectedGender;
  final ValueChanged<String> onGenderChanged;

  const SignupFormFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.cubit,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First Name
        InputText.normal(
          title: 'first_name'.tr(),
          hint: 'first_name_hint'.tr(),
          controller: firstNameController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zأ-ي\s]')),
          ],
          keyboardType: TextInputType.text,
          validator: (value) => cubit.validateName(value)?.tr(),
        ),
        SizedBox(height: edge * 0.4),

        // Last Name
        InputText.normal(
          title: 'last_name'.tr(),
          hint: 'last_name_hint'.tr(),
          controller: lastNameController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zأ-ي\s]')),
          ],
          keyboardType: TextInputType.text,
          validator: (value) => cubit.validateName(value)?.tr(),
        ),
        SizedBox(height: edge * 0.4),

        // Username — English only
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputText.normal(
              title: 'username'.tr(),
              hint: 'username_in_english'.tr(),
              controller: usernameController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              ],
              keyboardType: TextInputType.text,
              validator: (value) => cubit.validateUsername(value)?.tr(),
            ),
            ValueListenableBuilder(
              valueListenable: usernameController,
              builder: (context, TextEditingValue v, _) {
                if (v.text.isEmpty) return const SizedBox.shrink();
                final isValid = cubit.isValidUsername(v.text);
                return Padding(
                  padding: EdgeInsets.only(top: edge * 0.2),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor:
                        isValid ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: edge * 0.3),
                      Text(
                        isValid
                            ? '${'correct'.tr()}: ${'username_in_english'.tr()}'
                            : 'username_in_english'.tr(),
                        style: TextStyle(
                          fontFamily: FontFamily.manchetteFine,
                          fontSize: 12.sp,
                          color: isValid ? AppColor.semanticSuccess : AppColor.semanticError,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: edge * 0.4),
        GenderSelector(
          selectedGender: selectedGender,
          onGenderChanged: onGenderChanged,
        ),
        SizedBox(height: edge * 0.4),
        // Email
        InputText.normal(
          title: 'email'.tr(),
          hint: 'email_hint'.tr(),
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => cubit.validateEmail(value)?.tr(),
        ),
        SizedBox(height: edge * 0.4),

        // Phone
        InputText.normal(
          title: '${'phone'.tr()} (${'optional'.tr()})',
          hint: 'phone_no_hint'.tr(),
          controller: phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => cubit.validatePhone(value)?.tr(),
        ),
        SizedBox(height: edge * 0.4),

        // Password
        InputText.password(
          title: 'password'.tr(),
          hint: 'password_hint'.tr(),
          controller: passwordController,
          validator: (value) => cubit.validatePassword(value)?.tr(),
        ),
        SizedBox(height: edge * 0.4),

        // Confirm Password
        InputText.password(
          title: 'confirm_password'.tr(),
          hint: 'confirm_password_hint'.tr(),
          controller: confirmPasswordController,
          validator: (value) =>
              cubit.validateConfirmPassword(passwordController.text, value)?.tr(),
        ),
        SizedBox(height: edge * 0.4),

        // // Birthday — old date picker
        // GestureDetector(
        //   onTap: onBirthdayTap,
        //   child: AbsorbPointer(
        //     child: InputText.normal(
        //       title: 'birthday'.tr(),
        //       hint: 'birthday_hint'.tr(),
        //       controller: birthdayController,
        //       suffixIcon:  Icon(
        //         Icons.calendar_today_outlined,
        //         color: AppColor.gray300,
        //         size: 20,
        //       ),
        //       validator: (value) => cubit.validateBirthday(value)?.tr(),
        //     ),
        //   ),
        // ),
        // SizedBox(height: edge * 0.4),

        // ── Country & City — old GatekeeperLocationSelector ──
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
              text: 'address'.tr(),
              color: AppColor.gray700,
              fontSize: 16,
              align: TextAlign.start,
            ),
            SizedBox(height: edge * 0.5),
            GatekeeperLocationSelector(
              onCountryChange: (CountryResponse country) {
                context.read<LocationCubit>().setSelectedCountry(country);
              },
              onCityChange: (CityResponse city) {
                context.read<LocationCubit>().setSelectedCity(city);
              },
            ),
          ],
        ),
      ],
    );
  }
}