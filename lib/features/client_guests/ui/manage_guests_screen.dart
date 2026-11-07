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
import '../data/models/guest_title.dart';
import '../logic/manage_guests_cubit.dart';
import '../logic/manage_guests_states.dart';
import 'contacts_picker_screen.dart';
import 'widgets/add_guests_options.dart';
import 'widgets/deadline_banner.dart';
import 'widgets/guest_dialogs.dart';
import 'widgets/guest_button_pair.dart';
import 'widgets/guest_form_sheet.dart';
import 'widgets/guest_title_sheets.dart';
import 'widgets/guest_tiles.dart';
import 'widgets/locked_guest_sheet.dart';
import 'widgets/submit_bar.dart';
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

  /// Ticking guests to change their title together.
  bool _selecting = false;
  final Set<String> _selectedDraft = {};
  final Set<int> _selectedGuests = {};

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

  // ── Titles ────────────────────────────────────────────────────────────────

  void _endSelection() => setState(() {
        _selecting = false;
        _selectedDraft.clear();
        _selectedGuests.clear();
      });

  int get _selectedCount => _selectedDraft.length + _selectedGuests.length;

  List<ClientGuest> _selectableGuests(ManageGuestsCubit cubit) =>
      cubit.titlesOnList ? cubit.guests : const [];

  bool _allSelected(ManageGuestsCubit cubit) {
    final draft = cubit.filteredDraft;
    final guests = _selectableGuests(cubit);
    return draft.length + guests.length > 0 &&
        draft.every((d) => _selectedDraft.contains(d.localId)) &&
        guests.every((g) => _selectedGuests.contains(g.guestId));
  }

  void _toggleAll(ManageGuestsCubit cubit) {
    final all = _allSelected(cubit);
    setState(() {
      _selectedDraft.clear();
      _selectedGuests.clear();
      if (all) return;
      _selectedDraft.addAll(cubit.filteredDraft.map((d) => d.localId));
      _selectedGuests.addAll(
          _selectableGuests(cubit).map((g) => g.guestId).nonNulls);
    });
  }

  Future<void> _pickTitleForSelection(ManageGuestsCubit cubit) async {
    final names = [
      for (final row in cubit.draft)
        if (_selectedDraft.contains(row.localId)) row.name,
      for (final guest in cubit.guests)
        if (_selectedGuests.contains(guest.guestId)) guest.titleAndName.$2,
    ];
    final title = await GuestTitlePickerSheet.show(
      context,
      count: _selectedCount,
      recentTitles: cubit.recentTitles,
      names: names,
    );
    if (title != null) {
      await _changeTitle(cubit, title, {..._selectedDraft}, {..._selectedGuests});
    }
  }

  /// Everyone with the filtered title: a new title for all of them. For "no
  /// title" that's choosing one, for a title it's renaming it.
  Future<void> _changeFiltered(ManageGuestsCubit cubit, GuestTitle from) async {
    final draftRows = cubit.draft.where((d) => d.title == from).toList();
    final guests = cubit.titlesOnList
        ? cubit.guests.where((g) => g.titleAndName.$1 == from).toList()
        : const <ClientGuest>[];
    final count = draftRows.length + guests.length;
    final names = [
      for (final d in draftRows) d.name,
      for (final g in guests) g.titleAndName.$2,
    ];
    final title = await (from.kind == GuestTitleKind.none
        ? GuestTitlePickerSheet.show(context,
            count: count, recentTitles: cubit.recentTitles, names: names)
        : RenameTitleSheet.show(context,
            from: from, count: count, sampleName: names.firstOrNull));
    if (title == null) return;
    await _changeTitle(cubit, title, {for (final d in draftRows) d.localId},
        guests.map((g) => g.guestId).nonNulls.toSet());
  }

  /// A draft changes on the phone; guests on the list need a confirmation,
  /// since some of them may have been sent an invitation.
  Future<void> _changeTitle(ManageGuestsCubit cubit, GuestTitle title,
      Set<String> draftIds, Set<int> guestIds) async {
    if (guestIds.isNotEmpty) {
      final locked = cubit.lockedCount(guestIds);
      final confirmed = await TitleChangeConfirmSheet.show(
        context,
        to: title,
        updating: draftIds.length + guestIds.length - locked,
        locked: locked,
      );
      if (!confirmed) return;
    }
    _endSelection();
    if (draftIds.isNotEmpty) {
      cubit.applyTitleToDraft(draftIds, title);
      await cubit.rememberTitle(title);
    }
    if (guestIds.isNotEmpty) await cubit.applyTitleToGuests(guestIds, title);
  }

  Future<void> _onPop(ManageGuestsCubit cubit, bool didPop) async {
    if (didPop) return;
    if (_selecting) {
      _endSelection();
      return;
    }
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
      case TitleChangeResult(:final outcome):
        await TitleChangeResultSheet.show(context, outcome);
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
        final submitting = state is Submitting || state is TitleChanging;
        final showBar = cubit.canEdit && cubit.hasDraft;

        return PopScope(
          canPop: !cubit.isDraftDirty && !_selecting,
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
              floatingActionButton: cubit.canEdit &&
                      cubit.hasLoaded &&
                      !_selecting
                  ? FloatingActionButton.extended(
                      backgroundColor: AppColor.primaryDark,
                      foregroundColor: AppColor.primaryLight,
                      onPressed: () => _addGuests(cubit),
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: Text('guests_add'.tr(),
                          style: context.typography.buttonMedium),
                    )
                  : null,
              bottomNavigationBar: _selecting
                  ? _selectionBar(cubit)
                  : showBar
                      ? _submitBar(cubit)
                      : null,
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
    // Truly nothing yet: decided on the unfiltered data, never on the search
    final empty = cubit.hasLoaded && !cubit.hasGuests && !cubit.hasDraft;
    final noResults =
        cubit.query.isNotEmpty && guests.isEmpty && draft.isEmpty;

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
            if (cubit.titlesOnList && cubit.canEdit) _titleTools(cubit),
            if (noResults)
              _noResultsView(cubit)
            else ...[
              if (draft.isNotEmpty || (cubit.hasDraft && cubit.query.isEmpty))
                ..._draftSection(cubit, draft),
              if (cubit.hasLoaded &&
                  (guests.isNotEmpty || cubit.query.isEmpty))
                ..._guestsSection(cubit, guests),
            ],
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
          suffixIcon: cubit.query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 18, color: AppColor.gray500),
                  tooltip: 'guests_clear_search'.tr(),
                  onPressed: () => _clearSearch(cubit),
                ),
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

  void _clearSearch(ManageGuestsCubit cubit) {
    _searchController.clear();
    cubit.search('');
  }

  /// The search matched nothing; the list itself isn't empty.
  Widget _noResultsView(ManageGuestsCubit cubit) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: edge * 1.5),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded,
              size: 44, color: AppColor.gray300),
          SizedBox(height: edge * 0.4),
          Text(
            'guests_no_results_for'.tr(args: [cubit.query]),
            textAlign: TextAlign.center,
            style:
                context.typography.bodyMedium.copyWith(color: AppColor.gray600),
          ),
          TextButton(
            onPressed: () => _clearSearch(cubit),
            child: Text('guests_clear_search'.tr(),
                style: context.typography.titleSmall),
          ),
        ],
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
      if (!cubit.titlesOnList && cubit.canEdit) _titleTools(cubit),
      for (final row in draft)
        _selectable(
          cubit,
          selected: _selectedDraft.contains(row.localId),
          onToggle: () => setState(() {
            if (!_selectedDraft.remove(row.localId)) {
              _selectedDraft.add(row.localId);
            }
          }),
          child: (onToggle) => DraftGuestTile(
            row: row,
            onTap: onToggle ??
                (cubit.canEdit
                    ? () => GuestFormSheet.show(context, draftRow: row)
                    : () {}),
          ),
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
      // Only reached without a search: the draft has rows, the list none
      if (guests.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: edge),
          child: Center(
            child: Text('guests_empty'.tr(),
                style: context.typography.bodyMedium
                    .copyWith(color: AppColor.gray500)),
          ),
        ),
      for (final guest in guests)
        cubit.titlesOnList
            ? _selectable(
                cubit,
                selected: _selectedGuests.contains(guest.guestId),
                onToggle: () => setState(() {
                  if (!_selectedGuests.remove(guest.guestId)) {
                    _selectedGuests.add(guest.guestId!);
                  }
                }),
                child: (onToggle) => ServerGuestTile(
                  guest: guest,
                  canEdit: cubit.canEdit,
                  onTap: onToggle ?? () => _openServerGuest(cubit, guest),
                ),
              )
            : ServerGuestTile(
                guest: guest,
                canEdit: cubit.canEdit,
                onTap: () => _openServerGuest(cubit, guest),
              ),
    ];
  }

  /// Guests whose title can be changed together: the draft, and the list too
  /// once titles on the list are available.
  int _groupableCount(ManageGuestsCubit cubit) =>
      cubit.titleCounts.values.fold<int>(0, (sum, count) => sum + count);

  /// Changing titles together is offered from two guests up; one guest is
  /// simpler to edit directly.
  bool _canSelectGroup(ManageGuestsCubit cubit) =>
      cubit.canEdit && _groupableCount(cubit) >= 2;

  /// While selecting, a tile gets a checkbox and a tap on it ticks it. A long
  /// press on a tile starts a selection with it ticked, a shortcut to the
  /// "change titles for a group" button.
  Widget _selectable(
    ManageGuestsCubit cubit, {
    required bool selected,
    required VoidCallback onToggle,
    required Widget Function(VoidCallback? onToggle) child,
  }) {
    if (!_selecting) {
      return GestureDetector(
        onLongPress: _canSelectGroup(cubit)
            ? () {
                setState(() => _selecting = true);
                onToggle();
              }
            : null,
        child: child(null),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: selected,
          activeColor: AppColor.primaryDark,
          onChanged: (_) => onToggle(),
        ),
        Expanded(child: child(onToggle)),
      ],
    );
  }

  /// The titles in use as filters, a change for everyone with the chosen
  /// one, and starting a selection.
  Widget _titleTools(ManageGuestsCubit cubit) {
    final counts = cubit.titleCounts;
    if (counts.isEmpty) return const SizedBox.shrink();
    final filter = cubit.titleFilter;
    final total = _groupableCount(cubit);
    final titles = counts.keys.toList()
      // "No title" goes last
      ..sort((a, b) => (a.kind == GuestTitleKind.none ? 1 : 0)
          .compareTo(b.kind == GuestTitleKind.none ? 1 : 0));

    return Padding(
      padding: EdgeInsets.only(bottom: edge * 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GuestChoiceChip(
                  label: 'guests_review_tab_all'.tr(args: ['$total']),
                  selected: filter == null,
                  onTap: () => cubit.setTitleFilter(null),
                ),
                for (final title in titles)
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: edge * 0.3),
                    child: GuestChoiceChip(
                      label: '${title.kind == GuestTitleKind.none ? 'guests_title_none'.tr() : title.text} ${counts[title]}',
                      selected: filter == title,
                      onTap: () => cubit.setTitleFilter(title),
                    ),
                  ),
              ],
            ),
          ),
          if (!_selecting && filter != null && counts[filter] != null)
            _filterSummary(cubit, filter, counts[filter]!),
          if (_selecting)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColor.primaryDark,
              value: _allSelected(cubit),
              onChanged: (_) => _toggleAll(cubit),
              title: Text('guests_select_all'.tr(),
                  style: context.typography.bodySmall),
            )
          else if (_canSelectGroup(cubit))
            Padding(
              padding: EdgeInsets.only(top: edge * 0.3),
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _selecting = true),
                icon: const Icon(Icons.checklist_rounded, size: 18),
                label: Text('guests_select_group'.tr(),
                    style: context.typography.labelLarge),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primaryDark,
                  side: const BorderSide(color: AppColor.gray300),
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radiusInput)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// The chosen title with its count, and the change for all of them.
  Widget _filterSummary(
      ManageGuestsCubit cubit, GuestTitle filter, int count) {
    final none = filter.kind == GuestTitleKind.none;
    return Container(
      margin: EdgeInsets.only(top: edge * 0.4),
      padding: EdgeInsetsDirectional.only(start: edge * 0.6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radiusInput),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${none ? 'guests_title_none'.tr() : filter.text} · ${'guests_count'.tr(args: ['$count'])}',
              style: context.typography.titleSmall,
            ),
          ),
          if (cubit.canEdit)
            TextButton(
              onPressed: () => _changeFiltered(cubit, filter),
              child: Text(
                  none
                      ? 'guests_title_choose_all'.tr()
                      : 'guests_title_rename_all'.tr(),
                  style: context.typography.labelLarge),
            ),
        ],
      ),
    );
  }

  Widget _selectionBar(ManageGuestsCubit cubit) {
    final count = _selectedCount;
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(edge * 0.6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                      'guests_contacts_selected'.tr(args: ['$count']),
                      style: context.typography.titleSmall),
                ),
                TextButton(
                  onPressed: _endSelection,
                  child: Text('cancel'.tr(),
                      style: context.typography.labelLarge),
                ),
              ],
            ),
            GuestButtonPair(
              primaryText: 'guests_change_title'.tr(),
              onPrimary:
                  count == 0 ? null : () => _pickTitleForSelection(cubit),
              secondaryText: 'guests_title_remove'.tr(),
              onSecondary: count == 0
                  ? null
                  : () => _changeTitle(cubit, const GuestTitle.none(),
                      {..._selectedDraft}, {..._selectedGuests}),
            ),
          ],
        ),
      ),
    );
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

  Widget _submitBar(ManageGuestsCubit cubit) => GuestsSubmitBar(
        draftCount: cubit.draft.length,
        isSaved: !cubit.isDraftDirty,
        onSave: cubit.saveDraft,
        onSubmit: cubit.hasLoaded ? () => _submit(cubit) : null,
      );
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
