import 'package:app/features/client_statistics/data/models/client_messages_statistics_response.dart';

class SectionData {
  final String title;
  final ClientMessagesStatisticsDetails? details;

  // Only for urgebt 
  final ClientMessagesStatisticsDetails? cancellationDetails;
  final ClientMessagesStatisticsDetails? postponementDetails;

  final bool isUrgent;

  const SectionData({
    required this.title,
    this.details,
    this.cancellationDetails,
    this.postponementDetails,
    this.isUrgent = false,
  });
}