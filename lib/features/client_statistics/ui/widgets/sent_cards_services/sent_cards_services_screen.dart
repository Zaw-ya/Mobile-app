import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/loader.dart';
import '../../../../../core/widgets/public_appbar.dart';
import '../../../data/models/guest_type_list.dart';
import '../../../data/models/sent_cards_services_response.dart';
import '../../../logic/client_statistics_cubit.dart';
import '../../../logic/client_statistics_states.dart';
import 'sent_cards_services_chart.dart';

class SentCardsServicesScreen extends StatelessWidget {
  final String eventId;

  const SentCardsServicesScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      appBar: publicAppBar(context, 'card_sending_service'.tr()),
      body: BlocBuilder<ClientStatisticsCubit, ClientStatisticsStates>(
        buildWhen: (previous, current) => current != previous,
        bloc: context.read<ClientStatisticsCubit>()
          ..getSentCardsServices(eventId),
        builder: (context, current) {
          return current.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () =>
                _buildCenteredMessage('no_available_events'.tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () =>
                Center(child: Loader(color: AppColor.primaryDark)),
            successFetchData: (success) {
              final SentCardsServicesResponse events = success;
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: edge * 0.5),
                      children: [
                        _buildRow(context, 'type'.tr(), 'number'.tr(),
                            isHeader: false),
                        _buildRow(context, 'total_guests'.tr(),
                            events.totalGuestsNumber.toString(),
                            type: GuestListType.allGuests,
                            eventId: eventId),
                        _buildRow(
                            context,
                            'total_guests_received_cards'.tr(),
                            events.deliveredGuestsNumber.toString(),
                            type: GuestListType.guestsReceivedCards,
                            eventId: eventId),
                        _buildRow(context, 'total_guests_cards_failed'.tr(),
                            events.failedGuestsNumber.toString(),
                            type: GuestListType.guestsCardsFailed,
                            eventId: eventId),
                        _buildRow(
                            context,
                            'total_guests_cards_not_sent'.tr(),
                            events.notSentGuestsNumber.toString(),
                            type: GuestListType.guestsCardsNotSent,
                            eventId: eventId),
                        _buildRow(context, 'total_guests_attended'.tr(),
                            events.attendedGuestsNumber.toString(),
                            type: GuestListType.failedGuests,
                            eventId: eventId),
                        SentCardsServicesChart(details: events),
                      ],
                    ),
                  ),
                ],
              );
            },
            success: (_, __) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String title,
    String number, {
    bool isHeader = true,
    GuestListType? type,
    String eventId = '',
  }) {
    final int parsedNumber = int.tryParse(number) ?? 0;
    return GestureDetector(
      onTap: isHeader
          ? () {
              if (parsedNumber > 0) {
                context.pushNamed(
                  Routes.clientMessageStatus,
                  arguments: {
                    'eventId': eventId,
                    'type': type,
                    'title': guestListTypeToString(type!),
                  },
                );
              } else {
                context.showSuccessToast('no_available_details'.tr());
              }
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 0.8),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: edge * 0.5),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.gray100),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColor.gray700),
              ),
            ),
            Text(
              number,
              style: AppTextStyles.numericMedium
                  .copyWith(color: AppColor.primaryDark),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: isHeader ? AppColor.primaryDark : Colors.transparent,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColor.gray500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
