import 'dart:io';

import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/public_methods.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../data/models/gatekeeper_events_response.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import '../../logic/scan_history_states.dart';
import 'camera_screen.dart';
import 'get_gatekeeper_position.dart';

class EventCheckDialogBox extends StatefulWidget {
  final EventsList event;

  const EventCheckDialogBox({super.key, required this.event});

  @override
  State<EventCheckDialogBox> createState() => _EventCheckDialogBoxState();
}

class _EventCheckDialogBoxState extends State<EventCheckDialogBox> {
  bool? _hasCheckedIn;
  bool _isLoadingStatus = true;

  @override
  void initState() {
    super.initState();
    _loadCheckInStatus();
  }

  Future<void> _loadCheckInStatus() async {
    try {
      final status = await context
          .read<GatekeeperEventsCubit>()
          .hasCheckedIn(widget.event.id.toString());
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
      debugPrint('Error loading check-in status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GatekeeperEventsCubit, ScanHistoryStates>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) =>
          current is ErrorCheck ||
          current is SuccessCheck ||
          current is LoadingCheckOut ||
          current is LoadingCheckIn,
      builder: (context, state) => _buildDialog(context, state),
      listener: _handleStateChanges,
    );
  }

  Widget _buildDialog(BuildContext context, ScanHistoryStates state) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade200,
      title: _buildDialogTitle(state),
      content: _buildDialogContent(),
      actions: [
        _buildActionButtons(context, state),
      ],
    );
  }

  Widget _buildDialogTitle(ScanHistoryStates state) {
    final bool anyLoading = state is LoadingCheckIn || state is LoadingCheckOut;

    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              ),
              onPressed: anyLoading ? null : () => context.pop(),
            ),
          ),
        ),
        const Icon(Icons.check_circle, color: primaryColor, size: 60),
        const SizedBox(height: 12),
        TitleText(
          text: "event_check".tr(),
          color: Colors.grey.shade900,
          fontSize: 20,
        ),
      ],
    );
  }

  Widget _buildDialogContent() {
    final String hintText = (_hasCheckedIn ?? false)
        ? "event_check_out_hint".tr()
        : "event_check_in_hint".tr();

    return NormalText(
      text: hintText,
      fontSize: 16,
      color: Colors.grey.shade900,
    );
  }

  Widget _buildActionButtons(BuildContext context, ScanHistoryStates state) {
    final bool isCheckInLoading = state is LoadingCheckIn;
    final bool isCheckOutLoading = state is LoadingCheckOut;
    final bool anyProcessing =
        isCheckInLoading || isCheckOutLoading || _isLoadingStatus;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildCheckInButton(
            context,
            state,
            enable: !anyProcessing,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildCheckOutButton(
            context,
            state,
            enable: !anyProcessing,
          ),
        ),
      ],
    );
  }

  // ============================================
  // CHECK-IN BUTTON
  // ============================================
  Widget _buildCheckInButton(
    BuildContext context,
    ScanHistoryStates state, {
    required bool enable,
  }) {
    final bool isLoading = state is LoadingCheckIn;

    return GoButton(
      fun: () async => await _handleCheckIn(context),
      titleKey: "check_in".tr(),
      textColor: Colors.white,
      btColor: primaryColor,
      loading: isLoading,
      loaderColor: Colors.white,
      enable: enable,
    );
  }

  // ============================================
  // CHECK-OUT BUTTON
  // ============================================
  Widget _buildCheckOutButton(
    BuildContext context,
    ScanHistoryStates state, {
    required bool enable,
  }) {
    final bool isLoading = state is LoadingCheckOut;

    return GoButton(
      fun: () async => await _handleCheckOut(context),
      titleKey: "check_out".tr(),
      textColor: Colors.white,
      btColor: Colors.red,
      loading: isLoading,
      loaderColor: Colors.white,
      enable: enable,
    );
  }

  // ============================================
  // CHECK-IN LOGIC (COMPLETELY SEPARATED)
  // ============================================
  Future<void> _handleCheckIn(BuildContext context) async {
    try {
      if (_hasCheckedIn == true) {
        if (mounted) {
          context.showErrorToast("already_checked_in".tr());
        }
        return;
      }

      // Step 2: Validate time window
      if (!_isWithinEventTimeWindow(widget.event)) {
        if (mounted) {
          context.pop();
          context.showErrorToast("checking_not_validated".tr());
        }
        return;
      }

      // Step 3: Get and validate location
      if (!mounted) return;
      final position = await _getValidatedPosition(context);
      if (position == null) {
        if (!context.mounted) return;
        context.showErrorToast("location_permission_denied_short".tr());
        return;
      }
      if (!context.mounted) return;

      final image = await Navigator.push<XFile>(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );

      // Step 5: Process check-in if photo was taken
      if (image != null && context.mounted) {
        await context.read<GatekeeperEventsCubit>().eventCheckIn(
              widget.event.id.toString(),
              position,
              image,
            );
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorToast(e.toString());
      }
    }
  }

  // ============================================
  // CHECK-OUT LOGIC (COMPLETELY SEPARATED)
  // ============================================
  Future<void> _handleCheckOut(BuildContext context) async {
    try {
      if (_hasCheckedIn != true) {
        if (context.mounted) {
          context.showErrorToast("must_check_in_first".tr());
        }

        return;
      }

      // Step 2: Validate time window
      if (!_isWithinEventTimeWindow(widget.event)) {
        if (context.mounted) {
          context.pop();
          context.showErrorToast("checkout_not_validated".tr());
        }

        return;
      }

      // Step 3: Get and validate location
      final position = await _getValidatedPosition(context);
      if (position == null) {
        return;
      }

      // Step 4: Process check-out
      if (context.mounted) {
        await context.read<GatekeeperEventsCubit>().eventCheckOut(
              widget.event.id.toString(),
              position,
            );

        // Dialog will be popped in _handleStateChanges when SuccessCheck is received
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorToast(e.toString());
      }
    }
  }

  bool _isWithinEventTimeWindow(EventsList event) {
    final DateTime start =
        getDateTimeFromString(event.eventFrom ?? DateTime.now().toString());
    final DateTime end =
        getDateTimeFromString(event.eventTo ?? DateTime.now().toString());

    final startWindow = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endWindow = DateTime(end.year, end.month, end.day, 23, 59, 59);

    final now = DateTime.now();

    return now.isAfter(startWindow) && now.isBefore(endWindow) ||
        now.isAtSameMomentAs(startWindow) ||
        now.isAtSameMomentAs(endWindow);
  }

  Future<Position?> _getValidatedPosition(BuildContext context) async {
    final position = await LocationService.getPosition(context);
    if (position.latitude == -1 || position.longitude == -1) {
      if (context.mounted) {
        context.pop();
      }
      return null;
    }
    return position;
  }

  void _handleStateChanges(BuildContext context, ScanHistoryStates state) {
    state.whenOrNull(
      errorCheck: (error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pop();
          context.showErrorToast(error);
        });
      },
      successCheck: (response) {
        debugPrint('Success state received: $response'); // Debug log
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Update check-in status on success
          if (response.contains("In")) {
            setState(() => _hasCheckedIn = true);
          } else if (response.contains("Out")) {
            setState(() => _hasCheckedIn = false);
          }

          context.pop();
          _handleSuccessResponse(context, response);
        });
      },
    );
  }

  void _handleSuccessResponse(BuildContext context, String response) {
    if (response.contains("In")) {
      if (Platform.isIOS) {
        context.pop();
      }
      context.showSuccessToast("check_in_successful".tr());
    } else if (response.contains("Out")) {
      context.showSuccessToast("check_out_successful".tr());
    } else {
      context.showSuccessToast(response);
    }
  }
}
