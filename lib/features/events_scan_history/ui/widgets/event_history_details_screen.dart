import 'dart:io';

import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/widgets/custom_button.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/public_methods.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/public_app_bar.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../../generated/assets.dart';
import '../../data/models/event_details_response.dart';
import '../../data/models/gatekeeper_events_response.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import '../../logic/scan_history_states.dart';
import 'camera_screen.dart';
import 'event_details_item.dart';
import 'get_gatekeeper_position.dart';
import 'scan_details_header.dart';

class EventHistoryDetailsScreen extends StatefulWidget {
  final EventsList? event;
  final bool showBottomBar;

  const EventHistoryDetailsScreen(
      {super.key, required this.event, this.showBottomBar = true});

  @override
  State<EventHistoryDetailsScreen> createState() =>
      _EventHistoryDetailsScreenState();
}

class _EventHistoryDetailsScreenState extends State<EventHistoryDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  /// 0 = All, 1 = Attended (allowed), 2 = Not Attending (declined)
  int _selectedTabIndex = 0;
  bool? _hasCheckedIn;
  bool _isLoadingStatus = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // ✅ Fix: call once here, not inside BlocBuilder
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GatekeeperEventsCubit>()
          .getEventDetails(widget.event?.id.toString() ?? "0");
    });
    _loadCheckInStatus();
  }

  Future<void> _loadCheckInStatus() async {
    try {
      final status = await context
          .read<GatekeeperEventsCubit>()
          .hasCheckedIn(widget.event?.id.toString() ?? "0");
      if (mounted) {
        setState(() {
          _hasCheckedIn = status;
          _isLoadingStatus = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasCheckedIn = false;
          _isLoadingStatus = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  List<EventDetails> _filterEvents(List<EventDetails> events) {
    switch (_selectedTabIndex) {
      case 1:
        return events
            .where((e) => e.responseCode?.toLowerCase() == 'allowed')
            .toList();
      case 2:
        return events
            .where((e) => e.responseCode?.toLowerCase() != 'allowed')
            .toList();
      default:
        return events;
    }
  }

  Future<void> _handleCheckIn() async {
    try {
      if (_hasCheckedIn == true) {
        context.showErrorToast("already_checked_in".tr());
        return;
      }

      if (!_isWithinEventTimeWindow(widget.event!)) {
        context.showErrorToast("checking_not_validated".tr());
        return;
      }

      if (!mounted) return;
      final position = await _getValidatedPosition();
      if (position == null) {
        if (mounted) {
          context.showErrorToast("location_permission_denied_short".tr());
        }
        return;
      }

      if (!mounted) return;
      final image = await Navigator.push<XFile>(
        context,
        MaterialPageRoute(builder: (_) => const CameraScreen()),
      );

      if (image != null && mounted) {
        await context.read<GatekeeperEventsCubit>().eventCheckIn(
              widget.event!.id.toString(),
              position,
              image,
            );
      }
    } catch (e) {
      if (mounted) context.showErrorToast(e.toString());
    }
  }

  // ── Check-out logic (same as dialog) ──────────────────────────────────────
  Future<void> _handleCheckOut() async {
    try {
      if (_hasCheckedIn != true) {
        context.showErrorToast("must_check_in_first".tr());
        return;
      }

      if (!_isWithinEventTimeWindow(widget.event!)) {
        context.showErrorToast("checkout_not_validated".tr());
        return;
      }

      final position = await _getValidatedPosition();
      if (position == null) return;

      if (mounted) {
        await context.read<GatekeeperEventsCubit>().eventCheckOut(
              widget.event!.id.toString(),
              position,
            );
      }
    } catch (e) {
      if (mounted) context.showErrorToast(e.toString());
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  bool _isWithinEventTimeWindow(EventsList event) {
    final start =
        getDateTimeFromString(event.eventFrom ?? DateTime.now().toString());
    final end =
        getDateTimeFromString(event.eventTo ?? DateTime.now().toString());
    final startWindow = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endWindow = DateTime(end.year, end.month, end.day, 23, 59, 59);
    final now = DateTime.now();
    return now.isAfter(startWindow) && now.isBefore(endWindow) ||
        now.isAtSameMomentAs(startWindow) ||
        now.isAtSameMomentAs(endWindow);
  }

  Future<Position?> _getValidatedPosition() async {
    final position = await LocationService.getPosition(context);
    if (position.latitude == -1 || position.longitude == -1) return null;
    return position;
  }

  // ── State listener (same as dialog's _handleStateChanges) ─────────────────
  void _handleStateChanges(BuildContext context, ScanHistoryStates state) {
    state.whenOrNull(
      errorCheck: (error) {
        context.showErrorToast(error);
      },
      successCheck: (response) {
        final res = response as String;
        if (res.contains("In")) {
          setState(() => _hasCheckedIn = true);
          if (Platform.isIOS) context.pop();
          context.showSuccessToast("check_in_successful".tr());
        } else if (res.contains("Out")) {
          setState(() => _hasCheckedIn = false);
          context.showSuccessToast("check_out_successful".tr());
        } else {
          context.showSuccessToast(res);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: recordsAppBar(context, 'event_details'.tr()),
      body: Container(
        decoration: BoxDecoration(gradient: AppColor.greenGradient),
        // ✅ BlocConsumer replaces BlocBuilder to handle listener side effects
        child: BlocConsumer<GatekeeperEventsCubit, ScanHistoryStates>(
          buildWhen: (previous, current) =>
              current is EmptyInputScanHistory ||
              current is LoadingScanHistory ||
              current is SuccessScanHistory ||
              current is ErrorScanHistory,
          listenWhen: (previous, current) =>
              current is ErrorCheck ||
              current is SuccessCheck ||
              current is LoadingCheckOut ||
              current is LoadingCheckIn,
          listener: _handleStateChanges,
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              errorCheck: (error) => const SizedBox.shrink(),
              successCheck: (success) => const SizedBox.shrink(),
              loadingDeleteEvent: () => const SizedBox.shrink(),
              successDeleteEvent: (success) => const SizedBox.shrink(),
              errorDeleteEvent: (error) => const SizedBox.shrink(),
              loadingCheckOut: () =>
                  Center(child: Loader(color: whiteTextColor)),
              loadingCheckIn: () =>
                  const Center(child: Loader(color: whiteTextColor)),
              emptyInput: () => Container(
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(containerRadius),
                    topRight: Radius.circular(containerRadius),
                  ),
                ),
                child: Column(
                  children: [
                    ScanDetailsHeader(
                      event: widget.event, // ✅ uses passed parameter
                      selectedTabIndex: _selectedTabIndex,
                      onTabChanged: (tabIndex) {
                        setState(() => _selectedTabIndex = tabIndex);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: edge),
                          child: TitleText(
                            text: "no_event_details_yet".tr(),
                            color: AppColor.primaryColor,
                            align: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              error: (error) => _buildCenteredMessage(error),
              loading: () => const Center(child: Loader(color: whiteTextColor)),
              success: (response, isLoadingMore) {
                final allEvents = response.eventDetailsList ?? [];
                final filteredEvents = _filterEvents(allEvents);

                if (allEvents.isEmpty) {
                  return _buildCenteredMessage("no_event_details_yet".tr());
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
                    itemCount: filteredEvents.length + (isLoadingMore ? 2 : 1),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ScanDetailsHeader(
                          event: widget.event,
                          selectedTabIndex: _selectedTabIndex,
                          onTabChanged: (tabIndex) {
                            setState(() => _selectedTabIndex = tabIndex);
                          },
                        );
                      }
                      if (index == filteredEvents.length + 1 && isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Loader(color: AppColor.primaryColor),
                          ),
                        );
                      }
                      return EventDetailsItem(
                        eventDetails: filteredEvents[index - 1],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: widget.showBottomBar
          ? BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
              buildWhen: (previous, current) =>
                  current is LoadingCheckIn ||
                  current is LoadingCheckOut ||
                  current is SuccessCheck ||
                  current is ErrorCheck ||
                  current is EmptyInputScanHistory ||
                  current is ErrorScanHistory ||
                  current is SuccessScanHistory || // ← ADD THIS
                  current is LoadingScanHistory, // ← ADD THIS
              builder: (context, state) {
                return state.maybeWhen(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  // hide during initial load
                  orElse: () => _buildBottomBar(context, state),
                );
              },
            )
          : null,
    );
  }

  // ── Bottom bar UI (new design, wired to moved logic) ──────────────────────
  Widget _buildBottomBar(BuildContext context, ScanHistoryStates state) {
    final bool isCheckInLoading = state is LoadingCheckIn;
    final bool isCheckOutLoading = state is LoadingCheckOut;
    final bool anyLoading =
        isCheckInLoading || isCheckOutLoading || _isLoadingStatus;

    if (_isLoadingStatus) {
      return Container(
        color: AppColor.whiteColor,
        padding: EdgeInsets.symmetric(vertical: edge * 0.7, horizontal: edge),
        child: Center(
          child: CircularProgressIndicator(color: AppColor.primaryColor),
        ),
      );
    }

    final bool isCheckedIn = _hasCheckedIn == true;

    return Container(
      color: AppColor.whiteColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(edge, edge * 0.7, edge, edge * 0.7),
        child: Row(
          children: [
            Expanded(
              // ✅ Switch to CustomButton.loading() when operation is in progress
              child: (isCheckInLoading || isCheckOutLoading)
                  ? CustomButton.loading(
                      text: (isCheckedIn ? "check_out" : "check_in").tr(),
                      color: AppColor.lightPrimaryColor,
                      textColor: AppColor.primaryColor,
                    )
                  : CustomButton.withIcon(
                      text: (isCheckedIn ? "check_out" : "check_in").tr(),
                      color: AppColor.lightPrimaryColor,
                      textColor: AppColor.primaryColor,
                      onPressed: anyLoading
                          ? null
                          : (isCheckedIn ? _handleCheckOut : _handleCheckIn),
                      svgIconPath:
                          isCheckedIn ? Assets.svgsLogout : Assets.svgsLogin,
                    ),
            ),
            SizedBox(width: edge * 0.4),
            Expanded(
              child: CustomButton.withIcon(
                text: "scan_qr".tr(),
                color: AppColor.primaryColor,
                textColor: AppColor.whiteColor,
                onPressed: anyLoading
                    ? null
                    : () async {
                        await context.pushNamed(Routes.qrCodeScreen);
                        if (!context.mounted) return;

                        context.read<GatekeeperEventsCubit>().getEventDetails(
                              widget.event?.id.toString() ?? "0",
                            );
                      },
                svgIconPath: Assets.imagesQrcode,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final cubit = context.read<GatekeeperEventsCubit>();
      if (cubit.hasMoreDetails) {
        cubit.getEventDetails(
          widget.event?.id.toString() ?? "0",
          isNextPage: true,
        );
      }
    }
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
