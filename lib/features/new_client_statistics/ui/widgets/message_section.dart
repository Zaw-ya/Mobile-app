import 'package:flutter/material.dart';

import 'package:app/features/new_client_statistics/data/models/section_data.dart';
import 'package:app/features/new_client_statistics/ui/widgets/normal_message_section.dart';
import 'package:app/features/new_client_statistics/ui/widgets/urgent_tab_section.dart';

class MessageSection extends StatelessWidget {
  final SectionData section;

  const MessageSection({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    /// Urgent Messages
    if (section.isUrgent) {
      
      if (section.cancellationDetails == null &&
          section.postponementDetails == null) {
        return const SizedBox.shrink();
      }

      return UrgentTabSection(
        cancellationDetails: section.cancellationDetails,
        postponementDetails: section.postponementDetails,
      );
    }

    if (section.details == null) {
      return const SizedBox.shrink();
    }

    return NormalMessageSection(
      title: section.title,
      details: section.details!,
    );
  }
}
