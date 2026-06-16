import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../data/models/client_event_response.dart';

class ClientEventItem extends StatelessWidget {
  final ClientEventDetails? event;

  const ClientEventItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(edge, edge, edge, 0),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(edge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCodeAndTitle(),
                SizedBox(height: edge * 0.4),
                Text(
                  event?.eventVenue ?? '',
                  style:
                      AppTextStyles.bodySmall.copyWith(color: AppColor.gray600),
                ),
              ],
            ),
          ),
          _buildDateAndTimeFooter(),
        ],
      ),
    );
  }

  Widget _buildCodeAndTitle() {
    final eventId = _formatEventId(event?.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eventId,
          style: AppTextStyles.labelMedium.copyWith(color: AppColor.gray500),
        ),
        SizedBox(height: 4.h),
        Text(
          event?.eventTitle ?? '',
          style: AppTextStyles.headlineSmall,
        ),
      ],
    );
  }

  Widget _buildDateAndTimeFooter() {
    final fromDisplay = _formatDate(event?.eventFrom);
    final toDisplay = _formatDate(event?.eventTo);
    final fromTime = _getTimeInAMPM(event?.eventFrom ?? '');
    final toTime = _getTimeInAMPM(event?.eventTo ?? '');

    return Container(
      padding: EdgeInsets.all(edge),
      decoration: const BoxDecoration(
        color: AppColor.primaryDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('start_time'.tr(),
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColor.primaryLight)),
              Text('end_time'.tr(),
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColor.primaryLight)),
            ],
          ),
          SizedBox(height: edge * 0.4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fromDisplay,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColor.primaryLight)),
              const Icon(Icons.arrow_right_alt,
                  color: AppColor.primaryLight, size: 18),
              Text(toDisplay,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColor.primaryLight)),
            ],
          ),
          if (fromTime.isNotEmpty || toTime.isNotEmpty) ...[
            SizedBox(height: edge * 0.4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: AppColor.semanticSuccess, size: 14),
                    const SizedBox(width: 4),
                    Text(fromTime,
                        style: AppTextStyles.numericMedium
                            .copyWith(color: AppColor.primaryLight,
                                fontSize: 13.sp)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: AppColor.semanticError, size: 14),
                    const SizedBox(width: 4),
                    Text(toTime,
                        style: AppTextStyles.numericMedium
                            .copyWith(color: AppColor.primaryLight,
                                fontSize: 13.sp)),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatEventId(int? id) {
    if (id == null) return '';
    final idStr = id.toString();
    if (idStr.length >= 6) return 'E$idStr';
    final padding = 'E000000'.substring(0, 7 - idStr.length);
    return '$padding$idStr';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr.length < 10) return 'N/A';
    final datePart = dateStr.substring(0, 10);
    final parts = datePart.split('-');
    if (parts.length != 3) return 'N/A';
    final month = int.tryParse(parts[1]) ?? 0;
    const monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (month < 1 || month > 12) return 'N/A';
    return '${monthNames[month]} ${parts[2]}, ${parts[0]}';
  }

  String _getTimeInAMPM(String dateTimeString) {
    if (!dateTimeString.contains('T') || dateTimeString.length <= 11) return '';
    try {
      final timePart = dateTimeString.split('T')[1];
      final components = timePart.split(':');
      if (components.length < 2) return '';
      final hour = int.parse(components[0]);
      final minute = int.parse(components[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return '';
    }
  }
}
