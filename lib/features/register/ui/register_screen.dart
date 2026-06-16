import 'package:app/core/routing/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/helpers/extensions.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../../../core/widgets/go_button.dart';
import '../../../core/widgets/public_app_bar.dart';
import '../logic/register_cubit.dart';
import '../logic/register_states.dart';
import 'widgets/signup_form.dart';
import 'widgets/signup_view_body.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<SignupFormState> _formKey = GlobalKey<SignupFormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              context.showErrorToast(message);
            },
            emptyInput: () {
              context.showErrorToast('enter_required_fields'.tr());
            },
            success: (_) {
             context.pushNamedAndRemoveUntil(Routes.successScreen, predicate: false);
            },
          );
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is Loading,
            progressIndicator: const CustomLoadingIndicator(),
            color: Colors.black,
            opacity: 0.5,
            child: Scaffold(
              backgroundColor: AppColor.primaryLight,
              appBar: recordsAppBar(context, 'creating_account'.tr()),
              body: SignupViewBody(formKey: _formKey),
              bottomNavigationBar: Container(
                color: AppColor.primaryLight,
                padding: EdgeInsets.fromLTRB(24, 12, 24, 28),
                child: GoButton(
                  fun: () => _formKey.currentState?.submitForm(),
                  titleKey: 'continue'.tr(),
                  btColor: AppColor.primaryDark,
                  textColor: AppColor.primaryLight,
                  gradient: false,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
