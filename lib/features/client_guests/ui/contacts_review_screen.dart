import 'package:app/core/theming/typography_theme.dart';
// intl (re-exported by easy_localization) has its own TextDirection
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/helpers/phone_number_helper.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/drag_handle.dart';
import '../../../core/widgets/public_app_bar.dart';
import '../data/models/draft_guest.dart';
import '../data/models/guest_title.dart';
import '../logic/contacts_picker_cubit.dart';
import '../logic/contacts_picker_states.dart';
import '../logic/guest_validation.dart';
import 'widgets/guest_button_pair.dart';
import 'widgets/guest_dialogs.dart';
import 'widgets/guest_input_decoration.dart';
import 'widgets/guest_title_field.dart';
import 'widgets/guest_title_sheets.dart';
import 'widgets/guest_tiles.dart';
import 'widgets/phone_country_field.dart';

/// Review of the picked contacts before they go to the draft: the client
/// ticks a group of rows and gives them a title, and each title then shows as
/// its own section. Pops the ready rows.
class ContactsReviewScreen extends StatefulWidget {
  const ContactsReviewScreen({super.key});

  @override
  State<ContactsReviewScreen> createState() => _ContactsReviewScreenState();
}

class _ContactsReviewScreenState extends State<ContactsReviewScreen> {
  final TextEditingController _searchController = TextEditingController();

  /// Sections the client opened or closed, against their default.
  final Set<GuestTitle> _toggled = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickTitle(ContactsPickerCubit cubit) async {
    final selected = [
      for (final row in cubit.reviewRows)
        if (cubit.isReviewSelected(row)) row.name,
    ];
    final title = await GuestTitlePickerSheet.show(
      context,
      count: selected.length,
      recentTitles: cubit.recentTitles,
      names: selected,
    );
    if (title != null) await cubit.applyTitleToSelected(title);
  }

  Future<void> _rename(ContactsPickerCubit cubit, ReviewTitleGroup group) async {
    final count = cubit.reviewRows
        .where((r) => !cubit.isUntitled(r) && r.title == group.title)
        .length;
    final title = await RenameTitleSheet.show(
      context,
      from: group.title,
      count: count,
      sampleName: group.rows.first.name,
    );
    if (title != null) await cubit.renameReviewTitle(group.title, title);
  }

  Future<void> _finish(ContactsPickerCubit cubit) async {
    final navigator = Navigator.of(context);
    if (cubit.untitledCount > 0) {
      final choice = await showUntitledGuestsDialog(
        context,
        untitled: cubit.untitledCount,
        ready: cubit.readyRows.length,
      );
      switch (choice) {
        case UntitledChoice.back:
          cubit.setReviewFilter(ReviewFilter.untitled);
          return;
        case UntitledChoice.addWithoutTitle:
          cubit.applyTitleToUntitled(const GuestTitle.none());
        case UntitledChoice.skipThem:
          break;
      }
    }
    navigator.pop(cubit.readyRows);
  }

  void _openRow(ContactsPickerCubit cubit, DraftGuest row) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColor.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(containerRadius)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _ReviewRowSheet(localId: row.localId),
      ),
    );
  }

  bool _isOpen(ContactsPickerCubit cubit, ReviewTitleGroup group) {
    final byDefault = cubit.reviewQuery.isNotEmpty ||
        group.rows.any((r) => cubit.reviewContentIssue(r) != null);
    return _toggled.contains(group.title) ? !byDefault : byDefault;
  }

  List<Widget> _listItems(ContactsPickerCubit cubit) {
    Widget tile(DraftGuest row) => _ReviewRowTile(
          key: ValueKey(row.localId),
          row: row,
          onEdit: () => _openRow(cubit, row),
        );
    if (cubit.reviewFilter == ReviewFilter.untitled) {
      return [for (final row in cubit.reviewVisibleRows) tile(row)];
    }

    final untitled = cubit.reviewVisibleRows.where(cubit.isUntitled).toList();
    return [
      for (final group in cubit.reviewGroups) ...[
        _GroupHeader(
          group: group,
          open: _isOpen(cubit, group),
          onToggle: () => setState(() {
            if (!_toggled.remove(group.title)) _toggled.add(group.title);
          }),
          onRename: group.title.kind == GuestTitleKind.none
              ? null
              : () => _rename(cubit, group),
        ),
        if (_isOpen(cubit, group)) ...group.rows.map(tile),
      ],
      if (untitled.isNotEmpty) ...[
        Padding(
          padding: EdgeInsets.symmetric(vertical: edge * 0.4),
          child: Text(
              'guests_review_tab_untitled'.tr(args: ['${untitled.length}']),
              style: context.typography.titleSmall
                  .copyWith(color: AppColor.semanticError)),
        ),
        ...untitled.map(tile),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsPickerCubit, ContactsPickerStates>(
      builder: (context, state) {
        final cubit = context.read<ContactsPickerCubit>();
        final total = cubit.reviewRows.length;
        final selected = cubit.reviewSelectedCount;
        final visible = cubit.reviewVisibleRows;
        final items = _listItems(cubit);

        return Scaffold(
          backgroundColor: AppColor.primaryLight,
          appBar: recordsAppBar(
              context, 'guests_review_title'.tr(args: ['$total'])),
          bottomNavigationBar: _bottomBar(cubit, selected),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(edge, edge * 0.7, edge, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: edge * 0.3,
                      children: [
                        GuestChoiceChip(
                          label: 'guests_review_tab_untitled'
                              .tr(args: ['${cubit.untitledCount}']),
                          selected: cubit.reviewFilter == ReviewFilter.untitled,
                          onTap: () =>
                              cubit.setReviewFilter(ReviewFilter.untitled),
                        ),
                        GuestChoiceChip(
                          label: 'guests_review_tab_all'.tr(args: ['$total']),
                          selected: cubit.reviewFilter == ReviewFilter.all,
                          onTap: () => cubit.setReviewFilter(ReviewFilter.all),
                        ),
                      ],
                    ),
                    SizedBox(height: edge * 0.4),
                    TextField(
                      controller: _searchController,
                      onChanged: cubit.searchReview,
                      style: context.typography.inputText,
                      decoration: guestInputDecoration(context,
                          hint: 'guests_search_hint'.tr(), dense: true),
                    ),
                    if (visible.isNotEmpty)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColor.primaryDark,
                        value: cubit.allReviewVisibleSelected,
                        onChanged: (_) => cubit.toggleAllReviewVisible(),
                        title: Text('guests_select_all'.tr(),
                            style: context.typography.bodySmall),
                        secondary: selected > 0
                            ? Text(
                                'guests_contacts_selected'
                                    .tr(args: ['$selected']),
                                style: context.typography.titleSmall)
                            : null,
                      ),
                    if (cubit.reviewContentIssueCount > 0)
                      Text(
                          'guests_review_needs_fix'.tr(
                              args: ['${cubit.reviewContentIssueCount}']),
                          style: context.typography.bodySmall
                              .copyWith(color: AppColor.semanticError)),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          cubit.reviewFilter == ReviewFilter.untitled &&
                                  cubit.reviewQuery.isEmpty
                              ? 'guests_review_all_titled'.tr()
                              : 'guests_no_results'.tr(),
                          style: context.typography.bodyMedium
                              .copyWith(color: AppColor.gray500),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                            edge, edge * 0.3, edge, edge * 0.5),
                        itemCount: items.length,
                        itemBuilder: (_, index) => items[index],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomBar(ContactsPickerCubit cubit, int selected) {
    final ready = cubit.readyRows.length;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(edge * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected > 0)
              CustomButton.normal(
                text: 'guests_apply_title_count'.tr(args: ['$selected']),
                color: AppColor.primaryDark,
                textStyle: guestButtonTextStyle(context),
                onPressed: () => _pickTitle(cubit),
              )
            else if (ready == 0)
              CustomButton.disabled(
                  text: 'guests_review_add_count'.tr(args: ['0']),
                  color: AppColor.gray200)
            else
              CustomButton.normal(
                text: 'guests_review_add_count'.tr(args: ['$ready']),
                color: AppColor.primaryDark,
                textStyle: guestButtonTextStyle(context),
                onPressed: () => _finish(cubit),
              ),
            if (selected == 0 && cubit.untitledCount > 0) ...[
              SizedBox(height: edge * 0.3),
              Text(
                  'guests_review_remaining'
                      .tr(args: ['${cubit.untitledCount}']),
                  style: context.typography.labelSmall),
            ] else if (selected == 0 && cubit.reviewIssueCount > 0) ...[
              SizedBox(height: edge * 0.3),
              Text('guests_review_errors_note'.tr(),
                  style: context.typography.labelSmall),
            ],
          ],
        ),
      ),
    );
  }
}

/// A title's section: its name and count, open or closed, and changing the
/// title for everyone in it.
class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.group,
    required this.open,
    required this.onToggle,
    required this.onRename,
  });

  final ReviewTitleGroup group;
  final bool open;
  final VoidCallback onToggle;
  final VoidCallback? onRename;

  @override
  Widget build(BuildContext context) {
    final label = group.title.kind == GuestTitleKind.none
        ? 'guests_title_none'.tr()
        : group.title.text;
    return InkWell(
      onTap: onToggle,
      child: Container(
        margin: EdgeInsets.only(bottom: edge * 0.3),
        padding: EdgeInsets.symmetric(horizontal: edge * 0.5),
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusInput),
          border: Border.all(color: AppColor.gray100),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: label, style: context.typography.titleSmall),
                  TextSpan(
                      text: ' · ${group.rows.length}',
                      style: context.typography.labelMedium),
                ]),
              ),
            ),
            if (onRename != null)
              TextButton(
                onPressed: onRename,
                child: Text('guests_title_rename'.tr(),
                    style: context.typography.labelLarge),
              ),
            Icon(
              open
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppColor.gray500,
            ),
          ],
        ),
      ),
    );
  }
}

/// A compact row: ticking it is the main action, the rest is in its sheet.
class _ReviewRowTile extends StatelessWidget {
  const _ReviewRowTile({super.key, required this.row, required this.onEdit});

  final DraftGuest row;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ContactsPickerCubit>();
    final issue = cubit.reviewContentIssue(row);
    final selected = cubit.isReviewSelected(row);
    final digits = row.phoneDigits;

    return Container(
      margin: EdgeInsets.only(bottom: edge * 0.3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radiusInput),
        border: Border.all(
          color: issue != null
              ? AppColor.semanticError
              : selected
                  ? AppColor.primaryDark
                  : AppColor.gray100,
          width: issue != null || selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: selected,
            activeColor: AppColor.primaryDark,
            onChanged: (_) => cubit.toggleReviewSelected(row),
          ),
          Expanded(
            child: InkWell(
              onTap: () => cubit.toggleReviewSelected(row),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: edge * 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GuestNameText(
                      fullName: cubit.isUntitled(row) ? row.name : row.fullName,
                      title: cubit.isUntitled(row) ? null : row.title.text,
                    ),
                    if (digits != null)
                      GuestPhoneText(digits: digits)
                    else
                      Text(row.phoneInput,
                          textDirection: TextDirection.ltr,
                          style: context.typography.numericSmall.copyWith(
                              color: AppColor.gray500, fontSize: 12)),
                    if (issue != null)
                      Text(
                        issue.tr(args: ['${GuestValidation.maxNameLength}']),
                        style: context.typography.labelMedium
                            .copyWith(color: AppColor.semanticError),
                      ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: AppColor.gray500,
            tooltip: 'guests_edit_one'.tr(),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

/// One row's title, name and number. Changes apply as they are typed, like
/// the rest of the review.
class _ReviewRowSheet extends StatefulWidget {
  const _ReviewRowSheet({required this.localId});

  final String localId;

  @override
  State<_ReviewRowSheet> createState() => _ReviewRowSheetState();
}

class _ReviewRowSheetState extends State<_ReviewRowSheet> {
  late final ContactsPickerCubit _cubit = context.read<ContactsPickerCubit>();
  late final DraftGuest _initial = _row!;
  late final _nameController = TextEditingController(text: _initial.name);
  late final _phoneController =
      TextEditingController(text: _initial.phoneInput);

  DraftGuest? get _row {
    for (final row in _cubit.reviewRows) {
      if (row.localId == widget.localId) return row;
    }
    return null;
  }

  @override
  void dispose() {
    // A custom title typed here joins the recent titles when the sheet closes
    final row = _row;
    if (row != null && !_cubit.isUntitled(row)) _cubit.rememberTitle(row.title);
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _update(DraftGuest row, {bool titleChanged = false}) =>
      _cubit.updateReviewRow(row, titleChanged: titleChanged);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsPickerCubit, ContactsPickerStates>(
      builder: (context, state) {
        final row = _row;
        if (row == null) return const SizedBox.shrink();
        final issue = _cubit.reviewIssue(row);
        final country = PhoneNumberHelper.countryForRegion(row.countryRegion);

        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(edge, 0, edge, edge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DragHandle(),
                  Text('guests_edit_one'.tr(),
                      style: context.typography.titleLarge),
                  SizedBox(height: edge * 0.6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: GuestTitleField(
                          dense: true,
                          value: _cubit.isUntitled(row) ? null : row.title,
                          recentTitles: _cubit.recentTitles,
                          onChanged: (title) {
                            if (title == null) return;
                            _update(row.copyWith(title: title),
                                titleChanged: true);
                          },
                        ),
                      ),
                      SizedBox(width: edge * 0.3),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _nameController,
                          style: context.typography.inputText,
                          onChanged: (name) =>
                              _update(row.copyWith(name: name)),
                          decoration: guestInputDecoration(context,
                              hint: 'guests_name_hint'.tr(), dense: true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: edge * 0.4),
                  PhoneCountryField(
                    controller: _phoneController,
                    country: country,
                    dense: true,
                    isValid: row.phoneDigits != null,
                    onChanged: (phone) =>
                        _update(row.copyWith(phoneInput: phone)),
                    onSplit: (split) => _update(row.copyWith(
                        phoneInput: split.text,
                        countryRegion: () => split.country?.region)),
                    onCountryChanged: (picked) => _update(
                        row.copyWith(countryRegion: () => picked?.region)),
                  ),
                  if (issue != null) ...[
                    SizedBox(height: edge * 0.3),
                    Text(
                      issue.tr(args: ['${GuestValidation.maxNameLength}']),
                      style: context.typography.labelMedium
                          .copyWith(color: AppColor.semanticError),
                    ),
                  ],
                  SizedBox(height: edge * 0.6),
                  CustomButton.normal(
                    text: 'close'.tr(),
                    color: AppColor.primaryDark,
                    textStyle: guestButtonTextStyle(context),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _cubit.removeReviewRow(widget.localId);
                    },
                    child: Text('guests_remove_from_review'.tr(),
                        style: context.typography.titleSmall
                            .copyWith(color: AppColor.semanticError)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
