import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/public_appbar.dart';
import '../../../../../core/widgets/subtitle_text.dart';
import '../../../data/models/client_messages_statistics_response.dart';
import '../../../logic/client_statistics_cubit.dart';
import '../../../logic/client_statistics_states.dart';
import 'messages_statistics_item.dart';

class ClientMessagesStatisticsScreen extends StatelessWidget {
  final String eventId;

  const ClientMessagesStatisticsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: publicAppBar(context, "all_message_statistics".tr()),
      body: BlocBuilder<ClientStatisticsCubit, ClientStatisticsStates>(
        buildWhen: (previous, current) => current != previous,
        bloc: context.read<ClientStatisticsCubit>()..getClientMessageStatistics(eventId),
        builder: (context, current) {
          return current.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () => const Center(child: CupertinoActivityIndicator(color: Colors.white)),
            successFetchData: (success) {
              final ClientMessagesStatisticsResponse events = success;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        MessagesStatisticsItem(
                          title: 'confirmation_messages'.tr(),
                          messagesStatisticsDetails: events.confirmationMessages!,
                        ),
                        const Divider(
                          height: 46,
                          color: bgColorOverlay,
                        ),
                        MessagesStatisticsItem(
                          title: 'card_messages'.tr(),
                          messagesStatisticsDetails: events.cardMessages!,
                        ),
                        const Divider(
                          height: 46,
                          color: bgColorOverlay,
                        ),
                        MessagesStatisticsItem(
                          title: 'event_location_messages'.tr(),
                          messagesStatisticsDetails: events.eventLocationMessages!,
                        ),
                        const Divider(
                          height: 46,
                          color: bgColorOverlay,
                        ),
                        MessagesStatisticsItem(
                          title: 'reminder_messages'.tr(),
                          messagesStatisticsDetails: events.reminderMessages!,
                        ),
                        const Divider(
                          height: 46,
                          color: bgColorOverlay,
                        ),
                        MessagesStatisticsItem(
                          title: 'congratulation_messages'.tr(),
                          messagesStatisticsDetails: events.congratulationMessages!,
                        ),
                        const Divider(
                          height: 46,
                          color: bgColorOverlay,
                        ),
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

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: SubTitleText(
        text: message,
        color: Colors.white,
        align: TextAlign.center,
      ),
    );
  }
}
