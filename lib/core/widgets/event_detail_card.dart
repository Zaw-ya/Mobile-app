import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/helpers/date_time_helper.dart';
import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theming/colors.dart';
import '../../../../generated/assets.dart';
import '../../features/event_calender/data/models/calender_events.dart';
import '../helpers/extensions.dart';

class EventDetailCard extends StatelessWidget {
  final CalenderEventsResponse event;

  const EventDetailCard({super.key, required this.event});

  Future<void> _viewMap(BuildContext context, String? location) async {
    if (location == null) {
      context.showErrorToast("location_not_available".tr());
      return;
    }

    try {
      await launchUrl(Uri.parse(location), mode: LaunchMode.platformDefault);
    } catch (e) {
      // Handle exceptions appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    return Container(
      margin: EdgeInsets.only(bottom: edge * 0.5),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(radiusInput),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title header ─────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: edge * 0.8, vertical: edge * 0.6),
            child: Text(
              event.eventTitle ?? '',
              style: context.typography.headlineSmall,
            ),
          ),

          if (event.eventVenue != null && event.eventVenue!.isNotEmpty) ...[
            const Divider(height: 1, color: AppColor.gray100),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: edge * 0.8, vertical: edge * 0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Location row ─────────────────────────────────────────
                  GestureDetector(
                    onTap: () => _viewMap(context, event.eventLocation),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(edge * 0.6),
                          decoration: const BoxDecoration(
                            color: AppColor.gray50,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            Assets.imagesLocation,
                            colorFilter: const ColorFilter.mode(
                                AppColor.primaryDark, BlendMode.srcIn),
                            width: 16,
                            height: 16,
                          ),
                        ),
                        SizedBox(width: edge * 0.4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (event.parentTitle != null &&
                                  event.parentTitle!.isNotEmpty)
                                Text(
                                  event.parentTitle!,
                                  style: context.typography.titleSmall,
                                ),
                              Text(
                                event.eventVenue!,
                                style: context.typography.bodySmall
                                    .copyWith(color: AppColor.gray600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: edge * 0.8),

                  // ── From / To dashed line ─────────────────────────────────
                  Row(
                    children: [
                      Text('from'.tr(), style: context.typography.labelSmall),
                      SizedBox(width: edge * 0.3),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColor.primaryDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: edge * 0.3),
                      Expanded(
                        child: CustomPaint(
                          painter: DashedLinePainter(color: AppColor.gray200),
                        ),
                      ),
                      SizedBox(width: edge * 0.3),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColor.primaryDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: edge * 0.3),
                      Text('to'.tr(), style: context.typography.labelSmall),
                    ],
                  ),
                  SizedBox(height: edge * 0.5),

                  // ── Dates ─────────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateTimeHelper.formatDate(event.eventFrom,
                            isArabic: isArabic),
                        style: context.typography.bodySmall
                            .copyWith(color: AppColor.gray700),
                      ),
                      Text(
                        DateTimeHelper.formatDate(event.eventTo,
                            isArabic: isArabic),
                        style: context.typography.bodySmall
                            .copyWith(color: AppColor.gray700),
                      ),
                    ],
                  ),
                  SizedBox(height: edge * 0.4),

                  // ── Times ─────────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateTimeHelper.formatTime(event.eventFrom,
                            isArabic: isArabic),
                        style: context.typography.numericMedium,
                      ),
                      Text(
                        DateTimeHelper.formatTime(event.eventTo,
                            isArabic: isArabic),
                        style: context.typography.numericMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Dashed line painter ────────────────────────────────────────────────────────

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const DashedLinePainter({
    required this.color,
    this.dashWidth = 8,
    this.dashSpace = 3,
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final double y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset((startX + dashWidth).clamp(0, size.width), y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.dashSpace != dashSpace;
}
// import 'package:app/core/dimensions/dimensions_constants.dart';
// import 'package:app/core/helpers/date_time_helper.dart';
// import 'package:app/core/widgets/normal_text.dart';
// import 'package:app/core/widgets/title_text.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../../core/theming/colors.dart';
// import '../../../../generated/assets.dart';
// import '../../features/event_calender/data/models/calender_events.dart';
// import '../helpers/extensions.dart';

// class EventDetailCard extends StatelessWidget {
//   final CalenderEventsResponse event;

//   const EventDetailCard({super.key, required this.event});

//   Future<void> _viewMap(BuildContext context, String? location) async {
//     if (location == null) {
//       context.showErrorToast("location_not_available".tr());
//       return;
//     }

//     try {
//       await launchUrl(Uri.parse(location), mode: LaunchMode.platformDefault);
//     } catch (e) {
//       // Handle exceptions appropriately
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isArabic = context.locale.languageCode == 'ar';

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: edge * 0.6, vertical: edge),
//       decoration: BoxDecoration(
//         // color: AppColor.gray50,
//         // gradient: AppColor.greenGradient,
//         border: Border.all(color: AppColor.primaryColor,width: 1.5),
//         borderRadius: BorderRadius.circular(radiusInput),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(

//             decoration: BoxDecoration(gradient: AppColor.blackGradient),
//             alignment: Alignment.center,
//             child: TitleText(
//               text: event.eventTitle ?? '',
//               fontSize: 20,
//               color: AppColor.black,
//             ),
//           ),
//           SizedBox(height: edge * 0.2),
//           if (event.eventVenue != null && event.eventVenue!.isNotEmpty) ...[
//             SizedBox(height: edge * 0.4),

//             // ── Location row ───────────────────────────────────────────────
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => _viewMap(context, event.eventLocation),
//                   child: Container(
//                     padding: EdgeInsets.all(edge * 0.7),
//                     decoration: BoxDecoration(
//                       color: AppColor.locationBackground,
//                       shape: BoxShape.circle,
//                     ),
//                     child: SvgPicture.asset(Assets.imagesLocation),
//                   ),
//                 ),
//                 SizedBox(width: edge * 0.4),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (event.parentTitle != null &&
//                           event.parentTitle!.isNotEmpty)
//                         TitleText(
//                           text: event.parentTitle!,
//                           color: AppColor.black,
//                           fontSize: 16,
//                         ),
//                       NormalText(
//                         text: event.eventVenue!,
//                         color: AppColor.black,
//                         fontSize: 16,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: edge),

//             // ── From / To dashed line ──────────────────────────────────────
//             Row(
//               children: [
//                 TitleText(
//                   text: "from".tr(),
//                   fontSize: 16,
//                   color: AppColor.black,
//                 ),
//                 SizedBox(width: edge * 0.3),
//                 Container(
//                   width: 6,
//                   height: 6,
//                   decoration: const BoxDecoration(
//                     color: AppColor.black,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 SizedBox(width: edge * 0.3),
//                 Expanded(
//                   child: CustomPaint(
//                     painter: DashedLinePainter(color: AppColor.gray200),
//                   ),
//                 ),
//                 SizedBox(width: edge * 0.3),
//                 Container(
//                   width: 6,
//                   height: 6,
//                   decoration: const BoxDecoration(
//                     color: AppColor.black,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 SizedBox(width: edge * 0.3),
//                 TitleText(
//                   text: "to".tr(),
//                   fontSize: 16,
//                   color: AppColor.black,
//                 ),
//               ],
//             ),
//             SizedBox(height: edge * 0.6),

//             // ── Dates ──────────────────────────────────────────────────────
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 NormalText(
//                   text: DateTimeHelper.formatDate(event.eventFrom,
//                       isArabic: isArabic),
//                   fontSize: 16,
//                   color: AppColor.black,
//                 ),
//                 NormalText(
//                   text: DateTimeHelper.formatDate(event.eventTo,
//                       isArabic: isArabic),
//                   fontSize: 16,
//                   color: AppColor.black,
//                 ),
//               ],
//             ),
//             SizedBox(height: edge * 0.6),

//             // ── Times ──────────────────────────────────────────────────────
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TitleText(
//                   text: DateTimeHelper.formatTime(event.eventFrom,
//                       isArabic: isArabic),
//                   fontSize: 24,
//                   color: AppColor.black,
//                 ),
//                 TitleText(
//                   text: DateTimeHelper.formatTime(event.eventTo,
//                       isArabic: isArabic),
//                   fontSize: 24,
//                   color: AppColor.black,
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ── Dashed line painter ────────────────────────────────────────────────────────

// class DashedLinePainter extends CustomPainter {
//   final Color color;
//   final double dashWidth;
//   final double dashSpace;
//   final double strokeWidth;

//   const DashedLinePainter({
//     required this.color,
//     this.dashWidth = 8,
//     this.dashSpace = 3,
//     this.strokeWidth = 1.5,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;

//     double startX = 0;
//     final double y = size.height / 2;

//     while (startX < size.width) {
//       canvas.drawLine(
//         Offset(startX, y),
//         Offset((startX + dashWidth).clamp(0, size.width), y),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }
//   }

//   @override
//   bool shouldRepaint(DashedLinePainter oldDelegate) =>
//       oldDelegate.color != color ||
//           oldDelegate.dashWidth != dashWidth ||
//           oldDelegate.dashSpace != dashSpace;
// }