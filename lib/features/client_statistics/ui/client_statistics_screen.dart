import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/widgets/public_appbar.dart';
import '../../client_events/data/models/client_event_response.dart';
import '../../client_events/ui/widgets/client_event_item.dart';
import '../logic/client_statistics_cubit.dart';
import '../logic/client_statistics_states.dart';

class ClientStatisticsScreen extends StatefulWidget {
  const ClientStatisticsScreen({super.key});

  @override
  State<ClientStatisticsScreen> createState() => _ClientStatisticsScreenState();
}

class _ClientStatisticsScreenState extends State<ClientStatisticsScreen> {
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
      final cubit = context.read<ClientStatisticsCubit>();
      if (cubit.hasMoreEvents) {
        cubit.getClientEvents(isNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      appBar: publicAppBar(context, 'statistics'.tr()),
      body: BlocBuilder<ClientStatisticsCubit, ClientStatisticsStates>(
        buildWhen: (previous, current) => current != previous,
        bloc: context.read<ClientStatisticsCubit>()..getClientEvents(),
        builder: (context, current) {
          return current.when(
            initial: () => const SizedBox.shrink(),
            emptyInput: () =>
                _buildCenteredMessage('no_available_events'.tr()),
            error: (error) => _buildCenteredMessage(error),
            loading: () =>
                Center(child: Loader(color: AppColor.primaryDark)),
            successFetchData: (_) => const SizedBox.shrink(),
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
                      itemCount:
                          events.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == events.length && isLoadingMore) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                                child: Loader(
                                    color: AppColor.primaryDark)),
                          );
                        }
                        return GestureDetector(
                          onTap: () =>
                              _showEventBottomSheet(events[index]),
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
                text: 'confirmation_service'.tr(),
                onTap: () {
                  context.pop();
                  context.pushNamed(
                      Routes.clientConfirmationServicesScreen,
                      arguments: event?.id.toString());
                },
              ),
              SizedBox(height: edge * 0.5),
              _buildSheetOption(
                text: 'card_sending_service'.tr(),
                onTap: () {
                  context.pop();
                  context.pushNamed(Routes.sentCardsServicesScreen,
                      arguments: event?.id.toString());
                },
              ),
              SizedBox(height: edge * 0.5),
              _buildSheetOption(
                text: 'all_message_statistics'.tr(),
                onTap: () {
                  context.pop();
                  context.pushNamed(
                      Routes.clientMessagesStatisticsScreen,
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
        padding: EdgeInsets.symmetric(
            vertical: edge * 0.6, horizontal: edge),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColor.semanticError.withValues(alpha: 0.08)
              : AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive
                ? AppColor.semanticError
                : AppColor.gray100,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.titleSmall.copyWith(
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
        style: AppTextStyles.bodyMedium.copyWith(color: AppColor.gray500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
