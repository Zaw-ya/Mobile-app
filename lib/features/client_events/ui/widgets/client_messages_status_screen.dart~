import 'dart:async';

import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_appbar.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../../../core/widgets/text_field_with_icon.dart';
import '../../logic/client_events_cubit.dart';
import '../../logic/client_events_states.dart';
import 'client_messages_status_item.dart';

class ClientMessagesStatusScreen extends StatefulWidget {
  final String eventId;

  const ClientMessagesStatusScreen({super.key, required this.eventId});

  @override
  State<ClientMessagesStatusScreen> createState() => _ClientMessagesStatusScreenState();
}

class _ClientMessagesStatusScreenState extends State<ClientMessagesStatusScreen> {
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
      // Cancel any existing timer
      _debounceTimer?.cancel();

      // Start a new timer for 1.5 seconds
      _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          final searchQuery = cubit.searchController.text.trim();

          // Only make API call if there's something to search
          if (searchQuery.isNotEmpty) {
            cubit.searchMessageStatus(
              eventId: widget.eventId,
              searchQuery: searchQuery,
            );
          } else {
            // If search is empty, return to normal list
            cubit.clearSearch();
            cubit.getClientMessagesStatus(widget.eventId);
          }
        }
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<ClientEventsCubit>();
      if (cubit.hasMoreMessages) {
        cubit.getClientMessagesStatus(widget.eventId, isNextPage: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: publicAppBar(
          context,
          "message_status".tr(),
        ),
        body: BlocBuilder<ClientEventsCubit, ClientEventsStates>(
          buildWhen: (previous, current) => current != previous,
          bloc: context.read<ClientEventsCubit>()..getClientMessagesStatus(widget.eventId),
          builder: (context, state) {
            // Always show search field at top with content below
            return Column(
              children: [
                // Search field always visible
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge),
                  child: searchField(),
                ),

                // Content area
                Expanded(
                  child: state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const Center(child: CupertinoActivityIndicator(color: Colors.white)),
                    emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
                    error: (error) => _buildCenteredMessage(error),
                    success: (response, isLoadingMore) {
                      final events = response.clientMessagesDetailsList ?? [];

                      if (events.isEmpty) {
                        return _buildCenteredMessage("no_available_events".tr());
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero, // Remove padding since search field is outside
                        itemCount: events.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Show loading indicator at the bottom
                          if (index == events.length && isLoadingMore) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CupertinoActivityIndicator(color: Colors.white),
                              ),
                            );
                          }

                          // Show event items
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(Routes.clientGuestDetailsScreen, arguments: events[index]);
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

  Widget searchField() {
    final cubit = context.read<ClientEventsCubit>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: textFieldWithIcon(
              icon: _debounceTimer?.isActive ?? false
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.search, color: Colors.white),
              hint: "name/phone number".tr(),
              controller: cubit.searchController,
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _debounceTimer?.cancel(); // Cancel any pending search
              cubit.clearSearch();
              cubit.getClientMessagesStatus(widget.eventId);
            },
            child: NormalText(
              text: "clear".tr(),
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: SubTitleText(
        text: message,
        color: Colors.white,
        align: TextAlign.center,
      ),
    );
  }
}
