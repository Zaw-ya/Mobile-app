import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/drag_handle.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/event_detail_card.dart';
import '../../../event_calender/data/models/calender_events.dart';
import '../../../event_calender/logic/event_calender_cubit.dart';
import '../../../event_calender/logic/event_calender_states.dart';

class ReserveEventBottomSheet extends StatelessWidget {
  final CalenderEventsResponse event;

  const ReserveEventBottomSheet({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventCalenderCubit, EventCalenderStates>(
      listener: (context, state) {
        state.whenOrNull(
          reservationSuccess: (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.pop();
                Future.microtask(() {
                  if (context.mounted) {
                    context.showSuccessToast('event_reserved_text'.tr());
                  }
                });
              }
            });
          },
          errorReservation: (message) {
            context.showErrorToast(message);
          },
        );
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        snap: true,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColor.primaryLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(containerRadius),
              topRight: Radius.circular(containerRadius),
            ),
          ),
          padding: EdgeInsets.all(edge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DragHandle(),
              SizedBox(height: edge * 0.6),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: EdgeInsets.all(edge * 0.6),
                      decoration: const BoxDecoration(
                        color: AppColor.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: AppColor.gray700, size: 18),
                    ),
                  ),
                  SizedBox(width: edge * 0.6),
                  Text('reserve_event'.tr(),
                      style: AppTextStyles.headlineSmall),
                ],
              ),
              SizedBox(height: edge * 0.5),
              Text(
                'reserve_event_hint'.tr(),
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColor.gray600),
              ),
              SizedBox(height: edge * 0.8),
              EventDetailCard(event: event),
              SizedBox(height: edge),
              BlocBuilder<EventCalenderCubit, EventCalenderStates>(
                builder: (context, state) {
                  final isLoading = state is ReservationLoading;
                  return GoButton(
                    fun: isLoading
                        ? () {}
                        : () {
                            if (event.id != null) {
                              context
                                  .read<EventCalenderCubit>()
                                  .reserveEvent(event.id.toString());
                              context
                                  .read<EventCalenderCubit>()
                                  .calenderEventsResponse = event;
                            }
                          },
                    titleKey: 'reserve_now'.tr(),
                    btColor: AppColor.primaryDark,
                    textColor: AppColor.primaryLight,
                    fontSize: 18,
                    loading: isLoading,
                    loaderColor: AppColor.primaryLight,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
