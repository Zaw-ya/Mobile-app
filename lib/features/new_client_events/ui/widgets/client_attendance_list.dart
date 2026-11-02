import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/empty_widget.dart';
import 'package:app/core/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../client_events/data/models/client_event_details_response.dart';
import 'client_attendance_item.dart';

/// Attendance rows as a sliver, so they scroll with the sheet's header.
class ClientAttendanceList extends StatelessWidget {
  const ClientAttendanceList({
    super.key,
    required this.items,
    required this.isLoadingMore,
  });

  final List<ClientEventDetailsList> items;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SliverToBoxAdapter(child: EmptyWidget());

    return SliverList.separated(
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: edge * 0.4),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(edge * 0.5),
              child: Loader(color: AppColor.primaryDark),
            ),
          );
        }
        return ClientAttendanceItem(item: items[index]);
      },
    );
  }
}
