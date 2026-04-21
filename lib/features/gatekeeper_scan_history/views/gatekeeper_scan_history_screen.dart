import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/widgets/public_app_bar.dart';
import '../../../core/widgets/title_text.dart';
import '../../events_scan_history/logic/gatekeeper_events_cubit.dart';
import '../../events_scan_history/logic/scan_history_states.dart';
import '../../gatekeeper_home/views/widgets/event_card.dart';


class GatekeeperScanHistoryScreen extends StatefulWidget {
  const GatekeeperScanHistoryScreen({super.key});

  @override
  State<GatekeeperScanHistoryScreen> createState() =>
      _GatekeeperScanHistoryScreenState();
}

class _GatekeeperScanHistoryScreenState
    extends State<GatekeeperScanHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GatekeeperEventsCubit>().getGatekeeperEvents();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<GatekeeperEventsCubit>();
      if (cubit.hasMoreEvents) {
        cubit.getGatekeeperEvents(isNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: recordsAppBar(context, 'scan_history'.tr()),
      body: Container(
        decoration: BoxDecoration(gradient: AppColor.greenGradient),
        child: BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
          buildWhen: (previous, current) =>
          current is EmptyInputScanHistory ||
              current is LoadingScanHistory ||
              current is SuccessScanHistory ||
              current is ErrorScanHistory,
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () =>
              const Center(child: Loader(color: whiteTextColor)),
              emptyInput: () =>
                  _buildCenteredMessage("no_available_scan_history".tr()),
              error: (error) => _buildCenteredMessage(error),
              success: (response, isLoadingMore) {
                final events = response.entityList ?? [];

                if (events.isEmpty) {
                  return _buildCenteredMessage(
                      "no_available_scan_history".tr());
                }

                return Container(
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(containerRadius),
                      topRight: Radius.circular(containerRadius),
                    ),
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: edge),
                    itemCount: events.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == events.length && isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Loader(color: AppColor.primaryColor),
                          ),
                        );
                      }
                      return EventCard(event: events[index],showNavBar: false,);
                    },
                  ),
                );
              },
              errorCheck: (_) => const SizedBox.shrink(),
              successCheck: (_) => const SizedBox.shrink(),
              loadingCheckIn: () => const SizedBox.shrink(),
              loadingCheckOut: () => const SizedBox.shrink(),
              loadingDeleteEvent: () => const SizedBox.shrink(),
              successDeleteEvent: (_) => const SizedBox.shrink(),
              errorDeleteEvent: (_) => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: TitleText(
        text: message,
        color: Colors.white,
        align: TextAlign.center,
      ),
    );
  }
}