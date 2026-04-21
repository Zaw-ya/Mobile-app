import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/title_text.dart';
import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/widgets/loader.dart';
import 'widgets/scan_history_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routing/routes.dart';
import '../../../core/widgets/public_appbar.dart';
import '../logic/gatekeeper_events_cubit.dart';
import '../logic/scan_history_states.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(
        context,
        "scan_history".tr(),
      ),
      body: BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
        buildWhen: (previous, current) => previous != current,
        bloc: context.read<GatekeeperEventsCubit>()..getGatekeeperEvents(),
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            errorCheck: (error) => const SizedBox.shrink(),
            successCheck: (success) => const SizedBox.shrink(),
            loadingDeleteEvent: () => const SizedBox.shrink(),
            successDeleteEvent: (success) => const SizedBox.shrink(),
            errorDeleteEvent: (error) => const SizedBox.shrink(),
            loadingCheckOut: () => Center(child: Loader(color: whiteTextColor)),
            loadingCheckIn: () =>
                const Center(child: Loader(color: whiteTextColor)),
            emptyInput: () =>
                _buildCenteredMessage("no_available_scan_history".tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () => const Center(child: Loader(color: whiteTextColor)),
            success: (response, isLoadingMore) {
              final events = response.entityList ?? [];
              if (events.isEmpty) {
                return _buildCenteredMessage("no_available_scan_history".tr());
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: edge),
                      itemCount: events.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == events.length && isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Loader(color: whiteTextColor),
                            ),
                          );
                        }
                        return GestureDetector(
                            onTap: () {
                              if (events[index].scanned != null &&
                                  events[index].scanned! <= 0) {
                                context
                                    .showErrorToast("event_not_attended".tr());
                              } else {
                                debugPrint("index: ${events[index].id}");
                                context.pushNamed(Routes.eventDetailScreen,
                                    arguments: events[index]);
                              }
                            },
                            child: ScanHistoryItem(event: events[index]));
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
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
