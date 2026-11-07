import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/drag_handle.dart';
import '../../data/models/guest_title.dart';
import '../../data/repo/client_guests_repo.dart';
import '../../logic/manage_guests_cubit.dart';
import '../../logic/title_change_outcome.dart';
import 'guest_button_pair.dart';
import 'guest_input_decoration.dart';

Future<T?> _showTitleSheet<T>(BuildContext context, Widget child) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColor.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(containerRadius)),
      ),
      builder: (_) => child,
    );

/// A choice among titles or filters, in the app's colors.
class GuestChoiceChip extends StatelessWidget {
  const GuestChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label,
          style: context.typography.labelLarge
              .copyWith(color: selected ? AppColor.primaryLight : null)),
      selected: selected,
      showCheckmark: false,
      selectedColor: AppColor.primaryDark,
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColor.gray200),
      onSelected: (_) => onTap(),
    );
  }
}

/// Scrolls above the keyboard, so a small phone can still reach the button.
class _SheetBody extends StatelessWidget {
  const _SheetBody({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(edge, 0, edge, edge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const DragHandle(), ...children],
          ),
        ),
      ),
    );
  }
}

/// Picks one title for [count] guests: a preset, a recent custom title, a new
/// one, or "no title". Pops the title, or null when cancelled.
class GuestTitlePickerSheet extends StatefulWidget {
  const GuestTitlePickerSheet._({
    required this.count,
    required this.recentTitles,
    required this.names,
  });

  final int count;
  final List<String> recentTitles;
  final List<String> names;

  static Future<GuestTitle?> show(
    BuildContext context, {
    required int count,
    required List<String> recentTitles,
    List<String> names = const [],
  }) =>
      _showTitleSheet<GuestTitle>(
        context,
        GuestTitlePickerSheet._(
            count: count, recentTitles: recentTitles, names: names),
      );

  @override
  State<GuestTitlePickerSheet> createState() => _GuestTitlePickerSheetState();
}

class _GuestTitlePickerSheetState extends State<GuestTitlePickerSheet> {
  final _customController = TextEditingController();
  GuestTitle? _selected;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _pick(GuestTitle title) {
    _customController.clear();
    setState(() => _selected = title);
  }

  Widget _chip(String label, GuestTitle title) => GuestChoiceChip(
        label: label,
        selected: _selected == title,
        onTap: () => _pick(title),
      );

  Widget _section(String label, List<Widget> chips) {
    return Padding(
      padding: EdgeInsets.only(bottom: edge * 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.typography.inputLabel),
          SizedBox(height: edge * 0.3),
          Wrap(spacing: edge * 0.3, runSpacing: edge * 0.1, children: chips),
        ],
      ),
    );
  }

  String _applyLabel(GuestTitle? title) {
    final count = '${widget.count}';
    if (title == null) return 'guests_apply_title_count'.tr(args: [count]);
    if (title.kind == GuestTitleKind.none) {
      return 'guests_title_none_apply'.tr(args: [count]);
    }
    return 'guests_title_apply_to'.tr(args: [title.text, count]);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    final canApply = selected != null &&
        (selected.kind == GuestTitleKind.none ||
            GuestTitles.wireText(selected) != null);
    final names = widget.names.take(3).join('، ');

    return _SheetBody(
      children: [
        Text('guests_apply_title_count'.tr(args: ['${widget.count}']),
            style: context.typography.titleLarge),
        if (names.isNotEmpty)
          Text(names,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typography.bodySmall),
        SizedBox(height: edge * 0.6),
        _section('guests_titles_preset'.tr(), [
          for (final preset
              in GuestTitles.presetsFor(context.locale.languageCode))
            _chip(preset, GuestTitle.preset(preset)),
        ]),
        if (widget.recentTitles.isNotEmpty)
          _section('guests_titles_recent'.tr(), [
            for (final title in widget.recentTitles)
              _chip(title, GuestTitle.custom(title)),
          ]),
        Text('guests_title_new'.tr(), style: context.typography.inputLabel),
        SizedBox(height: edge * 0.3),
        TextField(
          controller: _customController,
          maxLength: 30,
          style: context.typography.inputText,
          onChanged: (text) =>
              setState(() => _selected = GuestTitles.fromText(text)),
          decoration:
              guestInputDecoration(context, hint: 'guests_title_custom_hint'.tr())
                  .copyWith(counterText: ''),
        ),
        SizedBox(height: edge * 0.5),
        _chip('guests_title_none'.tr(), const GuestTitle.none()),
        SizedBox(height: edge * 0.6),
        canApply
            ? CustomButton.normal(
                text: _applyLabel(selected),
                color: AppColor.primaryDark,
                textStyle: guestButtonTextStyle(context),
                onPressed: () => Navigator.of(context).pop(selected),
              )
            : CustomButton.disabled(
                text: _applyLabel(null), color: AppColor.gray200),
      ],
    );
  }
}

/// Changes a title for everyone who has it. Pops the new title, or null when
/// cancelled or left as it was.
class RenameTitleSheet extends StatefulWidget {
  const RenameTitleSheet._({
    required this.from,
    required this.count,
    required this.sampleName,
  });

  final GuestTitle from;
  final int count;
  final String? sampleName;

  static Future<GuestTitle?> show(
    BuildContext context, {
    required GuestTitle from,
    required int count,
    String? sampleName,
  }) =>
      _showTitleSheet<GuestTitle>(
        context,
        RenameTitleSheet._(from: from, count: count, sampleName: sampleName),
      );

  @override
  State<RenameTitleSheet> createState() => _RenameTitleSheetState();
}

class _RenameTitleSheetState extends State<RenameTitleSheet> {
  late final _controller = TextEditingController(text: widget.from.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = GuestTitles.fromText(_controller.text);
    final canApply =
        title.kind != GuestTitleKind.none && title != widget.from;
    final sample = widget.sampleName;

    return _SheetBody(
      children: [
        Text('guests_title_rename_of'.tr(args: [widget.from.text]),
            style: context.typography.titleLarge),
        SizedBox(height: edge * 0.6),
        Text('guests_title_new'.tr(), style: context.typography.inputLabel),
        SizedBox(height: edge * 0.3),
        TextField(
          controller: _controller,
          autofocus: true,
          maxLength: 30,
          style: context.typography.inputText,
          onChanged: (_) => setState(() {}),
          decoration:
              guestInputDecoration(context, hint: 'guests_title_custom_hint'.tr())
                  .copyWith(counterText: ''),
        ),
        if (sample != null && title.kind != GuestTitleKind.none) ...[
          SizedBox(height: edge * 0.4),
          Text('guests_card_preview'.tr(args: [GuestTitles.compose(title, sample)]),
              style: context.typography.labelMedium),
        ],
        SizedBox(height: edge * 0.4),
        Text('guests_title_rename_note'.tr(args: ['${widget.count}']),
            style: context.typography.bodySmall),
        SizedBox(height: edge * 0.8),
        canApply
            ? CustomButton.normal(
                text: 'guests_title_rename_apply'.tr(args: ['${widget.count}']),
                color: AppColor.primaryDark,
                textStyle: guestButtonTextStyle(context),
                onPressed: () => Navigator.of(context).pop(title),
              )
            : CustomButton.disabled(
                text: 'guests_title_rename_apply'.tr(args: ['${widget.count}']),
                color: AppColor.gray200),
      ],
    );
  }
}

/// What a title change on the list will do, before it's sent. True to apply.
class TitleChangeConfirmSheet extends StatelessWidget {
  const TitleChangeConfirmSheet._({
    required this.to,
    required this.updating,
    required this.locked,
  });

  final GuestTitle to;
  final int updating;
  final int locked;

  static Future<bool> show(
    BuildContext context, {
    required GuestTitle to,
    required int updating,
    required int locked,
  }) async {
    final confirmed = await _showTitleSheet<bool>(
      context,
      TitleChangeConfirmSheet._(to: to, updating: updating, locked: locked),
    );
    return confirmed ?? false;
  }

  Widget _countRow(BuildContext context, String label, int value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: edge * 0.4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: context.typography.bodyMedium)),
          Text('$value', style: context.typography.numericMedium),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SheetBody(
      children: [
        Text(
          to.kind == GuestTitleKind.none
              ? 'guests_title_remove'.tr()
              : 'guests_title_change_to'.tr(args: [to.text]),
          style: context.typography.titleLarge,
        ),
        SizedBox(height: edge * 0.5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: edge * 0.7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radiusInput),
            border: Border.all(color: AppColor.gray100),
          ),
          child: Column(
            children: [
              _countRow(context, 'guests_title_change_ok'.tr(), updating),
              if (locked > 0) ...[
                const Divider(height: 1, color: AppColor.gray100),
                _countRow(context, 'guests_title_change_locked'.tr(), locked),
              ],
            ],
          ),
        ),
        if (locked > 0) ...[
          SizedBox(height: edge * 0.4),
          Text('guests_title_change_note'.tr(),
              style: context.typography.bodySmall),
        ],
        SizedBox(height: edge * 0.8),
        updating > 0
            ? CustomButton.normal(
                text: 'guests_title_change_apply'.tr(args: ['$updating']),
                color: AppColor.primaryDark,
                textStyle: guestButtonTextStyle(context),
                onPressed: () => Navigator.of(context).pop(true),
              )
            : CustomButton.disabled(
                text: 'guests_title_change_apply'.tr(args: ['0']),
                color: AppColor.gray200),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('cancel'.tr(), style: context.typography.titleSmall),
        ),
      ],
    );
  }
}

/// Who changed, and who didn't and why.
class TitleChangeResultSheet extends StatelessWidget {
  const TitleChangeResultSheet._(this.outcome);

  final TitleChangeOutcome outcome;

  static Future<void> show(BuildContext context, TitleChangeOutcome outcome) =>
      _showTitleSheet<void>(context, TitleChangeResultSheet._(outcome));

  /// A name too long is the only invalid input this request can have.
  String _reason(String code) => code == GuestErrorCodes.invalidInput
      ? 'guests_title_too_long'.tr()
      : ManageGuestsCubit.messageFor(code);

  @override
  Widget build(BuildContext context) {
    return _SheetBody(
      children: [
        Text('guests_title_result_ok'.tr(args: ['${outcome.updated}']),
            style: context.typography.titleLarge),
        if (outcome.skipped.isNotEmpty) ...[
          SizedBox(height: edge * 0.6),
          Text('guests_title_result_skipped'
              .tr(args: ['${outcome.skipped.length}']),
              style: context.typography.titleSmall),
          SizedBox(height: edge * 0.3),
          for (final row in outcome.skipped)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: edge * 0.3),
              padding: EdgeInsets.all(edge * 0.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radiusInput),
                border: Border.all(color: AppColor.gray100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(row.name, style: context.typography.titleSmall),
                  Text(_reason(row.code),
                      style: context.typography.labelMedium),
                ],
              ),
            ),
        ],
        SizedBox(height: edge * 0.6),
        CustomButton.normal(
          text: 'close'.tr(),
          color: AppColor.primaryDark,
          textStyle: guestButtonTextStyle(context),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
