import 'package:app/core/helpers/extensions.dart';
import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/widgets/loader.dart';
import 'sent_cards_services_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/normal_text.dart';
import '../../../../../core/widgets/public_appbar.dart';
import '../../../../../core/widgets/title_text.dart';
import '../../../data/models/guest_type_list.dart';
import '../../../data/models/sent_cards_services_response.dart';
import '../../../logic/client_statistics_cubit.dart';
import '../../../logic/client_statistics_states.dart';

class SentCardsServicesScreen extends StatelessWidget {
  final String eventId;

  const SentCardsServicesScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: publicAppBar(context, "card_sending_service".tr()),
      body: BlocBuilder<ClientStatisticsCubit, ClientStatisticsStates>(
        buildWhen: (previous, current) => current != previous,
        bloc: context.read<ClientStatisticsCubit>()
          ..getSentCardsServices(eventId),
        builder: (context, current) {
          return current.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () => Center(child: Loader(color: whiteTextColor)),
            successFetchData: (success) {
              final SentCardsServicesResponse events = success;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _buildItemRow(context, "type".tr(), "number".tr(),
                            isHeader: false),
                        _buildItemRow(context, "total_guests".tr(),
                            events.totalGuestsNumber.toString(),
                            type: GuestListType.allGuests, eventId: eventId),
                        _buildItemRow(
                            context,
                            "total_guests_received_cards".tr(),
                            events.deliveredGuestsNumber.toString(),
                            type: GuestListType.guestsReceivedCards,
                            eventId: eventId),
                        _buildItemRow(context, "total_guests_cards_failed".tr(),
                            events.failedGuestsNumber.toString(),
                            type: GuestListType.guestsCardsFailed,
                            eventId: eventId),
                        _buildItemRow(
                            context,
                            "total_guests_cards_not_sent".tr(),
                            events.notSentGuestsNumber.toString(),
                            type: GuestListType.guestsCardsNotSent,
                            eventId: eventId),
                        _buildItemRow(context, "total_guests_attended".tr(),
                            events.attendedGuestsNumber.toString(),
                            type: GuestListType.failedGuests, eventId: eventId),
                        SentCardsServicesChart(details: events),
                      ],
                    ),
                  ),
                ],
              );
            },
            success: (success, loading) => Container(),
          );
        },
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, String title, String number,
      {bool isHeader = true, GuestListType? type, String eventId = ""}) {
    // Ensure the number is parsed safely
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
        padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: edge * 0.5),
        decoration: BoxDecoration(
            color: navBarBackground.withAlpha(128),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            _buildRowItem(title, flex: 3),
            _buildRowItem(number),
            if (isHeader)
              Icon(
                Icons.chevron_right,
                color: whiteTextColor,
              )
            else
              Icon(
                Icons.chevron_right,
                color: Colors.transparent,
              )
          ],
        ),
      ),
    );
  }

  Expanded _buildRowItem(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: NormalText(
        text: text,
        color: whiteTextColor,
        align: TextAlign.start,
      ),
    );
  }

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: TitleText(
        text: message,
        color: Colors.white,
        align: TextAlign.center,
      ),
    );
  }
}
