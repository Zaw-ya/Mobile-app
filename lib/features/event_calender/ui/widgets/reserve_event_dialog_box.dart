import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/calender_events.dart';
import '../../logic/event_calender_cubit.dart';
import '../../logic/event_calender_states.dart';

class ReservationDialogBox extends StatelessWidget {
  final CalenderEventsResponse event;

  const ReservationDialogBox({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCalenderCubit, EventCalenderStates>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, current) {
        return AlertDialog(
          backgroundColor: AppColor.primaryLight,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              const Icon(
                Icons.event_available,
                color: AppColor.primaryDark,
                size: 56,
              ),
              const SizedBox(height: 12),
              Text(
                '${"reserve".tr()}\n${event.eventTitle ?? ""}',
                style: AppTextStyles.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            'confirm_reserve'.tr(),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColor.gray700),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GoButton(
                    fun: () {
                      context
                          .read<EventCalenderCubit>()
                          .reserveEvent(event.id.toString());
                      context.pop();
                    },
                    titleKey: 'yes'.tr(),
                    textColor: AppColor.primaryLight,
                    btColor: AppColor.primaryDark,
                    w: 110,
                    loaderColor: AppColor.primaryLight,
                    loading: current is ReservationLoading,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GoButton(
                    fun: () => context.pop(),
                    titleKey: 'no'.tr(),
                    textColor: AppColor.primaryLight,
                    btColor: AppColor.semanticError,
                    w: 110,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
