import 'package:flutter_contacts/flutter_contacts.dart';

/// Contacts permission, as the screens need it.
enum ContactsAccess {
  granted,

  /// iOS 18: only the contacts the client chose are visible.
  limited,
  notDetermined,
  denied,

  /// Only the device settings can grant it now.
  permanentlyDenied,

  /// Blocked by the system (e.g. parental controls).
  restricted,
}

/// A device contact that has at least one number.
class PickedContact {
  final String id;
  final String name;

  /// Numbers as saved in the contact, mobile ones first.
  final List<String> phones;

  const PickedContact(
      {required this.id, required this.name, required this.phones});
}

/// Read-only access to the device contacts (flutter_contacts).
class DeviceContactsService {
  Future<ContactsAccess> check() async =>
      _map(await FlutterContacts.permissions.check(PermissionType.read));

  Future<ContactsAccess> request() async =>
      _map(await FlutterContacts.permissions.request(PermissionType.read));

  Future<void> openSettings() => FlutterContacts.permissions.openSettings();

  /// Contacts with numbers, sorted by name. No photos, to stay fast.
  Future<List<PickedContact>> load() async {
    final contacts = await FlutterContacts.getAll(
      properties: {ContactProperty.name, ContactProperty.phone},
    );
    final picked = <PickedContact>[];
    for (final contact in contacts) {
      final phones = [...contact.phones]
        ..sort((a, b) => _rank(a.label.label).compareTo(_rank(b.label.label)));
      final numbers = <String>[];
      for (final phone in phones) {
        final number = phone.number.trim();
        if (number.isNotEmpty && !numbers.contains(number)) numbers.add(number);
      }
      final name = (contact.displayName ?? '').trim();
      if (numbers.isEmpty || contact.id == null) continue;
      picked.add(PickedContact(
          id: contact.id!,
          name: name.isEmpty ? numbers.first : name,
          phones: numbers));
    }
    picked.sort((a, b) => a.name.compareTo(b.name));
    return picked;
  }

  static int _rank(PhoneLabel label) => switch (label) {
        PhoneLabel.mobile || PhoneLabel.iPhone || PhoneLabel.workMobile => 0,
        PhoneLabel.main || PhoneLabel.home || PhoneLabel.work => 1,
        _ => 2,
      };

  static ContactsAccess _map(PermissionStatus status) => switch (status) {
        PermissionStatus.granted => ContactsAccess.granted,
        PermissionStatus.limited => ContactsAccess.limited,
        PermissionStatus.notDetermined => ContactsAccess.notDetermined,
        PermissionStatus.denied => ContactsAccess.denied,
        PermissionStatus.permanentlyDenied => ContactsAccess.permanentlyDenied,
        PermissionStatus.restricted => ContactsAccess.restricted,
      };
}
