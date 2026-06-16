import 'package:app/core/theming/colors.dart';
import 'package:app/features/event_calender/ui/widgets/calender_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/extensions.dart';
import '../../../core/widgets/public_appbar.dart';
import '../logic/event_calender_cubit.dart';
import '../logic/event_calender_states.dart';

class EventCalenderScreen extends StatelessWidget {
  const EventCalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      appBar: publicAppBar(context, 'events_calendar'.tr()),
      body: BlocBuilder<EventCalenderCubit, EventCalenderStates>(
        bloc: context.read<EventCalenderCubit>()..getEventsCalendar(),
        builder: (context, state) {
          return state.when(
            initial: () => _initialCalendar(context),
            loading: () => _initialCalendar(context),
            errorReservation: (error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showErrorToast(error);
              });
              return _initialCalendar(context);
            },
            emptyInput: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showErrorToast('no_available_events'.tr());
              });
              return _initialCalendar(context);
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
            reservationLoading: () => _initialCalendar(context),
            reservationSuccess: (_) => _initialCalendar(context),
            error: (error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (error.contains('Failed host lookup')) {
                  context.showErrorToast('no_internet'.tr());
                } else {
                  context.showErrorToast(error);
                }
              });
              return _initialCalendar(context);
            },
          );
        },
      ),
    );
  }

  Widget _initialCalendar(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EventCalenderCubit>(),
      child: CalenderView(
        events: [],
        selectedDay: DateTime.now(),
        focusedDay: DateTime.now(),
        selectedEvents: [],
      ),
    );
  }
}
