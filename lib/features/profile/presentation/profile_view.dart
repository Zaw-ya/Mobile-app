import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/custom_loading_indicator.dart';
import 'package:app/features/profile/logic/profile_cubit.dart';
import 'package:app/features/profile/logic/profile_states.dart';
import 'package:app/features/profile/presentation/widgets/profile_header.dart';
import 'package:app/features/profile/presentation/widgets/profile_menu.dart';
import 'package:app/features/profile/presentation/widgets/user_cart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const CustomLoadingIndicator(),
          color: Colors.black,
          opacity: 0.5,
          child: Scaffold(
            backgroundColor: AppColor.primaryLight,
            key: ValueKey(currentLocale.languageCode),
            body: state.whenOrNull(
                  success: (profile) => Column(
                    children: [
                      ProfileHeader(
                        firstName: "${profile.firstName}",
                        lastName: "${profile.lastName}",
                      ),
                      UserCart(profileModel: profile),
                      Expanded(child: ProfileMenu()),
                    ],
                  ),
                  error: (message) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  loading: () => const Center(
                    child: CustomLoadingIndicator(),
                  ),
                ) ??
                const Center(
                  child: CustomLoadingIndicator(),
                ),
          ),
        );
      },
    );
  }
}
