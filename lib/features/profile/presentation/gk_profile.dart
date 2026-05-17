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
import 'package:app/features/profile/presentation/widgets/user_cart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class GkProfile extends StatelessWidget {
  const GkProfile({
    super.key,
    required this.gkId,
  });

  final int gkId;

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    log('GK ID: $gkId');

    return BlocProvider(
      create: (context) =>
          getIt<ProfileCubit>()..getGkProfile(gatekeeperId: gkId),
      child: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            getGatekeeperLoading: () => true,
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
                    getGatekeeperSuccess: (profile) => Column(
                      children: [
                        GkProfileHeader(
                          firstName: "${profile.firstName}",
                          lastName: "${profile.lastName}",
                        ),
                        UserCart(
                          profileModel: profile,
                        ),
                        GkProfileBody(profile: profile)
                      ],
                    ),
                    getGatekeeperError: (message) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    getGatekeeperLoading: () => const Center(
                      child: CustomLoadingIndicator(),
                    ),
                  ) ??
                  const Center(
                    child: CustomLoadingIndicator(),
                  ),
            ),
          );
        },
      ),
    );
  }
}
// import 'dart:developer';

// import 'package:app/core/di/dependency_injection.dart';
// import 'package:app/core/theming/colors.dart';
// import 'package:app/core/widgets/custom_loading_indicator.dart';
// import 'package:app/features/profile/logic/profile_cubit.dart';
// import 'package:app/features/profile/logic/profile_states.dart';
// import 'package:app/features/profile/presentation/widgets/profile_header.dart';
// import 'package:app/features/profile/presentation/widgets/user_cart.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// class GkProfile extends StatelessWidget {
//   const GkProfile({super.key, required this.gkId});
//   final int gkId;
//   @override
//   Widget build(BuildContext context) {
//     final currentLocale = context.locale;
//     log("$gkId >>> GK ID >>>");
//     return BlocProvider(
//       create: (context) =>
//           getIt<ProfileCubit>()..getGkProfile(gatekeeperId: gkId),
//       child: BlocBuilder<ProfileCubit, ProfileStates>(
//         builder: (context, state) {
//           final isLoading = state.maybeWhen(
//             loading: () => true,
//             getGatekeeperLoading: () => true,
//             orElse: () => false,
//           );

//           final profile = state.maybeWhen(
//             getGatekeeperSuccess: (profile) => profile,
//             orElse: () => null,
//           );

//           return ModalProgressHUD(
//             inAsyncCall: isLoading,
//             progressIndicator: const CustomLoadingIndicator(),
//             color: Colors.black,
//             opacity: 0.5,
//             child: Scaffold(
//               backgroundColor: AppColor.whiteColor,
//               key: ValueKey(currentLocale.languageCode),
//               body: state.whenOrNull(
//                     getGatekeeperSuccess: (profile) => Column(
//                       children: [
//                         ProfileHeader(
//                           firstName: profile.firstName,
//                           lastName: profile.lastName,
//                         ),
//                         UserCart(profileModel: profile),
//                       ],
//                     ),
//                     getGatekeeperError: (message) => Center(
//                       child: Text(message),
//                     ),
//                     getGatekeeperLoading: () => const Center(
//                       child: CustomLoadingIndicator(),
//                     ),
//                   ) ??
//                   const Center(
//                     child: CustomLoadingIndicator(),
//                   ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
