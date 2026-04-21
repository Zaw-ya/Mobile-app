import 'package:app/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/event_detail_card.dart';
import '../../../client_events/data/models/client_event_response.dart';
import '../../../event_calender/data/models/calender_events.dart';

class ClientEventDetailCardWrapper extends StatelessWidget {
  const ClientEventDetailCardWrapper({super.key, required this.event});

  final ClientEventDetails event;

  CalenderEventsResponse get _mapped => CalenderEventsResponse(
        eventTitle: event.eventTitle,
        eventFrom: event.eventFrom,
        eventTo: event.eventTo,
        eventVenue: event.eventVenue,
        eventLocation: null,
        parentTitle: null,
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: edge),
        child: GestureDetector(
            onTap: (){
              context.pushNamed(Routes.clientEventsDetailsScreen,arguments: event);
            },
            child: EventDetailCard(event: _mapped)),
      );
}
