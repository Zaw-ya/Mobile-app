import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
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

class _EventCheckDialogBoxState extends State<DeleteGatekeeperEventDialogBox> {
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
          context.showSuccessToast("delete_event_successfully".tr());
        } else if (current is ErrorDeleteEvent) {
          context.pop();
          context.showErrorToast("delete_event_failed".tr());
        }
      },
    );
  }

  Widget _buildDialog(BuildContext context, ScanHistoryStates state) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade200,
      title: _buildDialogTitle(),
      content: _buildDialogContent(widget.event.eventTitle ?? ""),
      actions: [
        _buildActionButtons(context, state),
      ],
    );
  }

  Widget _buildDialogTitle() {
    return Column(
      children: [
        const SizedBox(height: 12),
        TitleText(
          text: "delete_gatekeeper_event_title".tr(),
          color: AppColor.gray800,
          fontSize: 20,
        ),
      ],
    );
  }

  Widget _buildDialogContent(String eventName) {
    return NormalText(
      text: "delete_gatekeeper_event_message".tr(args: [eventName]),
      fontSize: 16,
      color: AppColor.gray800,
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
            titleKey: "delete".tr(),
            textColor: Colors.white,
            btColor: AppColor.primaryColor,
            loading: state is LoadingDeleteEvent,
            loaderColor: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GoButton(
            fun: () {
              context.pop();
            },
            titleKey: "cancel".tr(),
            textColor: Colors.white,
            btColor: AppColor.mainRed,
          ),
        ),
      ],
    );
  }
}
