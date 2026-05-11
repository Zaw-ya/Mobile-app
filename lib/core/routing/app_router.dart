import 'package:app/core/widgets/success_view.dart';
import 'package:app/features/qr_code_scanner/logic/qr_code_scanner_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/client_events/data/models/client_event_response.dart';
import '../../features/client_events/data/models/client_messages_status_response.dart';
import '../../features/client_events/logic/client_events_cubit.dart';
import '../../features/client_events/ui/client_events_screen.dart';
import '../../features/client_events/ui/widgets/client_guest_details_screen.dart';
import '../../features/client_events/ui/widgets/client_messages_status_screen.dart';
import '../../features/client_statistics/data/models/guest_type_list.dart';
import '../../features/client_statistics/logic/client_statistics_cubit.dart';
import '../../features/client_statistics/ui/client_statistics_screen.dart';
import '../../features/client_statistics/ui/widgets/client_confirmation_services/client_confirmation_services_screen.dart';
import '../../features/client_statistics/ui/widgets/client_confirmation_services/client_message_status.dart';
import '../../features/client_statistics/ui/widgets/client_messages/client_messages_statistics_screen.dart';
import '../../features/client_statistics/ui/widgets/sent_cards_services/sent_cards_services_screen.dart';
import '../../features/event_calender/ui/event_calender_screen.dart';
import '../../features/notifications/ui/notifications_screen.dart';
import '../../features/events_scan_history/data/models/gatekeeper_events_response.dart';
import '../../features/events_scan_history/logic/gatekeeper_events_cubit.dart';
import '../../features/events_scan_history/ui/my_events_screen.dart';
import '../../features/events_scan_history/ui/scan_history_screen.dart';
import '../../features/events_scan_history/ui/widgets/event_history_details_screen.dart';
import '../../features/gatekeeper_scan_history/views/gatekeeper_scan_history_screen.dart';
import '../../features/home/ui/widgets/event_instructions_screen.dart';
import '../../features/landing/presentation/cubits/landing_cubit.dart';
import '../../features/landing/presentation/landing_view.dart';
import '../../features/location/logic/location_cubit.dart';
import '../../features/login/logic/login_cubit.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/new_client_events/ui/widgets/client_event_detail_screen.dart';
import '../../features/new_client_statistics/ui/client_statistics_detail_screen.dart';
import '../../features/qr_code_scanner/ui/qr_code_scanner_screen.dart';
import '../../features/register/logic/register_cubit.dart';
import '../../features/register/ui/register_screen.dart';
import '../../features/splash/ui/on_boarding_screen.dart';
import '../../features/splash/ui/splash_screen.dart';
import '../di/dependency_injection.dart';
import 'routes.dart';
import '../../features/notifications/logic/notifications_cubit.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return _buildRoute(const SplashScreen());
      case Routes.successScreen:
        return _buildRoute(const SuccessView());
      case Routes.loginScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      case Routes.registerScreen:
        return _buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<
                    RegisterCubit>(), // RegisterCubit for handling registration
              ),
              BlocProvider(
                create: (_) => getIt<
                    LocationCubit>(), // LocationCubit for handling location
              ),
            ],
            child: const RegisterScreen(),
          ),
        );

      case Routes.onBoardingScreen:
        return _buildRoute(
          const OnBoardingScreen(),
        );

      case Routes.eventInstructionsScreen:
        return _buildRoute(
          const EventInstructionsScreen(),
        );
      case Routes.qrCodeScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<QrCodeScannerCubit>(),
            child: const QrCodeScannerScreen(),
          ),
        );
      case Routes.eventsHistory:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<GatekeeperEventsCubit>(),
            child: const ScanHistoryScreen(),
          ),
        );
      case Routes.gatekeeperScanHistoryScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<GatekeeperEventsCubit>(),
            child: const GatekeeperScanHistoryScreen(),
          ),
        );
      case Routes.eventDetailScreen:
        final EventsList event;
        bool showBottomBar = true;

        if (arguments is Map) {
          event = arguments['event'] as EventsList;
          showBottomBar = arguments['showBottomBar'] as bool? ?? true;
        } else {
          event = arguments as EventsList;
        }

        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<GatekeeperEventsCubit>(),
            child: EventHistoryDetailsScreen(
              event: event,
              showBottomBar: showBottomBar,
            ),
          ),
        );
      case Routes.myEventsScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<GatekeeperEventsCubit>(),
            child: const MyEventsScreen(),
          ),
        );

      case Routes.eventsCalendar:
        return _buildRoute(
          const EventCalenderScreen(),
        );
      case Routes.notifications:
        return _buildRoute(BlocProvider.value(
          value: getIt<NotificationsCubit>(),
          child: const NotificationsScreen(),
        )
            // BlocProvider<NotificationsCubit>(
            //   create: (_) => getIt<NotificationsCubit>(),
            //   child: const NotificationsScreen(),
            // ),
            );

      case Routes.clientEvents:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientEventsCubit>(),
            child: const ClientEventsScreen(),
          ),
        );
      case Routes.clientEventsDetailsScreen:
        final event = arguments as ClientEventDetails;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientEventsCubit>(),
            child: ClientEventDetailScreen(event: event),
          ),
        );

      case Routes.clientMessagesStatusScreen:
        final eventId = arguments as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientEventsCubit>(),
            child: ClientMessagesStatusScreen(eventId: eventId),
          ),
        );

      case Routes.clientGuestDetailsScreen:
        final clientMessagesStatusDetails =
            arguments as ClientMessagesStatusDetails;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientEventsCubit>(),
            child: ClientGuestDetailsScreen(
                clientMessagesStatusDetails: clientMessagesStatusDetails),
          ),
        );

      case Routes.clientStatisticsScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child: const ClientStatisticsScreen(),
          ),
        );

      case Routes.clientMessagesStatisticsScreen:
        final eventId = arguments as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child: ClientMessagesStatisticsScreen(eventId: eventId),
          ),
        );
      case Routes.clientConfirmationServicesScreen:
        final eventId = arguments as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child: ClientConfirmationServicesScreen(eventId: eventId),
          ),
        );
      case Routes.clientMessageStatus:
        final args = arguments as Map<String, dynamic>;
        final eventId = args['eventId'] as String;
        final type = args['type'] as GuestListType;
        final title = args['title'] as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child:
                ClientMessageStatus(eventId: eventId, type: type, title: title),
          ),
        );
      case Routes.sentCardsServicesScreen:
        final eventId = arguments as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child: SentCardsServicesScreen(eventId: eventId),
          ),
        );

      case Routes.landingView:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<LandingCubit>(),
            child: const LandingView(),
          ),
        );

      case Routes.clientStatisticsDetailScreen:
        final args = arguments as Map<String, dynamic>;

        final eventId = args['eventId'] as int;
        final eventTitle = args['eventTitle'] as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child: ClientStatisticsDetailScreen(
              eventId: eventId,
              eventTitle: eventTitle,
            ),
          ),
        );

      default:
        return _buildRoute(const SplashScreen());

      //   _buildRoute(
      //   Scaffold(
      //     body: Center(
      //       child: Text('No route defined for ${settings.name}'),
      //     ),
      //   ),
      // );
    }
  }

  Route _buildRoute(Widget page, {bool useCupertino = false}) {
    if (useCupertino || TargetPlatform.iOS == defaultTargetPlatform) {
      return CupertinoPageRoute(builder: (_) => page);
    } else {
      return MaterialPageRoute(builder: (_) => page);
    }
  }
}
