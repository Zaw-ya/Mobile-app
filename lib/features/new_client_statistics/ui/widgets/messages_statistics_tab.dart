import 'package:app/features/new_client_statistics/data/models/section_data.dart';
import 'package:app/features/new_client_statistics/ui/widgets/message_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/theming/colors.dart';
import '../../../client_statistics/data/models/client_messages_statistics_response.dart';

class MessagesStatisticsTab extends StatelessWidget {
  final ClientMessagesStatisticsResponse data;

  const MessagesStatisticsTab({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      SectionData(
        title: 'confirmation_messages'.tr(),
        details: data.confirmationMessages,
      ),
      SectionData(
        title: 'card_messages'.tr(),
        details: data.cardMessages,
      ),
      SectionData(
        title: 'event_location_messages'.tr(),
        details: data.eventLocationMessages,
      ),
      SectionData(
        title: 'reminder_messages'.tr(),
        details: data.reminderMessages,
      ),
      SectionData(
        title: 'congratulation_messages'.tr(),
        details: data.congratulationMessages,
      ),
      SectionData(
    title: 'urgent_messages'.tr(),
    isUrgent: true,
    cancellationDetails: data.urgentCancellationMessages,
    postponementDetails: data.urgentPostponementMessages,
  ),
    ];

    return ListView.separated(
      padding: EdgeInsets.only(bottom: edge * 2),
      itemCount: sections.length,
      separatorBuilder: (_, __) => Divider(
        height: edge * 2,
        color: AppColor.gray100,
        thickness: 1,
      ),
      itemBuilder: (context, index) => MessageSection(section: sections[index]),
    );
  }
}

// ── Section widget ────────────────────────────────────────────────────────────
