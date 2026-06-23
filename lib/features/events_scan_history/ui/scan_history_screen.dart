import 'package:app/core/theming/typography_theme.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/extensions.dart';
import '../../../core/routing/routes.dart';
import '../../../core/widgets/public_appbar.dart';
import '../logic/gatekeeper_events_cubit.dart';
import '../logic/scan_history_states.dart';
import 'widgets/scan_history_item.dart';

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
      backgroundColor: AppColor.primaryLight,
      appBar: publicAppBar(context, 'scan_history'.tr()),
      body: BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
        buildWhen: (previous, current) => previous != current,
        bloc: context.read<GatekeeperEventsCubit>()..getGatekeeperEvents(),
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            errorCheck: (_) => const SizedBox.shrink(),
            successCheck: (_) => const SizedBox.shrink(),
            loadingDeleteEvent: () => const SizedBox.shrink(),
            successDeleteEvent: (_) => const SizedBox.shrink(),
            errorDeleteEvent: (_) => const SizedBox.shrink(),
            loadingCheckOut: () =>
                Center(child: Loader(color: AppColor.primaryDark)),
            loadingCheckIn: () =>
                Center(child: Loader(color: AppColor.primaryDark)),
            emptyInput: () =>
                _buildCenteredMessage('no_available_scan_history'.tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () =>
                Center(child: Loader(color: AppColor.primaryDark)),
            success: (response, isLoadingMore) {
              final events = response.entityList ?? [];
              if (events.isEmpty) {
                return _buildCenteredMessage('no_available_scan_history'.tr());
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: events.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == events.length && isLoadingMore) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                                child: Loader(color: AppColor.primaryDark)),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            if (events[index].scanned != null &&
                                events[index].scanned! <= 0) {
                              context.showErrorToast(
                                  'event_not_attended'.tr());
                            } else {
                              context.pushNamed(Routes.eventDetailScreen,
                                  arguments: events[index]);
                            }
                          },
                          child: ScanHistoryItem(event: events[index]),
                        );
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
      child: Text(
        message,
        style: context.typography.bodyMedium.copyWith(color: AppColor.gray500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
