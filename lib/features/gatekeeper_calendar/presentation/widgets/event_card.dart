import 'package:app/core/theming/typography_theme.dart';
import 'package:app/features/gatekeeper_calendar/presentation/widgets/reserve_event_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/date_time_helper.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../generated/assets.dart';
import '../../../event_calender/data/models/calender_events.dart';
import '../../../event_calender/logic/event_calender_cubit.dart';

class EventCard extends StatelessWidget {
  final CalenderEventsResponse event;

  const EventCard({super.key, required this.event});

  Future<void> _viewMap(BuildContext context, String? location) async {
    if (location == null) {
      context.showErrorToast('location_not_available'.tr());
      return;
    }
    try {
      await launchUrl(Uri.parse(location), mode: LaunchMode.platformDefault);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final dateLabel =
        DateTimeHelper.formatDateLabel(event.eventFrom, isArabic: isArabic);

    return GestureDetector(
      onTap: () {
        final cubit = context.read<EventCalenderCubit>();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: ReserveEventBottomSheet(event: event),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: edge * 0.8, vertical: edge * 0.7),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(radiusInput),
          border: Border.all(color: AppColor.gray100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.eventTitle ?? '',
              style: context.typography.headlineSmall,
            ),
            SizedBox(height: edge * 0.2),
            Text(
              dateLabel,
              style: context.typography.bodySmall
                  .copyWith(color: AppColor.gray600),
            ),
            if (event.eventVenue != null &&
                event.eventVenue!.isNotEmpty) ...[
              SizedBox(height: edge * 0.5),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _viewMap(context, event.eventLocation),
                    child: Container(
                      padding: EdgeInsets.all(edge * 0.6),
                      decoration: const BoxDecoration(
                        color: AppColor.gray50,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        Assets.imagesLocation,
                        colorFilter: const ColorFilter.mode(
                            AppColor.primaryDark, BlendMode.srcIn),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: edge * 0.4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (event.parentTitle != null &&
                            event.parentTitle!.isNotEmpty)
                          Text(
                            event.parentTitle!,
                            style: context.typography.titleSmall,
                          ),
                        Text(
                          event.eventVenue!,
                          style: context.typography.bodySmall
                              .copyWith(color: AppColor.gray500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
