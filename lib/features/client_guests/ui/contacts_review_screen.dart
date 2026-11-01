import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/helpers/phone_number_helper.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/public_app_bar.dart';
import '../data/models/draft_guest.dart';
import '../data/models/guest_title.dart';
import '../logic/contacts_picker_cubit.dart';
import '../logic/contacts_picker_states.dart';
import '../logic/guest_validation.dart';
import 'widgets/guest_input_decoration.dart';
import 'widgets/guest_title_field.dart';
import 'widgets/phone_country_field.dart';

/// Review of the picked contacts before they go to the draft: title, name
/// and number of every row can be fixed here. Pops the ready rows.
class ContactsReviewScreen extends StatefulWidget {
  const ContactsReviewScreen({super.key});

  @override
  State<ContactsReviewScreen> createState() => _ContactsReviewScreenState();
}

class _ContactsReviewScreenState extends State<ContactsReviewScreen> {
  /// Rows needing a fix first; the order is kept while the client edits so
  /// rows don't jump around.
  late final List<String> _order = context
      .read<ContactsPickerCubit>()
      .reviewRowsSorted
      .map((r) => r.localId)
      .toList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsPickerCubit, ContactsPickerStates>(
      builder: (context, state) {
        final cubit = context.read<ContactsPickerCubit>();
        final byId = {for (final r in cubit.reviewRows) r.localId: r};
        final rows = [
          for (final id in _order)
            if (byId[id] != null) byId[id]!,
        ];
        final ready = cubit.readyRows.length;
        final issues = cubit.reviewIssueCount;

        return Scaffold(
          backgroundColor: AppColor.primaryLight,
          appBar: recordsAppBar(
              context, 'guests_review_title'.tr(args: ['${rows.length}'])),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(edge * 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ready == 0
                      ? CustomButton.disabled(
                          text: 'guests_review_add_count'.tr(args: ['0']),
                          color: AppColor.gray200)
                      : CustomButton.normal(
                          text: 'guests_review_add_count'.tr(args: ['$ready']),
                          color: AppColor.primaryDark,
                          onPressed: () =>
                              Navigator.of(context).pop(cubit.readyRows),
                        ),
                  if (issues > 0) ...[
                    SizedBox(height: edge * 0.3),
                    Text('guests_review_errors_note'.tr(),
                        style: context.typography.labelSmall),
                  ],
                ],
              ),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.all(edge),
            children: [
              Text('guests_title_apply_all'.tr(),
                  style: context.typography.titleSmall),
              SizedBox(height: edge * 0.3),
              _ApplyTitleChips(onSelected: cubit.applyTitleToAll),
              if (issues > 0) ...[
                SizedBox(height: edge * 0.5),
                Text('guests_review_needs_fix'.tr(args: ['$issues']),
                    style: context.typography.bodySmall
                        .copyWith(color: AppColor.semanticError)),
              ],
              SizedBox(height: edge * 0.5),
              for (final row in rows)
                _ReviewRowCard(key: ValueKey(row.localId), row: row),
            ],
          ),
        );
      },
    );
  }
}

class _ApplyTitleChips extends StatelessWidget {
  const _ApplyTitleChips({required this.onSelected});

  final ValueChanged<GuestTitle> onSelected;

  @override
  Widget build(BuildContext context) {
    final presets = GuestTitles.presetsFor(context.locale.languageCode);
    Widget chip(String label, GuestTitle title) => ActionChip(
          label: Text(label, style: context.typography.labelLarge),
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColor.gray100),
          onPressed: () => onSelected(title),
        );
    return Wrap(
      spacing: edge * 0.3,
      runSpacing: edge * 0.3,
      children: [
        for (final preset in presets) chip(preset, GuestTitle.preset(preset)),
        chip('guests_title_none'.tr(), const GuestTitle.none()),
      ],
    );
  }
}

class _ReviewRowCard extends StatefulWidget {
  const _ReviewRowCard({super.key, required this.row});

  final DraftGuest row;

  @override
  State<_ReviewRowCard> createState() => _ReviewRowCardState();
}

class _ReviewRowCardState extends State<_ReviewRowCard> {
  late final _nameController = TextEditingController(text: widget.row.name);
  late final _phoneController =
      TextEditingController(text: widget.row.phoneInput);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _update(DraftGuest row, {bool titleChanged = false}) => context
      .read<ContactsPickerCubit>()
      .updateReviewRow(row, titleChanged: titleChanged);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ContactsPickerCubit>();
    final row = widget.row;
    final issue = cubit.reviewIssue(row);
    final country = PhoneNumberHelper.countryForRegion(row.countryRegion);

    return Container(
      margin: EdgeInsets.only(bottom: edge * 0.5),
      padding: EdgeInsets.all(edge * 0.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radiusInput),
        border: Border.all(
          color: issue == null ? AppColor.gray100 : AppColor.semanticError,
          width: issue == null ? 1 : 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: GuestTitleField(
                  dense: true,
                  value: cubit.isUntitled(row) ? null : row.title,
                  onChanged: (title) {
                    if (title == null) return;
                    _update(row.copyWith(title: title), titleChanged: true);
                  },
                ),
              ),
              SizedBox(width: edge * 0.3),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _nameController,
                  style: context.typography.inputText,
                  onChanged: (name) => _update(row.copyWith(name: name)),
                  decoration: guestInputDecoration(context,
                      hint: 'guests_name_hint'.tr(), dense: true),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                color: AppColor.gray400,
                onPressed: () => cubit.removeReviewRow(row.localId),
              ),
            ],
          ),
          SizedBox(height: edge * 0.3),
          PhoneCountryField(
            controller: _phoneController,
            country: country,
            dense: true,
            isValid: row.phoneDigits != null,
            onChanged: (phone) => _update(row.copyWith(phoneInput: phone)),
            onCountryChanged: (picked) =>
                _update(row.copyWith(countryRegion: () => picked?.region)),
          ),
          if (issue != null) ...[
            SizedBox(height: edge * 0.3),
            Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 14, color: AppColor.semanticError),
                SizedBox(width: edge * 0.2),
                Expanded(
                  child: Text(
                    issue.tr(args: ['${GuestValidation.maxNameLength}']),
                    style: context.typography.labelMedium
                        .copyWith(color: AppColor.semanticError),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
