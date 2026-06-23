import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/theming/typography_theme.dart';
import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/widgets/loader.dart';
import 'widgets/client_event_item.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/public_appbar.dart';
import '../data/models/client_event_response.dart';
import '../logic/client_events_cubit.dart';
import '../logic/client_events_states.dart';

class ClientEventsScreen extends StatefulWidget {
  const ClientEventsScreen({super.key});

  @override
  State<ClientEventsScreen> createState() => _ClientEventsScreenState();
}

class _ClientEventsScreenState extends State<ClientEventsScreen> {
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
      final cubit = context.read<ClientEventsCubit>();
      if (cubit.hasMoreEvents) {
        cubit.getClientEvents(isNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      appBar: publicAppBar(context, 'events'.tr()),
      body: BlocBuilder<ClientEventsCubit, ClientEventsStates>(
        buildWhen: (previous, current) => current != previous,
        bloc: context.read<ClientEventsCubit>()..getClientEvents(),
        builder: (context, current) {
          return current.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () =>
                _buildCenteredMessage('no_available_events'.tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () =>
                Center(child: Loader(color: AppColor.primaryDark)),
            success: (response, isLoadingMore) {
              final events = response.eventDetailsList ?? [];
              if (events.isEmpty) {
                return _buildCenteredMessage('no_available_events'.tr());
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
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Loader(color: AppColor.primaryDark),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () => _showEventBottomSheet(events[index]),
                          child: ClientEventItem(event: events[index]),
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

  void _showEventBottomSheet(ClientEventDetails? event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(edge, edge * 0.6, edge, edge),
          constraints: BoxConstraints(maxHeight: height * 0.75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: edge * 0.8),
                  decoration: BoxDecoration(
                    color: AppColor.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              _buildSheetOption(
                text: 'attendance_info'.tr(),
                onTap: () {
                  context.pop();
                  context.pushNamed(Routes.clientEventsDetailsScreen,
                      arguments: event);
                },
              ),
              SizedBox(height: edge * 0.5),
              _buildSheetOption(
                text: 'show_message_status'.tr(),
                onTap: () {
                  context.pop();
                  context.pushNamed(Routes.clientMessagesStatusScreen,
                      arguments: event?.id.toString());
                },
              ),
              SizedBox(height: edge * 0.5),
              _buildSheetOption(
                text: 'cancel'.tr(),
                onTap: () => context.pop(),
                isDestructive: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetOption({
    required String text,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: edge * 0.6, horizontal: edge),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColor.semanticError.withValues(alpha: 0.08)
              : AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive ? AppColor.semanticError : AppColor.gray100,
          ),
        ),
        child: Text(
          text,
          style: context.typography.titleSmall.copyWith(
            color: isDestructive
                ? AppColor.semanticError
                : AppColor.primaryDark,
          ),
        ),
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
