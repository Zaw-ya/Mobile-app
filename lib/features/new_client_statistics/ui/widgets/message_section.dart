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
    /// حالة الـ Urgent Messages
    if (section.isUrgent) {
      // لو النوعين غير موجودين، ما نعرضش أي شيء
      if (section.cancellationDetails == null &&
          section.postponementDetails == null) {
        return const SizedBox.shrink();
      }

      return UrgentTabSection(
        cancellationDetails: section.cancellationDetails,
        postponementDetails: section.postponementDetails,
      );
    }

    /// باقي السكاشن العادية
    if (section.details == null) {
      return const SizedBox.shrink();
    }

    return NormalMessageSection(
      title: section.title,
      details: section.details!,
    );
  }
}

// import 'package:app/features/new_client_statistics/data/models/section_data.dart';
// import 'package:app/features/new_client_statistics/ui/widgets/normal_message_section.dart';
// import 'package:app/features/new_client_statistics/ui/widgets/urgent_tab_section.dart';
// import 'package:flutter/material.dart';
// class MessageSection extends StatelessWidget {
//   final SectionData section;

//   const MessageSection({super.key, required this.section});

//   @override
//   Widget build(BuildContext context) {
//     final details = section.details;
//     if (details == null && section.cancellationDetails == null && section.postponementDetails == null) return const SizedBox.shrink();

//     final read = details.readNumber ?? 0;
//     final delivered = details.deliverdNumber ?? 0;
//     final sent = details.sentNumber ?? 0;
//     final failed = details.failedNumber ?? 0;
//     final notSent = details.notSentNumber ?? 0;
//     final total = read + delivered + sent + failed + notSent;

// return section.isUrgent
//     ? UrgentTabSection(cancellationDetails: section.cancellationDetails,
//      postponementDetails: section.postponementDetails,)
//     : NormalMessageSection(title: section.title, details: section.details!,);
//   }
// }



