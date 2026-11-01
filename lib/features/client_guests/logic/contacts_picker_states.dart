import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/contacts/device_contacts_service.dart';

part 'contacts_picker_states.freezed.dart';

@Freezed()
class ContactsPickerStates with _$ContactsPickerStates {
  const factory ContactsPickerStates.initial() = _Initial;
  const factory ContactsPickerStates.loading() = Loading;

  /// Contacts can't be read yet; the screen explains or asks.
  const factory ContactsPickerStates.noAccess(
      {required ContactsAccess access}) = NoAccess;

  /// Selection or review rows changed.
  const factory ContactsPickerStates.loaded({required int revision}) = Loaded;
  const factory ContactsPickerStates.error({required String message}) = Error;
}
