import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/theming/app_typography.dart';
import '../../../../../core/theming/colors.dart';
import '../../../client_statistics/data/models/guest_type_list.dart';
import '../../../client_statistics/data/models/sent_cards_services_response.dart';
import 'donut_chart.dart';
import 'stat_card.dart';

const _c0 = AppColor.primaryDark;
const _c1 = Color(0xCC262938);
const _c2 = Color(0x99262938);
const _c3 = Color(0x66262938);
const _c4 = Color(0x4D262938);

class SentCardsStatisticsTab extends StatelessWidget {
  final SentCardsServicesResponse data;
  final String eventId;

  const SentCardsStatisticsTab({
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
    final delivered = data.deliveredGuestsNumber ?? 0;
    final sent = data.sentGuestNumber ?? 0;
    final failed = data.failedGuestsNumber ?? 0;
    final notSent = data.notSentGuestsNumber ?? 0;
    final attended = data.attendedGuestsNumber ?? 0;

    final segments = [
      DonutSegment(value: delivered.toDouble(), color: _c0),
      DonutSegment(value: sent.toDouble(), color: _c1),
      DonutSegment(value: failed.toDouble(), color: _c2),
      DonutSegment(value: notSent.toDouble(), color: _c3),
      DonutSegment(value: attended.toDouble(), color: _c4),
    ];

    final cards = [
      StatCardData(
        title: 'total_guests_received_cards'.tr(),
        value: delivered,
        color: _c0,
        onTap: () => _navigate(context, GuestListType.guestsReceivedCards, delivered),
      ),
      StatCardData(
        title: 'total_guests_cards_sent'.tr(),
        value: sent,
        color: _c1,
        onTap: () => _navigate(context, GuestListType.guestsCardsSent, sent),
      ),
      StatCardData(
        title: 'total_guests_cards_failed'.tr(),
        value: failed,
        color: _c2,
        onTap: () => _navigate(context, GuestListType.guestsCardsFailed, failed),
      ),
      StatCardData(
        title: 'total_guests_cards_not_sent'.tr(),
        value: notSent,
        color: _c3,
        onTap: () => _navigate(context, GuestListType.guestsCardsNotSent, notSent),
      ),
      StatCardData(
        title: 'total_guests_attended'.tr(),
        value: attended,
        color: _c4,
        onTap: () => _navigate(context, GuestListType.failedGuests, attended),
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
