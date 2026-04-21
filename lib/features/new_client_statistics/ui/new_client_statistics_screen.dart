import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/custom_loading_indicator.dart';
import 'package:app/core/widgets/empty_widget.dart';
import 'package:app/generated/assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/helpers/date_time_helper.dart';
import '../../../core/helpers/extensions.dart';
import '../../../core/routing/routes.dart';
import '../../../core/widgets/client_header.dart';
import '../../../core/widgets/main_card.dart';
import '../../../core/widgets/normal_text.dart';
import '../../../core/widgets/title_text.dart';
import '../../client_events/data/models/client_event_response.dart';
import '../../client_statistics/logic/client_statistics_cubit.dart';
import '../../client_statistics/logic/client_statistics_states.dart';
import '../../gatekeeper_home/views/widgets/upcoming_events_badge.dart';

class NewClientStatisticsScreen extends StatefulWidget {
  const NewClientStatisticsScreen({super.key});

  @override
  State<NewClientStatisticsScreen> createState() =>
      _NewClientStatisticsScreenState();
}

class _NewClientStatisticsScreenState extends State<NewClientStatisticsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ClientStatisticsCubit>().getClientEvents(isNextPage: true);
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

    return BlocBuilder<ClientStatisticsCubit, ClientStatisticsStates>(
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
          color: Colors.black,
          opacity: 0.5,
          child: Scaffold(
            key: ValueKey(currentLocale.languageCode),
            backgroundColor: AppColor.whiteColor,
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ────────────────────────────────────────────
                  ClientHeader(
                    title: 'statistics'.tr(),
                    subTitle: 'welcome'.tr(),
                    notificationCount: 3,
                  ),

                  // ── Promo card ────────────────────────────────────────
                  MainCard(
                    title: 'detailed_statistics'.tr(),
                    image: Assets.imagesEventStatistics,
                    subtitle: 'follow_events_statistics'.tr(),
                  ),

                  SizedBox(height: edge),
                  UpcomingEventsBadge(eventsNumber: events.length),

                  // ── States ────────────────────────────────────────────
                  state.maybeWhen(
                    emptyInput: () => const EmptyWidget(),
                    error: (message) =>
                        _StatisticsErrorWidget(message: message),
                    orElse: () => _StatisticsEventsList(
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

class _StatisticsEventsList extends StatelessWidget {
  const _StatisticsEventsList({
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
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          separatorBuilder: (_, __) => SizedBox(height: edge * 0.4),
          itemBuilder: (context, index) =>
              _StatisticsEventCard(event: events[index]),
        ),
        if (isLoadingMore) ...[
          SizedBox(height: edge),
          Center(
              child: CircularProgressIndicator(color: AppColor.primaryColor)),
          SizedBox(height: edge),
        ],
      ],
    );
  }
}

class _StatisticsEventCard extends StatelessWidget {
  const _StatisticsEventCard({required this.event});

  final ClientEventDetails event;

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.clientStatisticsDetailScreen,
          arguments: event,
        );
      },
      child: Container(
        padding: EdgeInsets.all(edge * 0.8),
        margin: EdgeInsets.symmetric(horizontal: edge),
        decoration: BoxDecoration(
          color: AppColor.gray50,
          borderRadius: BorderRadius.circular(radiusInput),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
              text: event.eventTitle ?? '',
              color: AppColor.gray800,
              fontSize: 18,
            ),
            SizedBox(height: edge * 0.1),
            NormalText(
              text: DateTimeHelper.formatDateLabel(
                event.eventFrom,
                isArabic: isArabic,
              ),
              color: AppColor.primaryColor,
              fontSize: 16,
            ),
            SizedBox(height: edge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: 'more_statistics'.tr(),
                  color: AppColor.primaryColor,
                  fontSize: 16,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.primaryColor,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsErrorWidget extends StatelessWidget {
  const _StatisticsErrorWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: edge * 3, horizontal: edge),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: edge),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
            SizedBox(height: edge),
            ElevatedButton(
              onPressed: () =>
                  context.read<ClientStatisticsCubit>().getClientEvents(),
              child: Text('retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
