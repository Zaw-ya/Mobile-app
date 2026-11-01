import 'package:app/core/theming/typography_theme.dart';
// intl (re-exported by easy_localization) has its own TextDirection
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/helpers/extensions.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../../../core/widgets/drag_handle.dart';
import '../../../core/widgets/public_app_bar.dart';
import '../data/contacts/device_contacts_service.dart';
import '../data/models/draft_guest.dart';
import '../data/models/guest_requests.dart';
import '../logic/contacts_picker_cubit.dart';
import '../logic/contacts_picker_states.dart';
import 'contacts_review_screen.dart';

/// Picks guests from the device contacts. Pops the reviewed rows (a list of
/// DraftGuest) for the draft.
class ContactsPickerScreen extends StatefulWidget {
  const ContactsPickerScreen({super.key, required this.takenPhones});

  /// Numbers already on the list or in the draft.
  final Set<String> takenPhones;

  /// Popped when the client chooses to add a guest by hand instead.
  static const String manualResult = 'manual';

  @override
  State<ContactsPickerScreen> createState() => _ContactsPickerScreenState();
}

class _ContactsPickerScreenState extends State<ContactsPickerScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<ContactsPickerCubit>().start(widget.takenPhones);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Back from the device settings
    if (state == AppLifecycleState.resumed) {
      context.read<ContactsPickerCubit>().recheck();
    }
  }

  void _showLimit() => context.showErrorToast(
      'guests_max_batch'.tr(args: ['${AddGuestsRequest.maxBatchSize}']));

  Future<void> _onTap(ContactsPickerCubit cubit, PickedContact contact) async {
    final free = cubit.freePhones(contact);
    if (cubit.isSelected(contact) || free.length < 2) {
      if (!cubit.toggle(contact)) _showLimit();
      return;
    }
    // One guest is one WhatsApp number: the client picks which one
    final phone = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColor.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(containerRadius)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(edge, 0, edge, edge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DragHandle(),
              Text('guests_contacts_choose_number'.tr(),
                  style: context.typography.titleLarge),
              Text(contact.name, style: context.typography.bodySmall),
              for (final number in free)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.phone_outlined,
                      color: AppColor.primaryDark),
                  title: Text(number,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.start,
                      style: context.typography.numericSmall
                          .copyWith(color: AppColor.primaryDark)),
                  onTap: () => Navigator.of(context).pop(number),
                ),
            ],
          ),
        ),
      ),
    );
    if (phone != null && !cubit.toggle(contact, phone: phone)) _showLimit();
  }

  Future<void> _next(ContactsPickerCubit cubit) async {
    cubit.startReview();
    final navigator = Navigator.of(context);
    final rows = await navigator.push<List<DraftGuest>>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const ContactsReviewScreen(),
        ),
      ),
    );
    if (rows != null && mounted) navigator.pop(rows);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsPickerCubit, ContactsPickerStates>(
      builder: (context, state) {
        final cubit = context.read<ContactsPickerCubit>();
        final count = cubit.selectedCount;
        return Scaffold(
          backgroundColor: AppColor.primaryLight,
          appBar: recordsAppBar(context, 'guests_contacts_pick_title'.tr(),
              subtitle: count > 0
                  ? 'guests_contacts_selected'.tr(args: ['$count'])
                  : null),
          bottomNavigationBar: state is Loaded && cubit.hasContacts
              ? SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(edge * 0.8),
                    child: count == 0
                        ? CustomButton.disabled(
                            text: 'guests_next_count'.tr(args: ['0']),
                            color: AppColor.gray200)
                        : CustomButton.normal(
                            text: 'guests_next_count'.tr(args: ['$count']),
                            color: AppColor.primaryDark,
                            onPressed: () => _next(cubit),
                          ),
                  ),
                )
              : null,
          body: switch (state) {
            NoAccess(:final access) => _AccessView(
                access: access,
                onRequest: cubit.requestAccess,
                onSettings: cubit.openSettings,
                onManual: () => Navigator.of(context).pop(
                    access == ContactsAccess.notDetermined
                        ? null
                        : ContactsPickerScreen.manualResult),
              ),
            Error(:final message) => Center(
                child: Text(message,
                    style: context.typography.bodyMedium
                        .copyWith(color: AppColor.semanticError))),
            Loaded() => _list(cubit),
            _ => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomLoadingIndicator(),
                    SizedBox(height: edge * 0.5),
                    Text('guests_contacts_loading'.tr(),
                        style: context.typography.bodySmall),
                  ],
                ),
              ),
          },
        );
      },
    );
  }

  Widget _list(ContactsPickerCubit cubit) {
    if (!cubit.hasContacts) {
      return Center(
        child: Text('guests_contacts_empty'.tr(),
            style: context.typography.bodyMedium
                .copyWith(color: AppColor.gray500)),
      );
    }
    final contacts = cubit.visibleContacts;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(edge, edge * 0.6, edge, 0),
          child: TextField(
            onChanged: cubit.search,
            style: context.typography.inputText,
            decoration: InputDecoration(
              hintText: 'guests_search_hint'.tr(),
              hintStyle: context.typography.inputHint,
              prefixIcon:
                  const Icon(Icons.search_rounded, color: AppColor.gray400),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusInput),
                borderSide: const BorderSide(color: AppColor.gray100),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radiusInput)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: edge * 0.5),
          child: Row(
            children: [
              if (cubit.isLimited)
                Expanded(
                  child: TextButton(
                    onPressed: cubit.openSettings,
                    child: Text('guests_contacts_limited'.tr(),
                        style: context.typography.labelMedium
                            .copyWith(decoration: TextDecoration.underline)),
                  ),
                )
              else
                const Spacer(),
              TextButton(
                onPressed: cubit.selectedCount > 0
                    ? cubit.clearSelection
                    : () {
                        if (!cubit.selectAllVisible()) _showLimit();
                      },
                child: Text(
                  cubit.selectedCount > 0
                      ? 'guests_deselect_all'.tr()
                      : 'guests_select_all'.tr(),
                  style: context.typography.titleSmall,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: contacts.isEmpty
              ? Center(
                  child: Text('guests_no_results'.tr(),
                      style: context.typography.bodyMedium
                          .copyWith(color: AppColor.gray500)))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: edge),
                  itemCount: contacts.length,
                  itemBuilder: (context, i) => _contactRow(cubit, contacts[i]),
                ),
        ),
      ],
    );
  }

  Widget _contactRow(ContactsPickerCubit cubit, PickedContact contact) {
    final taken = cubit.freePhones(contact).isEmpty;
    final selected = cubit.isSelected(contact);
    final phone = cubit.selectedPhone(contact) ?? contact.phones.first;
    final more = contact.phones.length - 1;

    return Opacity(
      opacity: taken ? 0.5 : 1,
      child: InkWell(
        onTap: taken ? null : () => _onTap(cubit, contact),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: edge * 0.4),
          child: Row(
            children: [
              Checkbox(
                value: selected,
                activeColor: AppColor.primaryDark,
                onChanged: taken ? null : (_) => _onTap(cubit, contact),
              ),
              CircleAvatar(
                radius: 17,
                backgroundColor: AppColor.primaryDark.withValues(alpha: 0.1),
                child: Text(contact.name.characters.first,
                    style: context.typography.titleSmall),
              ),
              SizedBox(width: edge * 0.5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.name, style: context.typography.titleSmall),
                    Row(
                      children: [
                        Text(phone,
                            textDirection: TextDirection.ltr,
                            style: context.typography.numericSmall
                                .copyWith(fontSize: 12)),
                        if (more > 0) ...[
                          SizedBox(width: edge * 0.3),
                          Text(
                              'guests_contacts_more_numbers'
                                  .tr(args: ['$more']),
                              style: context.typography.labelSmall),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (taken)
                Text('guests_contacts_already_added'.tr(),
                    style: context.typography.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explains or asks for contacts access, depending on its state.
class _AccessView extends StatelessWidget {
  const _AccessView({
    required this.access,
    required this.onRequest,
    required this.onSettings,
    required this.onManual,
  });

  final ContactsAccess access;
  final VoidCallback onRequest;
  final VoidCallback onSettings;
  final VoidCallback onManual;

  @override
  Widget build(BuildContext context) {
    final (title, body) = switch (access) {
      ContactsAccess.notDetermined => (
          'guests_contacts_access_title'.tr(),
          'guests_contacts_access_body'.tr()
        ),
      ContactsAccess.denied => (
          'guests_contacts_access_title'.tr(),
          'guests_contacts_denied'.tr()
        ),
      _ => (
          'guests_contacts_access_title'.tr(),
          'guests_contacts_permanently_denied'.tr()
        ),
    };

    return Padding(
      padding: EdgeInsets.all(edge * 1.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            access == ContactsAccess.notDetermined
                ? Icons.contacts_outlined
                : Icons.lock_outline_rounded,
            size: 52,
            color: AppColor.primaryDark,
          ),
          SizedBox(height: edge * 0.6),
          Text(title,
              textAlign: TextAlign.center,
              style: context.typography.headlineSmall),
          SizedBox(height: edge * 0.4),
          Text(body,
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium
                  .copyWith(color: AppColor.gray700)),
          SizedBox(height: edge),
          if (access == ContactsAccess.notDetermined)
            CustomButton.normal(
                text: 'guests_continue'.tr(),
                color: AppColor.primaryDark,
                onPressed: onRequest)
          else if (access == ContactsAccess.denied)
            CustomButton.normal(
                text: 'guests_contacts_allow'.tr(),
                color: AppColor.primaryDark,
                onPressed: onRequest)
          else if (access == ContactsAccess.permanentlyDenied)
            CustomButton.normal(
                text: 'guests_open_settings'.tr(),
                color: AppColor.primaryDark,
                onPressed: onSettings),
          TextButton(
            onPressed: onManual,
            child: Text(
              access == ContactsAccess.notDetermined
                  ? 'cancel'.tr()
                  : 'guests_add_manual'.tr(),
              style: context.typography.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
