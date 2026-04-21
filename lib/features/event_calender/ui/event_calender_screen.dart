import 'package:app/core/helpers/extensions.dart';
import 'package:app/features/event_calender/ui/widgets/calender_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/public_appbar.dart';
import '../logic/event_calender_cubit.dart';
import '../logic/event_calender_states.dart';

/// A screen widget that displays a calendar with events
/// This widget is stateless as it uses BLoC for state management
class EventCalenderScreen extends StatelessWidget {
  const EventCalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(context, "events_calendar".tr()),
      // Use BlocBuilder to rebuild UI when state changes
      body: BlocBuilder<EventCalenderCubit, EventCalenderStates>(
        // Initialize the calendar by fetching events when screen loads
        bloc: context.read<EventCalenderCubit>()..getEventsCalendar(),
        builder: (context, state) {
          // Handle different states using when pattern matching
          return state.when(
            initial: () => initialCalender(context),
            loading: () => initialCalender(context),
            errorReservation: (error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showErrorToast(error);
                //context.pop();
              });
              return initialCalender(context);
            },
            emptyInput: () {
              // Show error toast after frame is rendered and get events to reserve it
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showErrorToast("no_available_events".tr());
              });
              return initialCalender(context);
            },
            success: (events, selectedDay, focusedDay, selectedEvents) {
              return BlocProvider.value(
                value: context.read<EventCalenderCubit>(),
                child: CalenderView(
                  events: events,
                  selectedDay: selectedDay,
                  focusedDay: focusedDay,
                  selectedEvents: selectedEvents,
                ),
              );
            },
            reservationLoading: () => initialCalender(context),
            reservationSuccess: (message) {
              return initialCalender(context);
            },
            error: (error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (error.contains("Failed host lookup")) {
                  context.showErrorToast("no_internet".tr());
                } else {
                  context.showErrorToast(error);
                }
              });
              return initialCalender(context);
            },
          );
        },
      ),
    );
  }

  /// Creates initial calendar view with empty events
  Widget initialCalender(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EventCalenderCubit>(),
      child: CalenderView(
        events: [], // Empty events list for initial/loading states
        selectedDay: DateTime.now(),
        focusedDay: DateTime.now(),
        selectedEvents: [],
      ),
    );
  }
}
