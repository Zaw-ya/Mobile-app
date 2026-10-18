import 'dart:io';

import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/theming/typography_theme.dart';
import 'package:app/core/widgets/custom_button.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/public_app_bar.dart';
import '../../../../generated/assets.dart';
import '../../data/models/check_in_reason.dart';
import '../../data/models/check_in_status_response.dart';
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

class _EventHistoryDetailsScreenState extends State<EventHistoryDetailsScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  int _selectedTabIndex = 0;
  CheckInStatusResponse? _checkInStatus;
  bool _isLoadingStatus = true;

  // The backend decides; until the first status arrives fall back to the list value
  bool get _hasCheckedIn =>
      _checkInStatus?.isCheckedIn ?? widget.event?.isCheckedIn ?? false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GatekeeperEventsCubit>()
          .getEventDetails(widget.event?.id.toString() ?? '0');
    });
    _loadCheckInStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The shift may have ended (auto check-out) or the event may have been edited
    if (state == AppLifecycleState.resumed) _loadCheckInStatus();
  }

  Future<CheckInStatusResponse?> _loadCheckInStatus() async {
    final status = await context
        .read<GatekeeperEventsCubit>()
        .getCheckInStatus(widget.event?.id.toString() ?? '0');
    if (mounted) {
      setState(() {
        if (status != null) _checkInStatus = status;
        _isLoadingStatus = false;
      });
    }
    return status;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
      // Ask the backend first so the gatekeeper isn't sent to the camera for nothing
      final status = await _loadCheckInStatus();
      if (!mounted) return;
      if (status == null) {
        context.showErrorToast('some_error'.tr());
        return;
      }
      if (status.canCheckIn != true) {
        context.showErrorToast(CheckInReason.message(status.reasonCode));
        return;
      }
      final position = await _getValidatedPosition();
      if (position == null) {
        if (mounted) context.showErrorToast('location_permission_denied_short'.tr());
        return;
      }
      if (!mounted) return;
      final image = await Navigator.push<XFile>(
        context,
        MaterialPageRoute(builder: (_) => const CameraScreen()),
      );
      if (image != null && mounted) {
        await context.read<GatekeeperEventsCubit>().eventCheckIn(
              widget.event!.id.toString(), position, image);
      }
    } catch (e) {
      if (mounted) context.showErrorToast(e.toString());
    }
  }

  Future<void> _handleCheckOut() async {
    try {
      final status = await _loadCheckInStatus();
      if (!mounted) return;
      if (status == null) {
        context.showErrorToast('some_error'.tr());
        return;
      }
      if (status.canCheckOut != true) {
        context.showErrorToast(CheckInReason.message(status.reasonCode));
        return;
      }
      final position = await _getValidatedPosition();
      if (position == null) return;
      if (mounted) {
        await context.read<GatekeeperEventsCubit>().eventCheckOut(
              widget.event!.id.toString(), position);
      }
    } catch (e) {
      if (mounted) context.showErrorToast(e.toString());
    }
  }

  Future<Position?> _getValidatedPosition() async {
    final position = await LocationService.getPosition(context);
    if (position.latitude == -1 || position.longitude == -1) return null;
    return position;
  }

  void _handleStateChanges(BuildContext context, ScanHistoryStates state) {
    state.whenOrNull(
      errorCheck: (error) {
        context.showErrorToast(error);
        _loadCheckInStatus();
      },
      successCheck: (response) {
        final res = response as String;
        if (res.contains('In')) {
          if (Platform.isIOS) context.pop();
          context.showSuccessToast('check_in_successful'.tr());
        } else if (res.contains('Out')) {
          context.showSuccessToast('check_out_successful'.tr());
        } else {
          context.showSuccessToast(res);
        }
        _loadCheckInStatus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryDark,
      appBar: recordsAppBar(context, 'event_details'.tr()),
      body: BlocConsumer<GatekeeperEventsCubit, ScanHistoryStates>(
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
            errorCheck: (_) => const SizedBox.shrink(),
            successCheck: (_) => const SizedBox.shrink(),
            loadingDeleteEvent: () => const SizedBox.shrink(),
            successDeleteEvent: (_) => const SizedBox.shrink(),
            errorDeleteEvent: (_) => const SizedBox.shrink(),
            loadingCheckOut: () =>
                Center(child: Loader(color: AppColor.primaryLight)),
            loadingCheckIn: () =>
                Center(child: Loader(color: AppColor.primaryLight)),
            emptyInput: () => _buildInnerContainer(
              child: Column(
                children: [
                  ScanDetailsHeader(
                    event: widget.event,
                    selectedTabIndex: _selectedTabIndex,
                    onTabChanged: (i) =>
                        setState(() => _selectedTabIndex = i),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: edge),
                        child: Text(
                          'no_event_details_yet'.tr(),
                          style: context.typography.bodyMedium
                              .copyWith(color: AppColor.gray500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            error: (error) => _buildCenteredMessage(error),
            loading: () =>
                Center(child: Loader(color: AppColor.primaryLight)),
            success: (response, isLoadingMore) {
              final allEvents = response.eventDetailsList ?? [];
              final filteredEvents = _filterEvents(allEvents);

              if (allEvents.isEmpty) {
                return _buildCenteredMessage('no_event_details_yet'.tr());
              }

              return _buildInnerContainer(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: edge),
                  itemCount:
                      filteredEvents.length + (isLoadingMore ? 2 : 1),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ScanDetailsHeader(
                        event: widget.event,
                        selectedTabIndex: _selectedTabIndex,
                        onTabChanged: (i) =>
                            setState(() => _selectedTabIndex = i),
                      );
                    }
                    if (index == filteredEvents.length + 1 &&
                        isLoadingMore) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Loader(color: AppColor.primaryDark),
                        ),
                      );
                    }
                    return EventDetailsItem(
                        eventDetails: filteredEvents[index - 1]);
                  },
                ),
              );
            },
          );
        },
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
                  current is SuccessScanHistory ||
                  current is LoadingScanHistory,
              builder: (context, state) {
                return state.maybeWhen(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  orElse: () => _buildBottomBar(context, state),
                );
              },
            )
          : null,
    );
  }

  Widget _buildInnerContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(containerRadius),
          topRight: Radius.circular(containerRadius),
        ),
      ),
      child: child,
    );
  }

  Widget _buildBottomBar(BuildContext context, ScanHistoryStates state) {
    final bool isCheckInLoading = state is LoadingCheckIn;
    final bool isCheckOutLoading = state is LoadingCheckOut;
    final bool anyLoading =
        isCheckInLoading || isCheckOutLoading || _isLoadingStatus;

    if (_isLoadingStatus) {
      return Container(
        color: AppColor.primaryLight,
        padding: EdgeInsets.symmetric(
            vertical: edge * 0.7, horizontal: edge),
        child: Center(
          child:
              CircularProgressIndicator(color: AppColor.primaryDark),
        ),
      );
    }

    final bool isCheckedIn = _hasCheckedIn;

    return Container(
      color: AppColor.primaryLight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            edge, edge * 0.7, edge, edge * 0.7),
        child: Row(
          children: [
            Expanded(
              child: (isCheckInLoading || isCheckOutLoading)
                  ? CustomButton.loading(
                      text:
                          (isCheckedIn ? 'check_out' : 'check_in').tr(),
                      color: AppColor.primaryDark,
                      textColor: AppColor.primaryLight,
                    )
                  : CustomButton.withIcon(
                      text:
                          (isCheckedIn ? 'check_out' : 'check_in').tr(),
                      color: AppColor.primaryLight,
                      textColor: AppColor.primaryDark,
                      onPressed: anyLoading
                          ? null
                          : (isCheckedIn
                              ? _handleCheckOut
                              : _handleCheckIn),
                      svgIconPath: isCheckedIn
                          ? Assets.svgsLogout
                          : Assets.svgsLogin,
                    ),
            ),
            SizedBox(width: edge * 0.4),
            Expanded(
              child: CustomButton.withIcon(
                text: 'scan_qr'.tr(),
                // Scanning requires a check-in for the current shift
                color: isCheckedIn ? AppColor.primaryDark : AppColor.gray300,
                textColor: AppColor.primaryLight,
                onPressed: anyLoading
                    ? null
                    : () async {
                        if (!isCheckedIn) {
                          context.showErrorToast('must_check_in_first'.tr());
                          return;
                        }
                        await Navigator.pushNamed(
                          context,
                          Routes.qrCodeScreen,
                          arguments: widget.event!.id,
                        );
                        if (!context.mounted) return;
                        context
                            .read<GatekeeperEventsCubit>()
                            .getEventDetails(
                              widget.event?.id.toString() ?? '0',
                            );
                        _loadCheckInStatus();
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
          widget.event?.id.toString() ?? '0',
          isNextPage: true,
        );
      }
    }
  }

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: Text(
        message,
        style: context.typography.bodyMedium
            .copyWith(color: AppColor.primaryLight),
        textAlign: TextAlign.center,
      ),
    );
  }
}
