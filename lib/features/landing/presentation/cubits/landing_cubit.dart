import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helpers/app_utilities.dart';
import '../../../client_events/logic/client_events_cubit.dart';
import '../../../client_statistics/logic/client_statistics_cubit.dart';
import '../../../event_calender/logic/event_calender_cubit.dart';
import '../../../events_scan_history/logic/gatekeeper_events_cubit.dart';
import '../../../gatekeeper_calendar/presentation/calendar_view.dart';
import '../../../gatekeeper_home/views/gatekeeper_home_screen.dart';
import '../../../new_client_events/ui/new_client_events_screen.dart';
import '../../../new_client_statistics/ui/new_client_statistics_screen.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../profile/data/repo/profile_repo.dart';
import '../../../profile/logic/profile_cubit.dart';
import '../../../profile/presentation/profile_view.dart';
import '../widgets/keep_alive_wrapper.dart';
import 'landing_states.dart';

class LandingCubit extends Cubit<LandingStates> {
  final ProfileRepo _profileRepo;

  LandingCubit(this._profileRepo, {int initialIndex = 0})
      : super(const LandingStates.initial()) {
    currentIndex = initialIndex;
    pageController = PageController(initialPage: initialIndex);
    _initializeScreens();
    _setupNotificationsInBackground();
  }

  late final PageController pageController;
  int currentIndex = 0;
  List<Widget> screens = [];

  bool get isOrganizer => AppUtilities().loginData.roleName != "Client";

  // ── Screens ──────────────────────────────────────────────────────────────

  void _initializeScreens() {
    if (isOrganizer) {
      screens = [
        BlocProvider(
          create: (_) => getIt<GatekeeperEventsCubit>()..getGatekeeperEvents(),
          child: const GatekeeperHomeScreen(),
        ),
        BlocProvider(
          create: (_) => getIt<EventCalenderCubit>(),
          child: const CalendarView(),
        ),
        KeepAliveWrapper(
          child: BlocProvider(
            create: (_) => getIt<ProfileCubit>(),
            child: const ProfileView(),
          ),
        ),
      ];
    } else {
      screens = [
        BlocProvider(
          create: (_) => getIt<ClientEventsCubit>()..getClientEvents(),
          child: const NewClientEventsScreen(),
        ),
        BlocProvider(
          create: (_) => getIt<ClientStatisticsCubit>()..getClientEvents(),
          child: const NewClientStatisticsScreen(),
        ),
        KeepAliveWrapper(
          child: BlocProvider(
            create: (_) => getIt<ProfileCubit>(),
            child: const ProfileView(),
          ),
        ),
      ];
    }
  }

  // ── Navigation ───────────────────────────────────────────────────────────

  void changeIndex(int index) {
    currentIndex = index;
    emit(LandingStates.loaded(currentIndex: currentIndex));

    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      emit(LandingStates.loaded(currentIndex: currentIndex));
    }
  }

  // ── Notifications ────────────────────────────────────────────────────────

  Future<void> _setupNotificationsInBackground() async {
    if (AppUtilities().loginData.roleName == "Client") return;
    try {
      final response = await _profileRepo.getProfile();
      response.whenOrNull(
        success: (profile) => _subscribeToNotificationTopic(profile),
      );
    } catch (e) {
      debugPrint('Notification setup failed: $e');
    }
  }

  Future<void> _subscribeToNotificationTopic(ProfileModel profile) async {
    final newTopic = profile.cityId.toString();
    final currentTopic = AppUtilities().subscriptionTopic;
    final msg = FirebaseMessaging.instance;

    try {
      if (currentTopic == newTopic && currentTopic.isNotEmpty) {
        debugPrint('Already subscribed to topic: $newTopic ✅');
        return;
      }

      if (currentTopic.isNotEmpty) {
        await msg.unsubscribeFromTopic(currentTopic);
        debugPrint('Unsubscribed from previous topic: $currentTopic ❌');
      }

      await msg.subscribeToTopic(newTopic);
      AppUtilities().subscriptionTopic = newTopic;
      debugPrint(currentTopic.isEmpty
          ? 'Subscribed to topic (first time): $newTopic ✅'
          : 'Subscribed to new topic: $newTopic ✅');
    } catch (e) {
      debugPrint('Topic subscription failed: $e ❌');
    }
  }

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}