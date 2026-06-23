import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/generated/fonts.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/core/widgets/custom_loading_indicator.dart';
import 'package:app/core/widgets/empty_widget.dart';
import 'package:app/core/widgets/loader.dart';
import 'package:app/features/notifications/logic/notifications_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/helpers/app_utilities.dart';
import '../../../core/widgets/client_header.dart';
import '../../client_events/data/models/client_event_response.dart';
import '../../client_events/logic/client_events_cubit.dart';
import '../../client_events/logic/client_events_states.dart';
import '../../gatekeeper_home/views/widgets/upcoming_events_badge.dart';
import 'widgets/client_event_detail_card_wrapper.dart';

class NewClientEventsScreen extends StatefulWidget {
  const NewClientEventsScreen({super.key});

  @override
  State<NewClientEventsScreen> createState() => _NewClientEventsScreenState();
}

class _NewClientEventsScreenState extends State<NewClientEventsScreen> {
  final ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  _scrollController.addListener(_onScroll);
  // Update badge 
  context.read<NotificationsCubit>().updateBadgeCountOnly();
}

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ClientEventsCubit>().getClientEvents(isNextPage: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return BlocBuilder<ClientEventsCubit, ClientEventsStates>(
      builder: (context, state) {
        final isLoading = state is Loading;

        final isLoadingMore = state.maybeWhen(
          success: (_, isLoadingMore) => isLoadingMore,
          orElse: () => false,
        );

        final events = state.maybeWhen(
          success: (response, __) =>
              (response as ClientEventResponse).eventDetailsList ?? [],
          orElse: () => <ClientEventDetails>[],
        );

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const CustomLoadingIndicator(),
          color: AppColor.primaryDark,
          opacity: 0.4,
          child: Scaffold(
            key: ValueKey(currentLocale.languageCode),
            backgroundColor: AppColor.primaryLight,
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ────────────────────────────────────────────
                  ClientHeader(
                    title:
                        '${AppUtilities().loginData.firstName} ${AppUtilities().loginData.lastName}',
                    subTitle: 'welcome'.tr(),
                  ),

                  // We use in this card 
                  // UpcomingEventsBadge to show the number of upcoming events, and we pass the events list length to it, so it can update the badge count accordingly.
                  // we commented it
                  // ── Promo card ────────────────────────────────────────
                  // MainCard(
                  //   title: 'book_upcoming_events'.tr(),
                  //   image: Assets.imagesReserveNewEvent,
                  //   subtitle: 'contact_us'.tr(),
                  //   whatsappLabel: 'whatsapp',
                  //   whatsappIcon: Assets.svgsWhatsapp,
                  // ),

                  // SizedBox(height: edge),
                  UpcomingEventsBadge(eventsNumber: events.length),

                  // ── States ────────────────────────────────────────────
                  state.maybeWhen(
                    emptyInput: () => const EmptyWidget(),
                    error: (message) => _ClientErrorWidget(message: message),
                    orElse: () => _ClientEventsList(
                      events: events,
                      isLoadingMore: isLoadingMore,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Sub-Widgets ──────────────────────────────────────────────────────────────

class _ClientEventsList extends StatelessWidget {
  const _ClientEventsList({
    required this.events,
    required this.isLoadingMore,
  });

  final List<ClientEventDetails> events;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: edge * 0.8),
          itemCount: events.length,
          separatorBuilder: (_, __) => SizedBox(height: edge * 0.4),
          itemBuilder: (context, index) =>
              ClientEventDetailCardWrapper(event: events[index]),
        ),
        if (isLoadingMore) ...[
          SizedBox(height: edge),
          Center(child: Loader(color: AppColor.primaryDark)),
          SizedBox(height: edge),
        ],
      ],
    );
  }
}

class _ClientErrorWidget extends StatelessWidget {
  const _ClientErrorWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: edge * 3, horizontal: edge),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColor.semanticError),
            SizedBox(height: edge),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: FontFamily.manchetteFine, color: AppColor.semanticError, fontSize: 14.sp),
            ),
            SizedBox(height: edge),
            ElevatedButton(
              onPressed: () =>
                  context.read<ClientEventsCubit>().getClientEvents(),
              child: Text('retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
