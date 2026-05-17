import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/event_detail_card.dart';
import '../../../../core/widgets/title_text.dart';
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
                  context.pop(); // ✅ pop completes first
                  // ✅ toast shows after pop, no collision
                  Future.microtask(() {
                    if (context.mounted) {
                      context.showSuccessToast("event_reserved_text".tr());
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
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(containerRadius),
                topRight: Radius.circular(containerRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            padding: EdgeInsets.all(edge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heightEdge * 0.5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.all(edge * 0.6),
                        decoration: BoxDecoration(
                          color: AppColor.gray50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: AppColor.gray900),
                      ),
                    ),
                    SizedBox(width: edge * 0.6),
                    TitleText(
                      text: "reserve_event".tr(),
                      color: AppColor.primaryColor,
                      fontSize: 20,
                      align: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: edge * 0.5),
                NormalText(
                  text: "reserve_event_hint".tr(),
                  fontSize: 18,
                  color: AppColor.gray600,
                ),
                SizedBox(height: edge * 0.8),
                EventDetailCard(event: event),
                SizedBox(height: heightEdge),
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
                    customGradient: AppColor.greenGradient,
                    textColor: Colors.white,
                    gradient: true,
                    fontSize: 18,
                    loading: isLoading,
                  );
                })
              ],
            ),
          ),
        ));
  }
}
