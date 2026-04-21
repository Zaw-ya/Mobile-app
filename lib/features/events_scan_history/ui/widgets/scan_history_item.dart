import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../data/models/gatekeeper_events_response.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import 'delete_gatekeeper_event.dart';

class ScanHistoryItem extends StatelessWidget {
  final EventsList? event;

  const ScanHistoryItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(edge, edge, edge, 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: edge * 0.5,
        children: [
          Padding(
            padding: EdgeInsets.all(edge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: edge * 0.5,
              children: [
                eventCodeAndTitle(context),
                eventLocation(context),
                greyDivider(),
                eventDateAndTime(context),
                contactDetails(),
              ],
            ),
          ),
          eventStatistics()
        ],
      ),
    );
  }

  Widget eventStatistics() {
    return Container(
      padding: EdgeInsets.all(edge),
      decoration: BoxDecoration(
        color: navBarBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NormalText(
                text: 'scanned'.tr(),
                color: Colors.white,
                fontSize: 16,
              ),
              NormalText(
                text: event?.scanned.toString() ?? "0",
                color: Colors.white,
                fontSize: 16,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NormalText(
                text: 'allocated'.tr(),
                color: Colors.white,
                fontSize: 16,
              ),
              event?.totalAllocated == null
                  ? NormalText(
                      text: "0",
                      color: Colors.white,
                      fontSize: 16,
                    )
                  : NormalText(
                      text: event?.totalAllocated.toString() ?? "0",
                      color: Colors.white,
                      fontSize: 16,
                    ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NormalText(
                text: 'pending'.tr(),
                color: Colors.white,
                fontSize: 16,
              ),
              NormalText(
                text: getPending(event!),
                color: Colors.white,
                fontSize: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column contactDetails() {
    return Column(
      children: [
        Row(
          children: [
            NormalText(text: "contact".tr(), color: Colors.white),
            SizedBox(width: edge * 0.6),
            Expanded(child: Divider())
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
            ),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: NormalText(
                text: event?.contactName ?? "",
                color: Colors.white,
                align: TextAlign.start,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.phone,
              color: Colors.white,
            ),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: NormalText(
                text: event?.contactPhone ?? "",
                color: Colors.white,
                align: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column eventDateAndTime(BuildContext context) {
    // Use direct formatting for dates - fallback approach
    String eventFromDisplay = "N/A";
    String eventToDisplay = "N/A";

    if (event?.eventFrom != null && event!.eventFrom!.isNotEmpty) {
      String dateStr = event!.eventFrom!;
      // Direct string manipulation approach as fallback
      if (dateStr.length >= 10) {
        String datePart = dateStr.substring(0, 10);
        List<String> parts = datePart.split('-');
        if (parts.length == 3) {
          int month = int.tryParse(parts[1]) ?? 0;
          List<String> monthNames = [
            "",
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec"
          ];
          eventFromDisplay = "${monthNames[month]} ${parts[2]}, ${parts[0]}";
        }
      }
    }

    if (event?.eventTo != null && event!.eventTo!.isNotEmpty) {
      String dateStr = event!.eventTo!;
      // Direct string manipulation approach as fallback
      if (dateStr.length >= 10) {
        String datePart = dateStr.substring(0, 10);
        List<String> parts = datePart.split('-');
        if (parts.length == 3) {
          int month = int.tryParse(parts[1]) ?? 0;
          List<String> monthNames = [
            "",
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec"
          ];
          eventToDisplay = "${monthNames[month]} ${parts[2]}, ${parts[0]}";
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(text: 'start_time'.tr(), color: Colors.white),
            NormalText(text: 'end_time'.tr(), color: Colors.white),
          ],
        ),
        SizedBox(height: edge * 0.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(
              text: eventFromDisplay,
              color: Colors.white,
            ),
            Icon(
              Icons.arrow_right_alt,
              color: Colors.white,
            ),
            NormalText(
              text: eventToDisplay,
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(height: edge * 0.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.blue,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                NormalText(
                  text: event?.attendanceTime ?? "",
                  color: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.red,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                NormalText(
                  text: event?.leaveTime ?? "",
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Divider greyDivider() {
    return Divider(
      color: Colors.grey.shade400,
    );
  }

  ElevatedButton eventLocation(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: navBarBackground),
      onPressed: () {
        viewMap(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map,
              color: Colors.white,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    text: event?.eventVenue ?? "",
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  NormalText(
                    text: event?.eventlocation ?? "",
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column eventCodeAndTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: edge * 0.5,
      children: [
        Row(
          children: [
            Expanded(
              child: TitleText(
                text: event?.eventCode ?? "",
                color: Colors.white,
                fontSize: 16,
                align: TextAlign.start,
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return BlocProvider.value(
                      value: context.read<GatekeeperEventsCubit>(),
                      child: DeleteGatekeeperEventDialogBox(
                        event: event!,
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: navBarBackground,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: TitleText(
                text: event?.eventTitle ?? "",
                color: Colors.white,
                fontSize: 16,
                align: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Function to handle map viewing
  Future viewMap(BuildContext context) async {
    if (event?.gmapCode == null) {
      context.showErrorToast("location_not_available".tr());
      return;
    }

    String googleUrl = event?.gmapCode ?? "https://maps.google.com";
    //print("Google URL: $googleUrl");
    try {
      await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.platformDefault);
    } catch (e) {
      // Handle exceptions appropriately
    }
  }

  String getPending(EventsList event) {
    String pending = "";
    int allocated = event.totalAllocated ?? 0;
    int scanned = event.scanned ?? 0;
    pending = (allocated - scanned).toString();
    return pending;
  }
}
