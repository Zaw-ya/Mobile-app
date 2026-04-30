import 'package:app/features/profile/logic/profile_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/helpers/app_utilities.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/client_header.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../logic/profile_cubit.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu.dart';
import 'widgets/user_cart.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        final isLoading = state is Loading;

        // Extract profile from success state
        final profile = state.maybeWhen(
          success: (profile) => profile,
          orElse: () => null,
        );

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const CustomLoadingIndicator(),
          color: Colors.black,
          opacity: 0.5,
          child: Scaffold(
            backgroundColor: AppColor.whiteColor,
            key: ValueKey(currentLocale.languageCode),
            body: Column(
              children: [
                AppUtilities().loginData.roleName == "Client"
                    ? ClientHeader(
                        title:
                            '${AppUtilities().loginData.firstName} ${AppUtilities().loginData.lastName}',
                        subTitle: "welcome".tr(),
                      )
                    : ProfileHeader(),
                UserCart(profileModel: profile),
                Expanded(child: ProfileMenu()),
              ],
            ),
          ),
        );
      },
    );
  }
}
