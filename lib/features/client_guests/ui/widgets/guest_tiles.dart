import 'package:app/core/theming/typography_theme.dart';
// intl (re-exported by easy_localization) has its own TextDirection
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/phone_number_helper.dart';
import '../../../../core/theming/colors.dart';
import '../../data/models/draft_guest.dart';
import '../../data/models/event_guests_response.dart';
import '../../data/models/guest_title.dart';
import '../../logic/manage_guests_cubit.dart';

/// A guest already on the list: editable, or locked. The backend's isLocked
/// is the only source (true once anything was ever sent, even after a reset).
class ServerGuestTile extends StatelessWidget {
  const ServerGuestTile({
    super.key,
    required this.guest,
    required this.canEdit,
    required this.onTap,
  });

  final ClientGuest guest;
  final bool canEdit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locked = guest.isLocked ?? false;
    return _TileFrame(
      onTap: onTap,
      background: locked ? AppColor.gray50 : Colors.white,
      border: Border.all(color: AppColor.gray100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: GuestNameText(fullName: guest.name ?? '')),
              if (locked)
                const _SentBadge()
              else if (canEdit)
                const Icon(Icons.edit_outlined,
                    size: 16, color: AppColor.gray500),
            ],
          ),
          SizedBox(height: edge * 0.2),
          GuestPhoneText(digits: guest.phoneDigits),
        ],
      ),
    );
  }
}

/// A guest still in the local draft (dashed look), with the last add error.
class DraftGuestTile extends StatelessWidget {
  const DraftGuestTile({super.key, required this.row, required this.onTap});

  final DraftGuest row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final digits = row.phoneDigits;
    final error = row.hasError
        ? ManageGuestsCubit.messageFor(row.errorCode!)
        : digits == null
            ? 'guests_phone_needs_code'.tr()
            : null;
    return _TileFrame(
      onTap: onTap,
      background: Colors.white,
      border: Border.all(
        color: error != null ? AppColor.semanticError : AppColor.gray300,
        width: error != null ? 1.5 : 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: GuestNameText(fullName: row.fullName)),
              if (row.noOfMembers > 1)
                Text('guests_members_count'.tr(args: ['${row.noOfMembers}']),
                    style: context.typography.labelSmall),
            ],
          ),
          SizedBox(height: edge * 0.2),
          digits != null
              ? GuestPhoneText(digits: digits)
              : Text(row.phoneInput,
                  textDirection: TextDirection.ltr,
                  style: context.typography.numericSmall
                      .copyWith(color: AppColor.gray500, fontSize: 12)),
          if (error != null) ...[
            SizedBox(height: edge * 0.2),
            Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 14, color: AppColor.semanticError),
                SizedBox(width: edge * 0.2),
                Expanded(
                  child: Text(error,
                      style: context.typography.labelMedium
                          .copyWith(color: AppColor.semanticError)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Full name with a known title shown lighter than the name.
class GuestNameText extends StatelessWidget {
  const GuestNameText({super.key, required this.fullName});

  final String fullName;

  @override
  Widget build(BuildContext context) {
    final (title, name) = GuestTitles.split(fullName);
    final style =
        context.typography.titleSmall.copyWith(color: AppColor.primaryDark);
    if (title.kind == GuestTitleKind.none) return Text(fullName, style: style);
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: '${title.text} ',
          style: style.copyWith(
              fontWeight: FontWeight.w300, color: AppColor.gray600),
        ),
        TextSpan(text: name, style: style),
      ]),
    );
  }
}

/// International number, always left to right.
class GuestPhoneText extends StatelessWidget {
  const GuestPhoneText({super.key, required this.digits});

  final String digits;

  @override
  Widget build(BuildContext context) {
    return Text(
      PhoneNumberHelper.formatInternational(digits),
      textDirection: TextDirection.ltr,
      style: context.typography.numericSmall
          .copyWith(color: AppColor.gray500, fontSize: 12),
    );
  }
}

class _SentBadge extends StatelessWidget {
  const _SentBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: edge * 0.15, horizontal: edge * 0.45),
      decoration: BoxDecoration(
        color: AppColor.primaryDark.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radiusInput),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline_rounded,
              size: 11, color: AppColor.primaryDark),
          SizedBox(width: edge * 0.15),
          Text('guests_badge_sent'.tr(),
              style: context.typography.labelSmall
                  .copyWith(color: AppColor.primaryDark)),
        ],
      ),
    );
  }
}

class _TileFrame extends StatelessWidget {
  const _TileFrame({
    required this.child,
    required this.onTap,
    required this.background,
    required this.border,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color background;
  final BoxBorder border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: edge * 0.4),
        padding:
            EdgeInsets.symmetric(horizontal: edge * 0.7, vertical: edge * 0.5),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radiusInput),
          border: border,
        ),
        child: child,
      ),
    );
  }
}
