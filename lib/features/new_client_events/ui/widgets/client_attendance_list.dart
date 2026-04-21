import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/empty_widget.dart';
import 'package:app/core/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../client_events/data/models/client_event_details_response.dart';
import 'client_attendance_item.dart';

class ClientAttendanceList extends StatelessWidget {
  const ClientAttendanceList({
    super.key,
    required this.items,
    required this.isLoadingMore,
    required this.scrollController,
  });

  final List<ClientEventDetailsList> items;
  final bool isLoadingMore;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const EmptyWidget();

    return ListView.separated(
      controller: scrollController,
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: edge * 0.4),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(edge * 0.5),
              child: Loader(color: AppColor.primaryColor),
            ),
          );
        }
        return ClientAttendanceItem(item: items[index]);
      },
    );
  }
}