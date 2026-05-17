import 'dart:developer';

import 'package:app/core/di/dependency_injection.dart';
import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/custom_loading_indicator.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:app/features/profile/logic/profile_cubit.dart';
import 'package:app/features/profile/logic/profile_states.dart';
import 'package:app/features/profile/presentation/widgets/gk_profile_body.dart';
import 'package:app/features/profile/presentation/widgets/gk_profile_header.dart';
import 'package:app/features/profile/presentation/widgets/profile_header.dart';
import 'package:app/features/profile/presentation/widgets/profile_menu.dart';
import 'package:app/features/profile/presentation/widgets/user_cart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
  });


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
            backgroundColor: AppColor.whiteColor,
            key: ValueKey(currentLocale.languageCode),
            body: state.whenOrNull(
                  success: (profile) => Column(
                    children: [
                      ProfileHeader(
                        firstName: "${profile.firstName}",
                        lastName: "${profile.lastName}",
                      ),
                      UserCart(
                        profileModel: profile,
                      ),
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

// import 'package:app/features/profile/logic/profile_states.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// import '../../../core/helpers/app_utilities.dart';
// import '../../../core/theming/colors.dart';
// import '../../../core/widgets/client_header.dart';
// import '../../../core/widgets/custom_loading_indicator.dart';
// import '../logic/profile_cubit.dart';
// import 'widgets/profile_header.dart';
// import 'widgets/profile_menu.dart';
// import 'widgets/user_cart.dart';

// class ProfileView extends StatefulWidget {
//   const ProfileView({super.key});

//   @override
//   State<ProfileView> createState() => _ProfileViewState();
// }

// class _ProfileViewState extends State<ProfileView> {
//   @override
//   Widget build(BuildContext context) {
//     final currentLocale = context.locale;
//     return BlocBuilder<ProfileCubit, ProfileStates>(
//       builder: (context, state) {
//         final isLoading = state is Loading;

//         // Extract profile from success state
//         final profile = state.maybeWhen(
//           success: (profile) => profile,
//           orElse: () => null,
//         );

//         return ModalProgressHUD(
//           inAsyncCall: isLoading,
//           progressIndicator: const CustomLoadingIndicator(),
//           color: Colors.black,
//           opacity: 0.5,
//           child: Scaffold(
//             backgroundColor: AppColor.whiteColor,
//             key: ValueKey(currentLocale.languageCode),
//             body: Column(
//               children: [
//                 AppUtilities().loginData.roleName == "Client"
//                     ? ClientHeader(
//                         title:
//                             '${AppUtilities().loginData.firstName} ${AppUtilities().loginData.lastName}',
//                         subTitle: "welcome".tr(),
//                       )
//                     : ProfileHeader(firstName: profile.firstName, lastName: profile.lastName,),
//                 UserCart(profileModel: profile),
//                 Expanded(child: ProfileMenu()),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
