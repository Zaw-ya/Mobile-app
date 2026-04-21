import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/title_text.dart';
import '../../data/models/client_event_response.dart';

class ClientEventItem extends StatelessWidget {
  final ClientEventDetails? event;

  const ClientEventItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(edge, edge, edge, 0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: edge * 0.5,
        children: [
          Padding(
            padding: EdgeInsets.all(edge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eventCodeAndTitle(),
                NormalText(
                  text: event?.eventVenue ?? "",
                  color: Colors.white,
                  fontSize: 16,
                ),
              ],
            ),
          ),
          eventDateAndTime(context),
        ],
      ),
    );
  }

  Column eventCodeAndTitle() {
    String eventId = "";
    String targetId = "E000000";

    String idString = event?.id.toString() ?? "";
    if (idString.length >= 6) {
      //6 zeros
      eventId = 'E$idString';
    } else {
      int length = idString.length;
      targetId = targetId.substring(0, 7 - length);
      eventId = '$targetId$idString';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: edge * 0.5,
      children: [
        TitleText(
          text: eventId,
          color: Colors.white,
          fontSize: 16,
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

  Widget eventDateAndTime(BuildContext context) {
    // Use direct formatting for dates - fallback approach
    String eventFromDisplay = "N/A";
    String eventToDisplay = "N/A";
    String eventFromTimeDisplay = "";
    String eventToTimeDisplay = "";

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

      // Handle time part for AM/PM
      try {
        eventFromTimeDisplay = getTimeInAMPM(dateStr);
      } catch (e) {
        debugPrint("Error formatting event from time: $e");
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

      // Handle time part for AM/PM
      try {
        eventToTimeDisplay = getTimeInAMPM(dateStr);
      } catch (e) {
        debugPrint("Error formatting event to time: $e");
      }
    }

    return Container(
      padding: EdgeInsets.all(edge),
      decoration: BoxDecoration(
        color: navBarBackground,
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
              NormalText(
                text: 'start_time'.tr(),
                color: Colors.white,
                align: TextAlign.center,
              ),
              NormalText(
                text: 'end_time'.tr(),
                color: Colors.white,
                align: TextAlign.center,
              ),
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
              Expanded(
                child: Center(
                  child: Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                  ),
                ),
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
                    text: eventFromTimeDisplay,
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
                    text: eventToTimeDisplay,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

// Helper function for time formatting
  String getTimeInAMPM(String dateTimeString) {
    if (dateTimeString.isEmpty) {
      return "";
    }

    try {
      // Check if the string contains a time part
      if (dateTimeString.contains('T') && dateTimeString.length > 11) {
        String timePart = dateTimeString.split('T')[1];
        List<String> timeComponents = timePart.split(':');

        if (timeComponents.length >= 2) {
          int hour = int.parse(timeComponents[0]);
          int minute = int.parse(timeComponents[1]);

          String period = hour >= 12 ? "PM" : "AM";
          int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

          // Format as HH:MM AM/PM
          return "${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
        }
      }

      return "";
    } catch (e) {
      debugPrint("Error in getTimeInAMPM: $e");
      return "";
    }
  }
}
