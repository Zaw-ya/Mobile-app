import 'package:app/core/theming/typography_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/helpers/phone_number_helper.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/drag_handle.dart';
import '../../data/models/draft_guest.dart';
import '../../data/models/event_guests_response.dart';
import '../../data/models/guest_requests.dart';
import '../../data/models/guest_title.dart';
import '../../logic/guest_validation.dart';
import '../../logic/manage_guests_cubit.dart';
import '../../logic/manage_guests_states.dart';
import 'guest_button_pair.dart';
import 'guest_dialogs.dart';
import 'guest_input_decoration.dart';
import 'guest_title_field.dart';
import 'phone_country_field.dart';

/// Add a guest to the draft, edit a draft row, or edit a guest already on
/// the list (saved straight to the server).
class GuestFormSheet extends StatefulWidget {
  const GuestFormSheet._({this.draftRow, this.serverGuest});

  final DraftGuest? draftRow;
  final ClientGuest? serverGuest;

  static Future<void> show(BuildContext context,
      {DraftGuest? draftRow, ClientGuest? serverGuest}) {
    final cubit = context.read<ManageGuestsCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.primaryLight,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(containerRadius)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: GuestFormSheet._(draftRow: draftRow, serverGuest: serverGuest),
      ),
    );
  }

  @override
  State<GuestFormSheet> createState() => _GuestFormSheetState();
}

class _GuestFormSheetState extends State<GuestFormSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  GuestTitle? _title;
  PhoneCountry? _country;
  int _members = 1;
  bool _submitted = false;

  bool get _isServer => widget.serverGuest != null;
  bool get _isNew => widget.draftRow == null && widget.serverGuest == null;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ManageGuestsCubit>();
    final row = widget.draftRow;
    final guest = widget.serverGuest;
    if (row != null) {
      _title = row.title;
      _nameController.text = row.name;
      _country = PhoneNumberHelper.countryForRegion(row.countryRegion);
      // Same display rule as everywhere: an own code goes to the chip
      final phone = _country == null
          ? PhoneNumberHelper.splitForField(row.phoneInput)
          : PhoneFieldValue(country: _country, text: row.phoneInput);
      _country = phone.country;
      _phoneController.text = phone.text;
      _members = row.noOfMembers;
    } else if (guest != null) {
      final (title, name) = guest.titleAndName;
      _title = title;
      _nameController.text = name;
      // Code in the chip, national number in the field
      final phone = PhoneNumberHelper.splitForField('+${guest.phoneDigits}');
      _country = phone.country;
      _phoneController.text = phone.text;
      _members = guest.noOfMembers ?? 1;
    } else {
      _country = cubit.defaultCountry;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  PhoneCheck get _phoneCheck => _country == null
      ? PhoneNumberHelper.validateAndNormalize(_phoneController.text)
      : PhoneNumberHelper.validateWithCountry(_phoneController.text, _country!);

  String? get _titleError =>
      _submitted ? GuestValidation.title(_title)?.tr() : null;

  String? get _nameError => _submitted
      ? GuestValidation.name(_title, _nameController.text)
          ?.tr(args: ['${GuestValidation.maxNameLength}'])
      : null;

  String? get _phoneError {
    if (!_submitted) return null;
    final check = _phoneCheck;
    final issue = GuestValidation.phone(check);
    if (issue != null) return issue.tr();
    final duplicate = context.read<ManageGuestsCubit>().duplicateOf(
          check.phone!.digits,
          exceptLocalId: widget.draftRow?.localId,
          exceptGuestId: widget.serverGuest?.guestId,
        );
    return duplicate == null
        ? null
        : 'guests_phone_duplicate'.tr(args: [duplicate]);
  }

  bool _validate() {
    setState(() => _submitted = true);
    return _titleError == null && _nameError == null && _phoneError == null;
  }

  String get _cleanName =>
      GuestTitles.stripRepeatedTitle(_title!, _nameController.text);

  DraftGuest _toDraft(String localId) => DraftGuest(
        localId: localId,
        title: _title!,
        name: _cleanName,
        phoneInput: _phoneController.text.trim(),
        countryRegion: _country?.region,
        noOfMembers: _members,
        source: widget.draftRow?.source ?? DraftGuest.sourceManual,
      );

  void _addToDraft({required bool another}) {
    if (!_validate()) return;
    final cubit = context.read<ManageGuestsCubit>();
    cubit.addToDraft(
        [_toDraft(DateTime.now().microsecondsSinceEpoch.toString())]);
    cubit.rememberTitle(_title!);
    if (!another) {
      Navigator.of(context).pop();
      return;
    }
    // Keep the title and the country for the next guest
    setState(() {
      _submitted = false;
      _nameController.clear();
      _phoneController.clear();
      _members = 1;
    });
    _nameFocus.requestFocus();
  }

  void _saveDraftRow() {
    if (!_validate()) return;
    final cubit = context.read<ManageGuestsCubit>();
    cubit.updateDraft(_toDraft(widget.draftRow!.localId));
    cubit.rememberTitle(_title!);
    Navigator.of(context).pop();
  }

  Future<void> _saveServer() async {
    if (!_validate()) return;
    final navigator = Navigator.of(context);
    final cubit = context.read<ManageGuestsCubit>();
    final ok = await cubit.updateGuest(
      widget.serverGuest!.guestId!,
      GuestInput(
        name: GuestTitles.compose(_title!, _cleanName),
        phone: _phoneCheck.phone!.digits,
        noOfMembers: _members,
        title: GuestTitles.wireText(_title!),
      ),
    );
    if (ok) await cubit.rememberTitle(_title!);
    if (ok && mounted) navigator.pop();
  }

  Future<void> _delete() async {
    final cubit = context.read<ManageGuestsCubit>();
    final navigator = Navigator.of(context);
    if (!_isServer) {
      cubit.removeFromDraft([widget.draftRow!.localId]);
      navigator.pop();
      return;
    }
    final confirmed = await showGuestsConfirmDialog(
      context,
      title: 'guests_delete_guest'.tr(),
      body: 'guests_delete_confirm'.tr(args: [widget.serverGuest!.name ?? '']),
      confirmText: 'delete'.tr(),
      destructive: true,
    );
    if (!confirmed) return;
    final ok = await cubit.deleteGuest(widget.serverGuest!.guestId!);
    if (ok && mounted) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final preview = _title == null || _nameController.text.trim().isEmpty
        ? null
        : GuestTitles.compose(_title!, _nameController.text);

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
              Text(_isNew ? 'guests_add_one'.tr() : 'guests_edit_one'.tr(),
                  style: context.typography.titleLarge),
              SizedBox(height: edge * 0.6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _Labeled(
                      label: 'guests_title'.tr(),
                      child: GuestTitleField(
                        value: _title,
                        recentTitles:
                            context.read<ManageGuestsCubit>().recentTitles,
                        errorText: _titleError,
                        onChanged: (title) => setState(() => _title = title),
                      ),
                    ),
                  ),
                  SizedBox(width: edge * 0.4),
                  Expanded(
                    flex: 3,
                    child: _Labeled(
                      label: 'guests_name'.tr(),
                      child: TextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        autofocus: _isNew,
                        textCapitalization: TextCapitalization.words,
                        style: context.typography.inputText,
                        onChanged: (_) => setState(() {}),
                        decoration: guestInputDecoration(context,
                            hint: 'guests_name_hint'.tr(),
                            errorText: _nameError),
                      ),
                    ),
                  ),
                ],
              ),
              if (preview != null) ...[
                SizedBox(height: edge * 0.3),
                Text('guests_card_preview'.tr(args: [preview]),
                    style: context.typography.labelMedium),
              ],
              SizedBox(height: edge * 0.6),
              _Labeled(
                label: 'guests_phone'.tr(),
                child: PhoneCountryField(
                  controller: _phoneController,
                  country: _country,
                  errorText: _phoneError,
                  isValid: _phoneCheck.isValid,
                  onChanged: (_) => setState(() {}),
                  onCountryChanged: (country) =>
                      setState(() => _country = country),
                ),
              ),
              SizedBox(height: edge * 0.6),
              _Labeled(
                label: 'guests_members'.tr(),
                child: _MembersStepper(
                  value: _members,
                  onChanged: (value) => setState(() => _members = value),
                ),
              ),
              SizedBox(height: edge),
              BlocBuilder<ManageGuestsCubit, ManageGuestsStates>(
                builder: (context, state) => _buttons(state is ActionLoading),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttons(bool busy) {
    if (_isNew) {
      return GuestButtonPair(
        secondaryText: 'guests_add_another'.tr(),
        secondaryColor: Colors.white,
        onSecondary: () => _addToDraft(another: true),
        primaryText: 'guests_add_btn'.tr(),
        onPrimary: () => _addToDraft(another: false),
      );
    }
    return Column(
      children: [
        busy
            ? CustomButton.loading(
                text: 'guests_save_changes'.tr(), color: AppColor.primaryDark)
            : CustomButton.normal(
                text: 'guests_save_changes'.tr(),
                color: AppColor.primaryDark,
                textStyle: guestButtonTextStyle(context),
                onPressed: _isServer ? _saveServer : _saveDraftRow,
              ),
        TextButton(
          onPressed: busy ? null : _delete,
          child: Text(
            _isServer
                ? 'guests_delete_guest'.tr()
                : 'guests_remove_from_draft'.tr(),
            style: context.typography.titleSmall
                .copyWith(color: AppColor.semanticError),
          ),
        ),
      ],
    );
  }
}

class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.typography.inputLabel),
        SizedBox(height: edge * 0.3),
        child,
      ],
    );
  }
}

class _MembersStepper extends StatelessWidget {
  const _MembersStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget step(IconData icon, int next) => IconButton(
          icon: Icon(icon, size: 18),
          color: AppColor.primaryDark,
          onPressed: next < 1 || next > GuestValidation.maxMembers
              ? null
              : () => onChanged(next),
        );

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radiusInput),
        border: Border.all(color: AppColor.gray100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          step(Icons.remove_rounded, value - 1),
          Text('$value', style: context.typography.numericMedium),
          step(Icons.add_rounded, value + 1),
        ],
      ),
    );
  }
}
