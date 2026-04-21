import 'dart:async';

import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/custom_loading_indicator.dart';
import 'package:app/core/widgets/drag_handle.dart';
import 'package:app/core/widgets/empty_widget.dart';
import 'package:app/core/widgets/loader.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/text_field_with_icon.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/dimensions/dimensions_constants.dart';
import '../../../../../core/widgets/public_app_bar.dart';
import '../../../../new_client_events/ui/widgets/client_message_item.dart';
import '../../../data/models/guest_type_list.dart';
import '../../../logic/client_statistics_cubit.dart';
import '../../../logic/client_statistics_states.dart';

class ClientMessageStatus extends StatefulWidget {
  final String eventId;
  final GuestListType type;
  final String title;

  const ClientMessageStatus({
    super.key,
    required this.eventId,
    required this.type,
    required this.title,
  });

  @override
  State<ClientMessageStatus> createState() => _ClientMessageStatusState();
}

class _ClientMessageStatusState extends State<ClientMessageStatus> {
  ScrollController? _sheetScrollController;
  Timer? _debounceTimer;
  bool _isDebouncing = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupSearchListener();
    context
        .read<ClientStatisticsCubit>()
        .getClientMessagesStatus(widget.eventId, widget.type);
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
        final cubit = context.read<ClientStatisticsCubit>();

        if (query.isNotEmpty) {
          cubit.searchMessageStatus(
            eventId: widget.eventId,
            searchQuery: query,
            type: widget.type,
          );
        } else {
          cubit.clearSearch();
          cubit.getClientMessagesStatus(widget.eventId, widget.type);
        }
      });
    });
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();
    if (mounted) setState(() => _isDebouncing = false);
    final cubit = context.read<ClientStatisticsCubit>();
    cubit.clearSearch();
    cubit.getClientMessagesStatus(widget.eventId, widget.type);
  }

  // ── Scroll / pagination ──────────────────────────────────────────────────

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

    final cubit = context.read<ClientStatisticsCubit>();
    if (cubit.hasMoreMessages) {
      cubit.getClientMessagesStatus(
        widget.eventId,
        widget.type,
        isNextPage: true,
      );
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientStatisticsCubit, ClientStatisticsStates>(
      builder: (context, state) {
        final isLoading = state is Loading;

        final totalCount = state.maybeWhen(
          success: (response, _) =>
          response.clientMessagesDetailsList?.length ?? 0,
          orElse: () => 0,
        );

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: const CustomLoadingIndicator(),
            color: Colors.black,
            opacity: 0.5,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: recordsAppBar(context, widget.title),
              body: Container(
                decoration: BoxDecoration(gradient: AppColor.greenGradient),
                child: Stack(
                  children: [
                    // ── Summary card pinned at top of gradient ───────────
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _SummaryCard(
                        title: widget.title,
                        count: totalCount,
                      ),
                    ),

                    // ── Draggable white sheet ────────────────────────────
                    DraggableScrollableSheet(
                      initialChildSize: 0.85,
                      minChildSize: 0.7,
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
                              DragHandle(),
                              SizedBox(height: edge * 0.2),

                              // ── Search field ─────────────────────────
                              Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: edge),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: textFieldWithIcon(
                                        icon: _isDebouncing
                                            ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child:
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                            : const Icon(Icons.search,
                                            color: AppColor.primaryColor),
                                        hint: "name/phone number".tr(),
                                        controller: _searchController,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        backgroundColor: AppColor.primaryColor,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: _clearSearch,
                                      child: NormalText(
                                        text: "clear".tr(),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: edge * 0.5),

                              // ── List ─────────────────────────────────
                              Expanded(
                                child: _buildContent(state, scrollController),
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
          ),
        );
      },
    );
  }

  Widget _buildContent(
      ClientStatisticsStates state, ScrollController scrollController) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(), // ModalProgressHUD handles this
      successFetchData: (_) => const SizedBox.shrink(),
      emptyInput: () => const EmptyWidget(),
      error: (msg) => Center(child: TitleText(text: msg, color: Colors.red)),
      success: (response, isLoadingMore) {
        final items = response.clientMessagesDetailsList ?? [];
        if (items.isEmpty) return const EmptyWidget();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: edge),
          child: ListView.separated(
            controller: scrollController,
            itemCount: items.length + (isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => SizedBox(height: edge * 0.5),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(edge * 0.5),
                    child: Loader(color: AppColor.primaryColor),
                  ),
                );
              }
              return ClientMessageItem(item: items[index]);
            },
          ),
        );
      },
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;

  const _SummaryCard({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: edge * 0.8,
        vertical: edge * 0.8,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColor.whiteColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.people, color: AppColor.whiteColor, size: 26),
            ),
          ),
          SizedBox(width: edge * 0.7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                  text: title,
                  color: AppColor.whiteColor,
                  fontSize: 18,
                  align: TextAlign.start,
                ),
                SizedBox(height: edge * 0.2),
                NormalText(
                  text: 'guests_count'.tr(args: [count.toString()]),
                  color: AppColor.whiteColor.withValues(alpha: 0.8),
                  fontSize: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}