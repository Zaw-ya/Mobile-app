import 'dart:async';

import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/helpers/extensions.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../../../core/widgets/public_app_bar.dart';
import '../../client_events/data/models/client_event_response.dart';
import '../data/models/draft_guest.dart';
import '../data/models/event_guests_response.dart';
import '../logic/manage_guests_cubit.dart';
import '../logic/manage_guests_states.dart';
import 'contacts_picker_screen.dart';
import 'widgets/add_guests_options.dart';
import 'widgets/deadline_banner.dart';
import 'widgets/guest_dialogs.dart';
import 'widgets/guest_form_sheet.dart';
import 'widgets/guest_tiles.dart';
import 'widgets/locked_guest_sheet.dart';
import 'widgets/submit_result_sheet.dart';

/// "Manage guests" of one event: the list, the local draft, and adding,
/// editing and deleting guests until the edit deadline.
class ManageGuestsScreen extends StatefulWidget {
  const ManageGuestsScreen({super.key, required this.event});

  final ClientEventDetails event;

  @override
  State<ManageGuestsScreen> createState() => _ManageGuestsScreenState();
}

class _ManageGuestsScreenState extends State<ManageGuestsScreen>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  Timer? _deadlineTimer;

  int get _eventId => widget.event.id ?? 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<ManageGuestsCubit>().load(_eventId);
    // Keeps the countdown fresh and closes the list once the deadline passes
    _deadlineTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      context.read<ManageGuestsCubit>().checkDeadline();
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _deadlineTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A guest may have been sent an invitation while the app was away
    if (state == AppLifecycleState.resumed) {
      context.read<ManageGuestsCubit>().refresh();
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _addGuests(ManageGuestsCubit cubit) => AddGuestsOptions.showSheet(
        context,
        onManual: () => GuestFormSheet.show(context),
        onContacts: () => _addFromContacts(cubit),
      );

  Future<void> _addFromContacts(ManageGuestsCubit cubit) async {
    final rows = await context.pushNamed(Routes.contactsPickerScreen,
        arguments: cubit.takenPhones);
    if (rows is List<DraftGuest>) cubit.addToDraft(rows);
    if (rows == ContactsPickerScreen.manualResult && mounted) {
      GuestFormSheet.show(context);
    }
  }

  Future<void> _submit(ManageGuestsCubit cubit) async {
    final confirmed = await showGuestsConfirmDialog(
      context,
      title: 'guests_submit_title'.tr(),
      body: 'guests_submit_body'.tr(args: ['${cubit.draft.length}']),
      confirmText: 'guests_submit_btn'.tr(),
    );
    if (confirmed) await cubit.submitDraft();
  }

  void _openServerGuest(ManageGuestsCubit cubit, ClientGuest guest) {
    if (cubit.canEdit && !(guest.isLocked ?? false)) {
      GuestFormSheet.show(context, serverGuest: guest);
      return;
    }
    LockedGuestSheet.show(
      context,
      guest: guest,
      eventId: _eventId,
      eventTitle: widget.event.eventTitle ?? '',
      supportWhatsappNumber: cubit.supportWhatsappNumber,
    );
  }

  Future<void> _onPop(ManageGuestsCubit cubit, bool didPop) async {
    if (didPop) return;
    final navigator = Navigator.of(context);
    final choice = await showLeaveDraftDialog(context);
    switch (choice) {
      case LeaveChoice.save:
        await cubit.saveDraft(notify: false);
        navigator.pop();
      case LeaveChoice.discard:
        await cubit.discardDraftChanges();
        navigator.pop();
      case LeaveChoice.stay:
        break;
    }
  }

  Future<void> _listener(BuildContext context, ManageGuestsStates state) async {
    final cubit = context.read<ManageGuestsCubit>();
    switch (state) {
      case ActionSuccess(:final message):
        context.showSuccessToast(message);
      case ActionError(:final message):
        context.showErrorToast(message);
      case Error(:final message) when cubit.hasLoaded:
        context.showErrorToast(message);
      case SubmitResult(:final outcome):
        final discard = await SubmitResultSheet.show(context, outcome);
        if (discard) {
          cubit.removeFromDraft(outcome.failed.map((r) => r.localId));
          await cubit.saveDraft(notify: false);
        }
      default:
        break;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageGuestsCubit, ManageGuestsStates>(
      listener: _listener,
      builder: (context, state) {
        final cubit = context.read<ManageGuestsCubit>();
        final submitting = state is Submitting;
        final showBar = cubit.canEdit && cubit.hasDraft;

        return PopScope(
          canPop: !cubit.isDraftDirty,
          onPopInvokedWithResult: (didPop, _) => _onPop(cubit, didPop),
          child: ModalProgressHUD(
            inAsyncCall: submitting,
            progressIndicator: const CustomLoadingIndicator(),
            color: AppColor.primaryDark,
            opacity: 0.4,
            child: Scaffold(
              backgroundColor: AppColor.primaryDark,
              // maybePop so the app bar back goes through PopScope too
              appBar: recordsAppBar(context, 'guests_manage'.tr(),
                  subtitle: widget.event.eventTitle,
                  onBack: () => Navigator.of(context).maybePop()),
              floatingActionButton: cubit.canEdit && cubit.hasLoaded
                  ? FloatingActionButton.extended(
                      backgroundColor: AppColor.primaryDark,
                      foregroundColor: AppColor.primaryLight,
                      onPressed: () => _addGuests(cubit),
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: Text('guests_add'.tr(),
                          style: context.typography.buttonMedium),
                    )
                  : null,
              bottomNavigationBar: showBar ? _submitBar(cubit) : null,
              body: Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(containerRadius),
                    topRight: Radius.circular(containerRadius),
                  ),
                ),
                child: _content(cubit, state),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _content(ManageGuestsCubit cubit, ManageGuestsStates state) {
    if (!cubit.hasLoaded && !cubit.hasDraft) {
      if (state is Error) return _errorView(cubit, state.message);
      return const Center(child: CustomLoadingIndicator());
    }

    final guests = cubit.guests;
    final draft = cubit.filteredDraft;
    final empty = cubit.hasLoaded && guests.isEmpty && !cubit.hasDraft;

    return RefreshIndicator(
      color: AppColor.primaryDark,
      onRefresh: cubit.refresh,
      child: ListView(
        padding: EdgeInsets.fromLTRB(edge, edge, edge, edge * 5),
        children: [
          if (cubit.hasLoaded)
            GuestsDeadlineBanner(
              canEdit: cubit.canEdit,
              cannotEditCode: cubit.cannotEditCode,
              deadlineText: cubit.deadlineLocalText,
              deadlineUtc: cubit.deadlineUtc,
            )
          else if (state is Error)
            _errorView(cubit, state.message)
          else
            const Center(child: CustomLoadingIndicator()),
          SizedBox(height: edge * 0.6),
          if (empty)
            ..._emptyView(cubit)
          else ...[
            _searchField(cubit),
            if (cubit.hasDraft) ..._draftSection(cubit, draft),
            if (cubit.hasLoaded) ..._guestsSection(cubit, guests),
          ],
        ],
      ),
    );
  }

  Widget _searchField(ManageGuestsCubit cubit) {
    return Padding(
      padding: EdgeInsets.only(bottom: edge * 0.6),
      child: TextField(
        controller: _searchController,
        onChanged: cubit.search,
        style: context.typography.inputText,
        decoration: InputDecoration(
          hintText: 'guests_search_hint'.tr(),
          hintStyle: context.typography.inputHint,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColor.gray400),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColor.gray100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusInput),
            borderSide: const BorderSide(color: AppColor.gray100),
          ),
        ),
      ),
    );
  }

  List<Widget> _draftSection(ManageGuestsCubit cubit, List<DraftGuest> draft) {
    return [
      _SectionHeader(
        title: 'guests_section_draft'.tr(args: ['${cubit.draft.length}']),
        hint: 'guests_section_draft_hint'.tr(),
      ),
      if (!cubit.canEdit && cubit.hasLoaded) _expiredDraftNotice(cubit),
      for (final row in draft)
        DraftGuestTile(
          row: row,
          onTap: cubit.canEdit
              ? () => GuestFormSheet.show(context, draftRow: row)
              : () {},
        ),
      SizedBox(height: edge * 0.6),
    ];
  }

  Widget _expiredDraftNotice(ManageGuestsCubit cubit) {
    return Container(
      margin: EdgeInsets.only(bottom: edge * 0.5),
      padding: EdgeInsets.all(edge * 0.6),
      decoration: BoxDecoration(
        color: AppColor.semanticError.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(radiusInner),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('guests_draft_expired'.tr(args: ['${cubit.draft.length}']),
              style: context.typography.bodySmall
                  .copyWith(color: AppColor.semanticError)),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: cubit.deleteDraft,
              child: Text('guests_delete_draft'.tr(),
                  style: context.typography.titleSmall
                      .copyWith(color: AppColor.semanticError)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _guestsSection(
      ManageGuestsCubit cubit, List<ClientGuest> guests) {
    return [
      _SectionHeader(
          title: 'guests_section_added'.tr(args: ['${guests.length}'])),
      if (guests.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: edge),
          child: Center(
            child: Text('guests_no_results'.tr(),
                style: context.typography.bodyMedium
                    .copyWith(color: AppColor.gray500)),
          ),
        ),
      for (final guest in guests)
        ServerGuestTile(
          guest: guest,
          canEdit: cubit.canEdit,
          onTap: () => _openServerGuest(cubit, guest),
        ),
    ];
  }

  List<Widget> _emptyView(ManageGuestsCubit cubit) {
    return [
      SizedBox(height: edge),
      const Icon(Icons.group_add_outlined, size: 56, color: AppColor.gray300),
      SizedBox(height: edge * 0.5),
      Text(
        cubit.canEdit ? 'guests_empty'.tr() : 'guests_empty_closed'.tr(),
        textAlign: TextAlign.center,
        style: context.typography.titleMedium.copyWith(color: AppColor.gray600),
      ),
      SizedBox(height: edge),
      if (cubit.canEdit)
        AddGuestsOptions(
          onManual: () => GuestFormSheet.show(context),
          onContacts: () => _addFromContacts(cubit),
        ),
    ];
  }

  Widget _errorView(ManageGuestsCubit cubit, String message) {
    return Padding(
      padding: EdgeInsets.all(edge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium
                  .copyWith(color: AppColor.semanticError)),
          SizedBox(height: edge * 0.6),
          CustomButton.normal(
            text: 'retry'.tr(),
            color: AppColor.primaryDark,
            onPressed: () => cubit.load(_eventId),
          ),
        ],
      ),
    );
  }

  Widget _submitBar(ManageGuestsCubit cubit) {
    final saved = !cubit.isDraftDirty;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(edge, edge * 0.6, edge, edge * 0.6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryDark.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton.normal(
                text: saved
                    ? 'guests_draft_saved_state'.tr()
                    : 'guests_save_draft'.tr(),
                color: AppColor.gray100,
                textColor: AppColor.primaryDark,
                fontSize: 13,
                onPressed: saved ? null : cubit.saveDraft,
              ),
            ),
            SizedBox(width: edge * 0.5),
            Expanded(
              flex: 3,
              child: CustomButton.normal(
                text: 'guests_submit_count'.tr(args: ['${cubit.draft.length}']),
                color: AppColor.primaryDark,
                fontSize: 13,
                onPressed: cubit.hasLoaded ? () => _submit(cubit) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.hint});

  final String title;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: edge * 0.4),
      child: Row(
        children: [
          Text(title, style: context.typography.titleMedium),
          const Spacer(),
          if (hint != null) Text(hint!, style: context.typography.labelMedium),
        ],
      ),
    );
  }
}
