import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/public_appbar.dart';
import '../logic/gatekeeper_events_cubit.dart';
import '../logic/scan_history_states.dart';
import 'widgets/event_check_dialog_box.dart';
import 'widgets/scan_history_item.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<GatekeeperEventsCubit>().getGatekeeperEvents();
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
      appBar: publicAppBar(context, 'events'.tr()),
      body: BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
        buildWhen: (previous, current) =>
            current is EmptyInputScanHistory ||
            current is LoadingScanHistory ||
            current is SuccessScanHistory ||
            current is ErrorScanHistory,
        builder: (context, current) {
          return current.when(
            initial: () => const SizedBox.shrink(),
            errorCheck: (_) => const SizedBox.shrink(),
            successCheck: (_) => const SizedBox.shrink(),
            emptyInput: () =>
                _buildCenteredMessage('no_available_events'.tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () =>
                Center(child: Loader(color: AppColor.primaryDark)),
            loadingCheckOut: () =>
                Center(child: Loader(color: AppColor.primaryDark)),
            loadingCheckIn: () =>
                Center(child: Loader(color: AppColor.primaryDark)),
            success: (response, isLoadingMore) {
              final events = response.entityList ?? [];
              if (events.isEmpty) {
                return _buildCenteredMessage('no_available_events'.tr());
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
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                final cubit =
                                    context.read<GatekeeperEventsCubit>();
                                return BlocProvider.value(
                                  value: cubit,
                                  child: EventCheckDialogBox(
                                    event: events[index],
                                  ),
                                );
                              },
                            );
                          },
                          child: ScanHistoryItem(event: events[index]),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loadingDeleteEvent: () => const SizedBox.shrink(),
            successDeleteEvent: (_) => const SizedBox.shrink(),
            errorDeleteEvent: (_) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColor.gray500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
