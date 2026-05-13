import 'package:app/features/new_client_statistics/ui/widgets/urgent_tab_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/widgets/title_text.dart';
import '../../../client_statistics/data/models/client_messages_statistics_response.dart';
import 'normal_message_section.dart';

class UrgentTabSection extends StatefulWidget {
  final ClientMessagesStatisticsDetails? cancellationDetails;
  final ClientMessagesStatisticsDetails? postponementDetails;

  const UrgentTabSection({
    super.key,
    required this.cancellationDetails,
    required this.postponementDetails,
  });

  @override
  State<UrgentTabSection> createState() => _UrgentTabSectionState();
}

class _UrgentTabSectionState extends State<UrgentTabSection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.cancellationDetails == null &&
        widget.postponementDetails == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Title
        TitleText(
          text: 'urgent_messages'.tr(),
          color: AppColor.primaryColor,
          fontSize: 18,
        ),

        SizedBox(height: edge * 0.6),

        /// Tabs
        Row(
          children: [
            UrgentTabItem(
              title: 'cancellation'.tr(),
              isSelected: selectedIndex == 0,
              onTap: () => setState(() => selectedIndex = 0),
            ),
            SizedBox(width: 5.w,),
            UrgentTabItem(
              title: 'postponement'.tr(),
              isSelected: selectedIndex == 1,
              onTap: () => setState(() => selectedIndex = 1),
            ),
          ],
        ),

        /// Content
        IndexedStack(
          index: selectedIndex,
          children: [
            widget.cancellationDetails != null
                ? NormalMessageSection(
                    title: '',
                    details: widget.cancellationDetails!,
                  )
                : const SizedBox.shrink(),

            widget.postponementDetails != null
                ? NormalMessageSection(
                    title: '',
                    details: widget.postponementDetails!,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}

