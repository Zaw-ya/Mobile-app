import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/phone_number_helper.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/drag_handle.dart';
import '../../client_guests_flags.dart';
import '../../data/models/event_guests_response.dart';
import 'guest_tiles.dart';

/// View-only details of a guest: already sent an invitation, or the edit
/// deadline has passed. Changes go through the operations team.
class LockedGuestSheet extends StatelessWidget {
  const LockedGuestSheet._({
    required this.guest,
    required this.isLocked,
    required this.eventId,
    required this.eventTitle,
    required this.supportWhatsappNumber,
  });

  final ClientGuest guest;
  final bool isLocked;
  final int eventId;
  final String eventTitle;
  final String? supportWhatsappNumber;

  static Future<void> show(
    BuildContext context, {
    required ClientGuest guest,
    required int eventId,
    required String eventTitle,
    required String? supportWhatsappNumber,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColor.primaryLight,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(containerRadius)),
      ),
      builder: (_) => LockedGuestSheet._(
        guest: guest,
        isLocked: guest.isLocked ?? false,
        eventId: eventId,
        eventTitle: eventTitle,
        supportWhatsappNumber: supportWhatsappNumber,
      ),
    );
  }

  Future<void> _requestEdit(BuildContext context) async {
    final message = 'guests_request_edit_msg'.tr(args: [
      eventTitle,
      '$eventId',
      guest.name ?? '',
      PhoneNumberHelper.formatInternational(guest.phoneDigits),
    ]);
    final uri = Uri.parse(
        'https://wa.me/$supportWhatsappNumber?text=${Uri.encodeComponent(message)}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!context.mounted) return;
      context.showErrorToast('whatsapp_not_installed'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final canRequest = ClientGuestsFlags.editRequestEnabled &&
        (supportWhatsappNumber ?? '').isNotEmpty;

    return SafeArea(
      // Scrolls instead of overflowing on short screens or large text
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(edge, 0, edge, edge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandle(),
            Text('guests_details_title'.tr(),
                style: context.typography.titleLarge),
            SizedBox(height: edge * 0.6),
            _ReadOnlyRow(
              label: 'guests_name'.tr(),
              child: GuestNameText(fullName: guest.name ?? ''),
            ),
            _ReadOnlyRow(
              label: 'guests_phone'.tr(),
              child: GuestPhoneText(digits: guest.phoneDigits),
            ),
            _ReadOnlyRow(
              label: 'guests_members'.tr(),
              child: Text('${guest.noOfMembers ?? 1}',
                  style: context.typography.numericSmall
                      .copyWith(color: AppColor.primaryDark)),
            ),
            SizedBox(height: edge * 0.4),
            Container(
              padding: EdgeInsets.all(edge * 0.6),
              decoration: BoxDecoration(
                color: AppColor.gray100,
                borderRadius: BorderRadius.circular(radiusInner),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 18, color: AppColor.gray700),
                  SizedBox(width: edge * 0.4),
                  Expanded(
                    child: Text(
                      isLocked
                          ? 'guests_locked_note'.tr()
                          : 'guests_closed_note'.tr(),
                      style: context.typography.bodySmall
                          .copyWith(color: AppColor.gray700),
                    ),
                  ),
                ],
              ),
            ),
            // Hidden until the owner turns it on (ClientGuestsFlags)
            if (canRequest) ...[
              SizedBox(height: edge * 0.6),
              CustomButton.normal(
                text: 'guests_request_edit'.tr(),
                color: AppColor.primaryDark,
                onPressed: () => _requestEdit(context),
              ),
            ],
            SizedBox(height: edge * 0.4),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('close'.tr(), style: context.typography.titleSmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: edge * 0.4),
      padding:
          EdgeInsets.symmetric(horizontal: edge * 0.6, vertical: edge * 0.5),
      decoration: BoxDecoration(
        color: AppColor.gray50,
        borderRadius: BorderRadius.circular(radiusInput),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.typography.inputLabel),
          SizedBox(height: edge * 0.15),
          child,
        ],
      ),
    );
  }
}
