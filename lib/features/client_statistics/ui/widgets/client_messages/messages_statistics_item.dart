import 'package:flutter/material.dart';

import '../../../data/models/client_messages_statistics_response.dart';
import 'messages_statistics_chart.dart';
import 'messages_statistics_header.dart';
import 'messages_statistics_table.dart';

class MessagesStatisticsItem extends StatelessWidget {
  final String title;
  final ClientMessagesStatisticsDetails messagesStatisticsDetails;

  const MessagesStatisticsItem({
    super.key,
    required this.title,
    required this.messagesStatisticsDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MessagesStatisticsHeader(title: title),
        MessagesStatisticsTable(details: messagesStatisticsDetails),
        MessagesStatisticsChart(
            title: title, details: messagesStatisticsDetails),
      ],
    );
  }
}
