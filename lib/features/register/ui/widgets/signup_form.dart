import 'package:app/features/register/ui/widgets/terms_agreement.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../location/logic/location_cubit.dart';
import '../../data/models/register_request.dart';
import '../../logic/register_cubit.dart';
import 'signup_form_fields.dart';
import 'terms_and_conditions_bottom_sheet.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  String _selectedGender = 'm';
  bool _agreedToTerms = false;

  // Expose for external call from RegisterScreen
  void submitForm() => _handleSubmit();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Old date picker logic
  // Future<void> _selectBirthday() async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: const ColorScheme.light(
  //             primary: AppColor.primaryColor,
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   // if (picked != null) {
  //   //   setState(() {
  //   //     // Old format: yyyy-MM-dd
  //   //     _birthdayController.text =
  //   //     '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
  //   //   });
  //   // }
  // }

  void _handleSubmit() {
    if (!_agreedToTerms) {
      context.showErrorToast('please_agree_to_terms'.tr());
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Old logic: validate city is selected
      final cityId = context.read<LocationCubit>().selectedCity?.id ?? 0;
      if (cityId == 0) {
        context.showErrorToast('enter_required_fields'.tr());
        return;
      }

      final registerRequest = RegisterRequest(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        userName: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phoneNumber: _phoneController.text.trim(),
        gender: _selectedGender,
        role: 'Gatekeeper',
        cityId: cityId, // ✅ from LocationCubit
      );

      context.read<RegisterCubit>().register(registerRequest: registerRequest);
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SignupFormFields(
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              usernameController: _usernameController,
              emailController: _emailController,
              phoneController: _phoneController,
             // birthdayController: _birthdayController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              cubit: cubit,
              selectedGender: _selectedGender,       // ✅ pass down
              onGenderChanged: (gender) {
                setState(() => _selectedGender = gender);
              },
             // onBirthdayTap: _selectBirthday, // old date picker
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: edge * 0.7)),

          // Terms
          SliverToBoxAdapter(
            child: TermsAgreement(
              agreedToTerms: _agreedToTerms,
              onChanged: (value) {
                setState(() => _agreedToTerms = value);
              },
              onTermsTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: GestureDetector(
                      onTap: () {},
                      child: const TermsAndConditionsBottomSheet(),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: edge * 2)),
        ],
      ),
    );
  }
}