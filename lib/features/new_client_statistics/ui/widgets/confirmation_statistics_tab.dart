import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/theming/app_typography.dart';
import '../../../../../core/theming/colors.dart';
import '../../../client_statistics/data/models/client_confirmation_service_response.dart';
import '../../../client_statistics/data/models/guest_type_list.dart';
import 'donut_chart.dart';
import 'stat_card.dart';

const _c0 = AppColor.primaryDark;
const _c1 = Color(0xCC262938);
const _c2 = Color(0x99262938);
const _c3 = Color(0x66262938);
const _c4 = Color(0x4D262938);
const _c5 = Color(0x40262938); // 25% — minimum readable on cream/white

class ConfirmationStatisticsTab extends StatelessWidget {
  final ClientConfirmationServiceResponse data;
  final String eventId;

  const ConfirmationStatisticsTab({
    super.key,
    required this.data,
    required this.eventId,
  });

  int get _total => data.totalGuestsNumber ?? 0;

  void _navigate(BuildContext context, GuestListType type, int count) {
    if (count > 0) {
      context.pushNamed(Routes.clientMessageStatus, arguments: {
        'eventId': eventId,
        'type': type,
        'title': guestListTypeToString(type),
      });
    } else {
      context.showSuccessToast('no_available_details'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final accepted = data.acceptedGuestsNumber ?? 0;
    final declined = data.declienedGuestsNumber ?? 0;
    final noAnswer = data.noAnswerGuestsNumber ?? 0;
    final failed = data.failedGuestsNumber ?? 0;
    final notSent = data.notSentGuestsNumber ?? 0;
    final attended = data.attendedGuestsNumber ?? 0;

    final segments = [
      DonutSegment(value: accepted.toDouble(), color: _c0),
      DonutSegment(value: declined.toDouble(), color: _c1),
      DonutSegment(value: noAnswer.toDouble(), color: _c2),
      DonutSegment(value: failed.toDouble(), color: _c3),
      DonutSegment(value: notSent.toDouble(), color: _c4),
      DonutSegment(value: attended.toDouble(), color: _c5),
    ];

    final cards = [
      StatCardData(
        title: 'total_accepted_guests'.tr(),
        value: accepted,
        color: _c0,
        onTap: () => _navigate(context, GuestListType.acceptedGuests, accepted),
      ),
      StatCardData(
        title: 'total_declined_guests'.tr(),
        value: declined,
        color: _c1,
        onTap: () => _navigate(context, GuestListType.declinedGuests, declined),
      ),
      StatCardData(
        title: 'total_not_answered_guests'.tr(),
        value: noAnswer,
        color: _c2,
        onTap: () => _navigate(context, GuestListType.notAnsweredGuests, noAnswer),
      ),
      StatCardData(
        title: 'total_failed_guests'.tr(),
        value: failed,
        color: _c3,
        onTap: () => _navigate(context, GuestListType.failedGuests, failed),
      ),
      StatCardData(
        title: 'total_not_sent_guests'.tr(),
        value: notSent,
        color: _c4,
        onTap: () => _navigate(context, GuestListType.notSentGuests, notSent),
      ),
      StatCardData(
        title: 'total_attended_guests'.tr(),
        value: attended,
        color: _c5,
        onTap: () => _navigate(context, GuestListType.guestsReadCards, attended),
      ),
    ];

    return ListView(
      padding: EdgeInsets.only(bottom: edge * 2),
      children: [
        SizedBox(height: edge * 0.5),
        Center(
          child: DonutChart(
            segments: segments,
            centerTitle: 'all_guests'.tr(),
            centerValue: _total.toString(),
            centerSubtitle: 'guest'.tr(),
          ),
        ),
        SizedBox(height: edge),
        Text(
          'statistics_details'.tr(),
          style: AppTextStyles.titleSmall.copyWith(color: AppColor.gray700),
        ),
        SizedBox(height: edge * 0.6),
        StatCardsGrid(items: cards, total: _total),
      ],
    );
  }
}
