import 'package:app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/helpers/app_utilities.dart';
import '../../../core/helpers/extensions.dart';
import '../../../core/routing/routes.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../logic/login_cubit.dart';
import '../logic/login_states.dart';
import 'widgets/enable_biometric_bottom_sheet.dart';
import 'widgets/login_view_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          state.whenOrNull(
            success: (response) async {
              AudioService().playAudio(
                src: 'sounds/audSuccess.mp3',
                onComplete: () => debugPrint('audio played'),
              );

              // Check if biometric already enabled
              final isEnabled = await AppUtilities().isBiometricEnabled();

              if (!context.mounted) return;

              if (isEnabled) {
                if (!context.mounted) return;
                context.pushNamedAndRemoveUntil(
                  Routes.landingView,
                  predicate: false,
                );
              } else {
                // First time — show bottom sheet
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider.value(
                    value: context.read<LoginCubit>(),
                    child: const EnableBiometricBottomSheet(),
                  ),
                );
              }
            },
            error: (message) {
              context.showErrorToast(message);
            },
            emptyInput: () {
              context.showErrorToast('enter_required_fields'.tr());
            },
            biometricFailed: (message) {
              context.showErrorToast(message.tr());
            },
            biometricNotSetup: () {
              context.showErrorToast('biometric_not_setup'.tr());
            },
            biometricEnabled: () {
              context.showSuccessToast('biometric_enabled'.tr());
              context.pushNamedAndRemoveUntil(
                Routes.landingView,
                predicate: false,
              );
            },
          );
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is Loading || state is BiometricPrompt,
            progressIndicator: const CustomLoadingIndicator(),
            color: Colors.black,
            opacity: 0.5,
            child: const Scaffold(
              backgroundColor: AppColor.primaryColor,
              body: LoginViewBody(),
            ),
          );
        },
      ),
    );
  }
}