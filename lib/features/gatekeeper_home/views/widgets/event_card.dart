import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/date_time_helper.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../../generated/assets.gen.dart';
import '../../../events_scan_history/data/models/gatekeeper_events_response.dart';
import '../../../events_scan_history/logic/gatekeeper_events_cubit.dart';
import '../../../events_scan_history/ui/widgets/delete_gatekeeper_event.dart';

class EventCard extends StatelessWidget {
  final EventsList event;
  final bool? showNavBar;

  const EventCard({super.key, required this.event, this.showNavBar = true});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return GestureDetector(
      onTap: () {
        // if (event.scanned != null && event.scanned! <= 0) {
        //   context.showErrorToast("event_not_attended".tr());
        // } else {
        debugPrint("index: ${event.id}");
        context.pushNamed(
          Routes.eventDetailScreen,
          arguments: {'event': event, 'showBottomBar': showNavBar},
        );
        // }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: edge),
        child: Container(
          decoration: BoxDecoration(
              color: AppColor.gray50,
              borderRadius: BorderRadius.circular(radiusInput)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: edge, vertical: edge * 0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(
                      text: event.eventCode ?? "",
                      color: AppColor.gray800,
                      fontSize: 16,
                      align: TextAlign.start,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return BlocProvider.value(
                              value: context.read<GatekeeperEventsCubit>(),
                              child: DeleteGatekeeperEventDialogBox(
                                event: event,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(edge * 0.3),
                        decoration: BoxDecoration(
                          color: AppColor.gray400,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: edge),
                child: TitleText(
                  text: event.eventTitle ?? '',
                  color: AppColor.gray800,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: edge * 0.2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: edge),
                child: eventDateAndTime(
                    from: event.eventFrom,
                    to: event.eventTo,
                    attendanceTime: event.attendanceTime,
                    leaveTime: event.leaveTime,
                    isArabic: isArabic),
              ),
              SizedBox(height: edge * 0.7),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => viewMap(context),
                      child: Container(
                        padding: EdgeInsets.all(edge * 0.7),
                        decoration: BoxDecoration(
                          color: AppColor.locationBackground,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(Assets.images.location),
                      ),
                    ),
                    SizedBox(width: edge * 0.4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleText(
                          text: event.eventVenue ?? "",
                          color: AppColor.gray800,
                          fontSize: 16,
                        ),
                        NormalText(
                          text: event.eventlocation ?? "",
                          color: AppColor.gray500,
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: edge * 0.7),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: edge * 0.6, horizontal: edge * 0.7),
                decoration: BoxDecoration(
                  gradient: AppColor.greenGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radiusInput),
                    bottomRight: Radius.circular(radiusInput),
                  ),
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NormalText(
                              text: "contact_info".tr(),
                              color: AppColor.whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            NormalText(
                              text: event.contactName ?? "",
                              color: AppColor.whiteColor,
                              fontSize: 14,
                            ),
                            TitleText(
                              text: event.contactPhone ?? "",
                              color: AppColor.whiteColor,
                              fontSize: 20,
                            ),
                          ],
                        ),

                        // Column(
                        //   children: [
                        //     NormalText(
                        //       text: "attendees_count".tr(),
                        //       color: AppColor.whiteColor,
                        //       fontSize: 14,
                        //     ),
                        //     TitleText(
                        //       text: (event.totalAllocated ?? 0).toString(),
                        //       color: AppColor.whiteColor,
                        //       fontSize: 24,
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                    Positioned(
                      right: 2,
                      bottom: 0,
                      top: 0,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColor.whiteColor,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column eventDateAndTime({
    required String? from,
    required String? to,
    required String? attendanceTime,
    required String? leaveTime,
    required bool isArabic,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(text: 'start_time'.tr(), color: AppColor.gray900),
            NormalText(text: 'end_time'.tr(), color: AppColor.gray900),
          ],
        ),
        SizedBox(height: edge * 0.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(
                text: DateTimeHelper.formatDate(from, isArabic: isArabic),
                color: AppColor.gray900),
            Icon(Icons.arrow_right_alt, color: AppColor.gray900),
            NormalText(
                text: DateTimeHelper.formatDate(to, isArabic: isArabic),
                color: AppColor.gray900),
          ],
        ),
        SizedBox(height: edge * 0.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time,
                    color: AppColor.primaryColor, size: 16),
                SizedBox(width: edge * 0.4),
                NormalText(
                  text: DateTimeHelper.formatTimeOnly(attendanceTime,
                      isArabic: isArabic),
                  color: AppColor.gray900,
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time,
                    color: AppColor.mainRed, size: 16),
                SizedBox(width: edge * 0.4),
                NormalText(
                  text: DateTimeHelper.formatTimeOnly(leaveTime,
                      isArabic: isArabic),
                  color: AppColor.gray900,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Function to handle map viewing
  Future viewMap(BuildContext context) async {
    if (event.gmapCode == null) {
      context.showErrorToast("location_not_available".tr());
      return;
    }

    String googleUrl = event.gmapCode ?? "https://maps.google.com";
    //print("Google URL: $googleUrl");
    try {
      await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.platformDefault);
    } catch (e) {
      // Handle exceptions appropriately
    }
  }
}
