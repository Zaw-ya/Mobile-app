import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../data/models/guest_title.dart';
import 'guest_input_decoration.dart';

/// Title dropdown: the presets of the current language, "custom" (typed
/// title) and "no title". [value] null means nothing was chosen yet.
class GuestTitleField extends StatefulWidget {
  const GuestTitleField({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.dense = false,
  });

  final GuestTitle? value;

  /// Null when the client goes back from a custom title to the list.
  final ValueChanged<GuestTitle?> onChanged;
  final String? errorText;
  final bool dense;

  @override
  State<GuestTitleField> createState() => _GuestTitleFieldState();
}

class _GuestTitleFieldState extends State<GuestTitleField> {
  static const String _custom = '__custom';
  static const String _none = '__none';

  late final TextEditingController _customController = TextEditingController(
      text: widget.value?.kind == GuestTitleKind.custom
          ? widget.value!.text
          : '');

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String? get _selected => switch (widget.value?.kind) {
        null => null,
        GuestTitleKind.preset => widget.value!.text,
        GuestTitleKind.custom => _custom,
        GuestTitleKind.none => _none,
      };

  @override
  Widget build(BuildContext context) {
    // The single source of the list (see GuestTitles.presetsFor)
    final presets = [...GuestTitles.presetsFor(context.locale.languageCode)];
    // A title split off a saved name may come from the other language
    if (widget.value?.kind == GuestTitleKind.preset &&
        !presets.contains(widget.value!.text)) {
      presets.add(widget.value!.text);
    }

    if (widget.value?.kind == GuestTitleKind.custom) {
      return TextField(
        controller: _customController,
        autofocus: _customController.text.isEmpty,
        style: context.typography.inputText,
        maxLength: 30,
        onChanged: (text) => widget.onChanged(GuestTitle.custom(text)),
        decoration: guestInputDecoration(
          context,
          hint: 'guests_title_custom_hint'.tr(),
          errorText: widget.errorText,
          dense: widget.dense,
          suffix: IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: AppColor.gray500,
            tooltip: 'guests_title_select'.tr(),
            onPressed: () => widget.onChanged(null),
          ),
        ).copyWith(counterText: ''),
      );
    }

    return DropdownButtonFormField<String>(
      // Rebuilt when the title changes from outside (e.g. "apply to all")
      key: ValueKey(_selected),
      initialValue: _selected,
      isExpanded: true,
      borderRadius: BorderRadius.circular(radiusInner),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColor.gray500),
      style: context.typography.inputText,
      hint: Text('guests_title_select'.tr(),
          style: context.typography.inputHint, overflow: TextOverflow.ellipsis),
      decoration: guestInputDecoration(context,
          errorText: widget.errorText, dense: widget.dense),
      items: [
        for (final preset in presets)
          DropdownMenuItem(value: preset, child: Text(preset)),
        DropdownMenuItem(
            value: _custom, child: Text('guests_title_custom'.tr())),
        DropdownMenuItem(value: _none, child: Text('guests_title_none'.tr())),
      ],
      onChanged: (value) {
        if (value == null) return;
        widget.onChanged(switch (value) {
          _custom => GuestTitle.custom(_customController.text),
          _none => const GuestTitle.none(),
          _ => GuestTitle.preset(value),
        });
      },
    );
  }
}
