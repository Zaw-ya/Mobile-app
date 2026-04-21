import 'dart:async';

import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/custom_loading_indicator.dart';
import 'package:app/core/widgets/drag_handle.dart';
import 'package:app/core/widgets/empty_widget.dart';
import 'package:app/core/widgets/loader.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/widgets/public_app_bar.dart';
import '../../../client_events/data/models/client_event_details_response.dart';
import '../../../client_events/data/models/client_event_response.dart';
import '../../../client_events/data/models/client_messages_status_response.dart';
import '../../../client_events/logic/client_events_cubit.dart';
import '../../../client_events/logic/client_events_states.dart';
import 'client_attendance_list.dart';
import 'client_event_details_card.dart';
import 'client_messages_list.dart';
import 'client_tab_button.dart';

class ClientEventDetailScreen extends StatefulWidget {
  final ClientEventDetails event;

  const ClientEventDetailScreen({super.key, required this.event});

  @override
  State<ClientEventDetailScreen> createState() =>
      _ClientEventDetailScreenState();
}

class _ClientEventDetailScreenState extends State<ClientEventDetailScreen> {
  int _selectedTab = 0;

  // Sheet scroll controller — handles both drag and list pagination
  ScrollController? _sheetScrollController;

  // Search
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _isDebouncing = false;

  @override
  void initState() {
    super.initState();
    _setupSearchListener();
    context
        .read<ClientEventsCubit>()
        .getEventDetails(widget.event.id.toString());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _sheetScrollController?.removeListener(_onSheetScroll);
    super.dispose();
  }

  // ── Search ───────────────────────────────────────────────────────────────

  void _setupSearchListener() {
    _searchController.addListener(() {
      _debounceTimer?.cancel();
      if (mounted) setState(() => _isDebouncing = true);

      _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() => _isDebouncing = false);

        final query = _searchController.text.trim();
        final cubit = context.read<ClientEventsCubit>();

        if (query.isNotEmpty) {
          cubit.searchMessageStatus(
            eventId: widget.event.id.toString(),
            searchQuery: query,
          );
        } else {
          cubit.clearSearch();
          cubit.getClientMessagesStatus(widget.event.id.toString());
        }
      });
    });
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();
    if (mounted) setState(() => _isDebouncing = false);
    final cubit = context.read<ClientEventsCubit>();
    cubit.clearSearch();
    cubit.getClientMessagesStatus(widget.event.id.toString());
  }

  // ── Sheet scroll / pagination ────────────────────────────────────────────

  /// Called once when the DraggableScrollableSheet provides its controller.
  void _updateSheetController(ScrollController controller) {
    if (_sheetScrollController == controller) return;
    _sheetScrollController?.removeListener(_onSheetScroll);
    _sheetScrollController = controller;
    _sheetScrollController!.addListener(_onSheetScroll);
  }

  void _onSheetScroll() {
    final ctrl = _sheetScrollController;
    if (ctrl == null || !ctrl.hasClients) return;
    if (ctrl.position.pixels < ctrl.position.maxScrollExtent - 100) return;

    final cubit = context.read<ClientEventsCubit>();
    if (_selectedTab == 0 && cubit.hasMoreDetails) {
      cubit.getEventDetails(widget.event.id.toString(), isNextPage: true);
    } else if (_selectedTab == 1 && cubit.hasMoreMessages) {
      cubit.getClientMessagesStatus(widget.event.id.toString(),
          isNextPage: true);
    }
  }

  // ── Tab switching ────────────────────────────────────────────────────────

  void _switchTab(int tab) {
    if (_selectedTab == tab) return;

    // Clear search when leaving messages tab
    if (_selectedTab == 1) {
      _debounceTimer?.cancel();
      _searchController.clear();
      context.read<ClientEventsCubit>().clearSearch();
      if (mounted) setState(() => _isDebouncing = false);
    }

    setState(() => _selectedTab = tab);

    final cubit = context.read<ClientEventsCubit>();
    if (tab == 0) {
      cubit.getEventDetails(widget.event.id.toString());
    } else {
      cubit.getClientMessagesStatus(widget.event.id.toString());
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientEventsCubit, ClientEventsStates>(
      builder: (context, state) {
        final isLoading = state is Loading;

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const CustomLoadingIndicator(),
          color: Colors.black,
          opacity: 0.5,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: recordsAppBar(context, widget.event.eventTitle ?? ""),
            body: Container(
              decoration: BoxDecoration(gradient: AppColor.greenGradient),
              child: Stack(
                children: [
                  // ── Event card pinned at the top of the gradient ─────────
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ClientEventDetailsCard(event: widget.event),
                  ),

                  // ── Draggable white sheet ────────────────────────────────
                  DraggableScrollableSheet(
                    initialChildSize: 0.67,
                    minChildSize: 0.45,
                    maxChildSize: 1.0,
                    builder: (context, scrollController) {
                      _updateSheetController(scrollController);

                      return Container(
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(containerRadius),
                            topRight: Radius.circular(containerRadius),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Drag handle — dragging here moves the sheet
                            DragHandle(),
                            SizedBox(height: edge * 0.4),

                            Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: edge),
                              child: Row(
                                children: [
                                  TitleText(
                                    text: "invited".tr(),
                                    color: AppColor.primaryColor,
                                    fontSize: 24,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: edge * 0.6),

                            // Tab buttons
                            Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: edge),
                              child: Row(
                                children: [
                                  ClientTabButton(
                                    label: "attended_count".tr(),
                                    isSelected: _selectedTab == 0,
                                    onTap: () => _switchTab(0),
                                  ),
                                  SizedBox(width: edge * 0.4),
                                  ClientTabButton(
                                    label: "messages".tr(),
                                    isSelected: _selectedTab == 1,
                                    onTap: () => _switchTab(1),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: edge * 0.5),

                            // Tab content
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: edge),
                                child: _buildContent(state, scrollController),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
      ClientEventsStates state, ScrollController scrollController) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(), // ModalProgressHUD handles this
      emptyInput: () => const EmptyWidget(),
      error: (msg) => Center(child: TitleText(text: msg, color: Colors.red)),
      success: (response, isLoadingMore) {
        if (_selectedTab == 0 && response is ClientEventDetailsResponse) {
          return ClientAttendanceList(
            items: response.eventDetailsList ?? [],
            isLoadingMore: isLoadingMore,
            scrollController: scrollController,
          );
        }
        if (_selectedTab == 1 && response is ClientMessagesStatusResponse) {
          return ClientMessagesList(
            items: response.clientMessagesDetailsList ?? [],
            isLoadingMore: isLoadingMore,
            scrollController: scrollController,
            searchController: _searchController,
            isDebouncing: _isDebouncing,
            onClear: _clearSearch,
          );
        }
        // Brief type mismatch during tab switch
        return Center(child: Loader(color: AppColor.primaryColor));
      },
    );
  }
}