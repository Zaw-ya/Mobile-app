import 'dart:async';

import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/public_appbar.dart';
import '../../../../core/widgets/text_field_with_icon.dart';
import '../../logic/client_events_cubit.dart';
import '../../logic/client_events_states.dart';
import 'client_messages_status_item.dart';

class ClientMessagesStatusScreen extends StatefulWidget {
  final String eventId;

  const ClientMessagesStatusScreen({super.key, required this.eventId});

  @override
  State<ClientMessagesStatusScreen> createState() =>
      _ClientMessagesStatusScreenState();
}

class _ClientMessagesStatusScreenState
    extends State<ClientMessagesStatusScreen> {
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _setupSearchListener();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _setupSearchListener() {
    final cubit = context.read<ClientEventsCubit>();
    cubit.searchController.addListener(() {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          final searchQuery = cubit.searchController.text.trim();
          if (searchQuery.isNotEmpty) {
            cubit.searchMessageStatus(
              eventId: widget.eventId,
              searchQuery: searchQuery,
            );
          } else {
            cubit.clearSearch();
            cubit.getClientMessagesStatus(widget.eventId);
          }
        }
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<ClientEventsCubit>();
      if (cubit.hasMoreMessages) {
        cubit.getClientMessagesStatus(widget.eventId, isNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.primaryLight,
        appBar: publicAppBar(context, 'message_status'.tr()),
        body: BlocBuilder<ClientEventsCubit, ClientEventsStates>(
          buildWhen: (previous, current) => current != previous,
          bloc: context.read<ClientEventsCubit>()
            ..getClientMessagesStatus(widget.eventId),
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: edge, vertical: edge),
                  child: _buildSearchField(),
                ),
                Expanded(
                  child: state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () =>
                        Center(child: Loader(color: AppColor.primaryDark)),
                    emptyInput: () =>
                        _buildCenteredMessage('no_available_events'.tr()),
                    error: (error) => _buildCenteredMessage(error),
                    success: (response, isLoadingMore) {
                      final events =
                          response.clientMessagesDetailsList ?? [];
                      if (events.isEmpty) {
                        return _buildCenteredMessage(
                            'no_available_events'.tr());
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        itemCount:
                            events.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == events.length && isLoadingMore) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                  child: Loader(
                                      color: AppColor.primaryDark)),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                  Routes.clientGuestDetailsScreen,
                                  arguments: events[index]);
                            },
                            child: ClientMessagesStatusItem(
                              clientMessagesStatusDetails: events[index],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final cubit = context.read<ClientEventsCubit>();
    final isSearching = _debounceTimer?.isActive ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: textFieldWithIcon(
              icon: isSearching
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primaryDark,
                      ),
                    )
                  : const Icon(Icons.search, color: AppColor.primaryDark),
              hint: 'name/phone number'.tr(),
              controller: cubit.searchController,
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColor.primaryDark,
              foregroundColor: AppColor.primaryLight,
            ),
            onPressed: () {
              _debounceTimer?.cancel();
              cubit.clearSearch();
              cubit.getClientMessagesStatus(widget.eventId);
            },
            child: Text(
              'clear'.tr(),
              style: context.typography.labelMedium
                  .copyWith(color: AppColor.primaryLight),
            ),
          ),
        ],
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
