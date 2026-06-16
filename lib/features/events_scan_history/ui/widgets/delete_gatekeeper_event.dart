import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/app_typography.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/gatekeeper_events_response.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import '../../logic/scan_history_states.dart';

class DeleteGatekeeperEventDialogBox extends StatefulWidget {
  final EventsList event;

  const DeleteGatekeeperEventDialogBox({super.key, required this.event});

  @override
  State<DeleteGatekeeperEventDialogBox> createState() =>
      _EventCheckDialogBoxState();
}

class _EventCheckDialogBoxState
    extends State<DeleteGatekeeperEventDialogBox> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GatekeeperEventsCubit, ScanHistoryStates>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) =>
          current is LoadingDeleteEvent ||
          current is SuccessDeleteEvent ||
          current is ErrorDeleteEvent,
      builder: (context, state) => _buildDialog(context, state),
      listener: (context, current) {
        if (current is SuccessDeleteEvent) {
          context.pop();
          context.showSuccessToast('delete_event_successfully'.tr());
        } else if (current is ErrorDeleteEvent) {
          context.pop();
          context.showErrorToast('delete_event_failed'.tr());
        }
      },
    );
  }

  Widget _buildDialog(BuildContext context, ScanHistoryStates state) {
    return AlertDialog(
      backgroundColor: AppColor.primaryLight,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: _buildDialogTitle(),
      content: _buildDialogContent(widget.event.eventTitle ?? ''),
      actions: [_buildActionButtons(context, state)],
    );
  }

  Widget _buildDialogTitle() {
    return Column(
      children: [
        const SizedBox(height: 4),
        const Icon(Icons.delete_outline,
            color: AppColor.semanticError, size: 48),
        const SizedBox(height: 12),
        Text(
          'delete_gatekeeper_event_title'.tr(),
          style: AppTextStyles.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDialogContent(String eventName) {
    return Text(
      'delete_gatekeeper_event_message'.tr(args: [eventName]),
      style: AppTextStyles.bodyMedium.copyWith(color: AppColor.gray700),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButtons(BuildContext context, ScanHistoryStates state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GoButton(
            fun: () {
              context
                  .read<GatekeeperEventsCubit>()
                  .deleteEvent(widget.event.id.toString());
            },
            titleKey: 'delete'.tr(),
            textColor: AppColor.primaryLight,
            btColor: AppColor.semanticError,
            loading: state is LoadingDeleteEvent,
            loaderColor: AppColor.primaryLight,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GoButton(
            fun: () => context.pop(),
            titleKey: 'cancel'.tr(),
            textColor: AppColor.primaryLight,
            btColor: AppColor.primaryDark,
          ),
        ),
      ],
    );
  }
}
