import 'package:app/core/di/dependency_injection.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/services/firebase_messaging_handler.dart';
import 'package:app/features/notifications/logic/notifications_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/dimensions/dimensions_constants.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/services/navigation_service.dart';
import 'core/widgets/network_aware_builder.dart';

class MyInvite extends StatefulWidget {
  const MyInvite({super.key});

  @override
  State<MyInvite> createState() => _MyInviteState();
}

class _MyInviteState extends State<MyInvite> {
 @override
  void initState() {
    super.initState();
    // Here navigator is ready 
    FirebaseMessagingHandler().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(width, height),
      minTextAdapt: true,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          final NavigatorState navigator =
              NavigationService.navigatorKey.currentState!;
          if (navigator.canPop()) {
            navigator.pop(result);
          } else {
            debugPrint("Cannot pop - no pages left in the navigation stack.");
            context.showErrorToast("Cannot go back further.");
          }
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NotificationsCubit>(
              // To be available for all screens
              create: (context) =>
                  getIt<NotificationsCubit>()..loadNotifications(),
            ),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            debugShowCheckedModeBanner: false,
            title: 'My Invite',
            onGenerateRoute: AppRouter().generateRoute,
            initialRoute: Routes.splashScreen,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            navigatorKey: NavigationService.navigatorKey,
            builder: (context, widget) {
              return NetworkAwareBuilder(myChild: widget!);
            },
          ),
        ),
      ),
    );
  }
}
