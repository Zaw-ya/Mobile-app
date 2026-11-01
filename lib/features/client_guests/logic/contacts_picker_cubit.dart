import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/phone_number_helper.dart';
import '../data/contacts/device_contacts_service.dart';
import '../data/models/draft_guest.dart';
import '../data/models/guest_requests.dart';
import '../data/models/guest_title.dart';
import 'contacts_picker_states.dart';
import 'guest_validation.dart';

/// Picking guests from the device contacts, then reviewing them before they
/// go to the draft. Numbers are never converted: a local number stays
/// flagged until the client edits it or picks a country for that row.
class ContactsPickerCubit extends Cubit<ContactsPickerStates> {
  final DeviceContactsService _contacts;

  ContactsPickerCubit(this._contacts)
      : super(const ContactsPickerStates.initial());

  ContactsAccess _access = ContactsAccess.notDetermined;
  List<PickedContact> _all = [];
  String _query = '';
  Set<String> _taken = {};
  int _revision = 0;

  /// Contact id → the chosen number.
  final Map<String, String> _selected = {};

  List<DraftGuest> _review = [];

  /// Review rows still waiting for a title.
  final Set<String> _untitled = {};

  /// Review rows whose title came from "apply to all", so a later
  /// "apply to all" may change them again.
  final Set<String> _bulkTitled = {};

  ContactsAccess get access => _access;
  bool get isLimited => _access == ContactsAccess.limited;
  String get query => _query;
  int get selectedCount => _selected.length;
  bool get hasContacts => _all.isNotEmpty;

  // ── Access ────────────────────────────────────────────────────────────────

  /// [taken] are the numbers already on the list or in the draft.
  Future<void> start(Set<String> taken) async {
    _taken = taken;
    _access = await _contacts.check();
    await _loadIfAllowed();
  }

  Future<void> requestAccess() async {
    _access = await _contacts.request();
    await _loadIfAllowed();
  }

  Future<void> openSettings() => _contacts.openSettings();

  /// Back from the device settings: continue if access was granted there.
  Future<void> recheck() async {
    if (_all.isNotEmpty) return;
    final access = await _contacts.check();
    if (access == _access) return;
    _access = access;
    await _loadIfAllowed();
  }

  Future<void> _loadIfAllowed() async {
    if (_access != ContactsAccess.granted &&
        _access != ContactsAccess.limited) {
      if (!isClosed) emit(ContactsPickerStates.noAccess(access: _access));
      return;
    }
    if (!isClosed) emit(const ContactsPickerStates.loading());
    try {
      _all = await _contacts.load();
      _emitLoaded();
    } catch (e) {
      debugPrint('Loading contacts failed: $e');
      if (!isClosed) {
        emit(ContactsPickerStates.error(message: 'some_error'.tr()));
      }
    }
  }

  // ── Picking ───────────────────────────────────────────────────────────────

  List<PickedContact> get visibleContacts {
    if (_query.isEmpty) return _all;
    final q = normalizeForSearch(_query);
    final digits = PhoneNumberHelper.cleanDigits(_query);
    return _all
        .where((c) =>
            normalizeForSearch(c.name).contains(q) ||
            (digits.length >= 3 &&
                c.phones.any(
                    (p) => PhoneNumberHelper.cleanDigits(p).contains(digits))))
        .toList();
  }

  void search(String query) {
    _query = query.trim();
    _emitLoaded();
  }

  bool isSelected(PickedContact contact) => _selected.containsKey(contact.id);

  String? selectedPhone(PickedContact contact) => _selected[contact.id];

  /// True when the number is valid and already on the list or in the draft.
  bool isTaken(String phone) {
    final digits = PhoneNumberHelper.validateAndNormalize(phone).phone?.digits;
    return digits != null && _taken.contains(digits);
  }

  /// Phones of [contact] that can still be added.
  List<String> freePhones(PickedContact contact) =>
      contact.phones.where((p) => !isTaken(p)).toList();

  /// Selects [contact] with [phone] (or its first free number), or
  /// unselects it. False when the batch limit is reached.
  bool toggle(PickedContact contact, {String? phone}) {
    if (_selected.containsKey(contact.id) && phone == null) {
      _selected.remove(contact.id);
      _emitLoaded();
      return true;
    }
    final free = freePhones(contact);
    final chosen = phone ?? (free.isEmpty ? null : free.first);
    if (chosen == null) return true;
    if (!_selected.containsKey(contact.id) &&
        _selected.length >= AddGuestsRequest.maxBatchSize) {
      return false;
    }
    _selected[contact.id] = chosen;
    _emitLoaded();
    return true;
  }

  /// Selects every visible contact that still has a free number.
  /// False when the batch limit stopped it.
  bool selectAllVisible() {
    for (final contact in visibleContacts) {
      if (_selected.containsKey(contact.id)) continue;
      final free = freePhones(contact);
      if (free.isEmpty) continue;
      if (_selected.length >= AddGuestsRequest.maxBatchSize) {
        _emitLoaded();
        return false;
      }
      _selected[contact.id] = free.first;
    }
    _emitLoaded();
    return true;
  }

  void clearSelection() {
    _selected.clear();
    _emitLoaded();
  }

  // ── Review ────────────────────────────────────────────────────────────────

  List<DraftGuest> get reviewRows => List.unmodifiable(_review);

  /// Builds the review rows from the selection. A known title in the
  /// contact name is taken off and preselected.
  void startReview() {
    final stamp = DateTime.now().microsecondsSinceEpoch;
    var i = 0;
    _untitled.clear();
    _bulkTitled.clear();
    _review = [
      for (final contact in _all)
        if (_selected.containsKey(contact.id))
          _rowFor(contact, '$stamp-${i++}'),
    ];
    _emitLoaded();
  }

  DraftGuest _rowFor(PickedContact contact, String localId) {
    final (title, name) = GuestTitles.split(contact.name);
    final hasTitle = title.kind != GuestTitleKind.none;
    if (!hasTitle) _untitled.add(localId);
    return DraftGuest(
      localId: localId,
      title: title,
      name: name,
      phoneInput: _selected[contact.id]!,
      source: DraftGuest.sourceContacts,
    );
  }

  bool isUntitled(DraftGuest row) => _untitled.contains(row.localId);

  /// Gives [title] to the rows without one, and to rows titled by an earlier
  /// "apply to all"; titles picked on a row stay.
  void applyTitleToAll(GuestTitle title) {
    _review = [
      for (final row in _review)
        if (_untitled.contains(row.localId) ||
            _bulkTitled.contains(row.localId))
          row.copyWith(title: title)
        else
          row,
    ];
    for (final row in _review) {
      if (_untitled.remove(row.localId)) _bulkTitled.add(row.localId);
    }
    _emitLoaded();
  }

  void updateReviewRow(DraftGuest row, {bool titleChanged = false}) {
    if (titleChanged) {
      _untitled.remove(row.localId);
      _bulkTitled.remove(row.localId);
    }
    _review = [
      for (final r in _review) r.localId == row.localId ? row : r,
    ];
    _emitLoaded();
  }

  void removeReviewRow(String localId) {
    _review = _review.where((r) => r.localId != localId).toList();
    _untitled.remove(localId);
    _bulkTitled.remove(localId);
    _emitLoaded();
  }

  /// Translation key of what is wrong with [row], or null when it can be added.
  String? reviewIssue(DraftGuest row) {
    if (isUntitled(row)) return 'guests_title_required';
    final titleIssue = GuestValidation.title(row.title);
    if (titleIssue != null) return titleIssue;
    final nameIssue = GuestValidation.name(row.title, row.name);
    if (nameIssue != null) return nameIssue;
    final phoneIssue = GuestValidation.phone(row.phoneCheck);
    if (phoneIssue != null) return phoneIssue;
    final digits = row.phoneDigits!;
    if (_taken.contains(digits)) return 'guests_err_duplicate_phone';
    final sameNumber = _review.where((r) => r.phoneDigits == digits);
    if (sameNumber.first.localId != row.localId) {
      return 'guests_phone_duplicate_in_review';
    }
    return null;
  }

  /// Rows sorted with the ones needing a fix first.
  List<DraftGuest> get reviewRowsSorted {
    final rows = [..._review];
    rows.sort((a, b) => (reviewIssue(a) == null ? 1 : 0)
        .compareTo(reviewIssue(b) == null ? 1 : 0));
    return rows;
  }

  int get reviewIssueCount =>
      _review.where((r) => reviewIssue(r) != null).length;

  List<DraftGuest> get readyRows =>
      _review.where((r) => reviewIssue(r) == null).toList();

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Lower-case text with Arabic letter variants folded (أ/إ/آ → ا,
  /// ة → ه, ى → ي) and diacritics removed, for forgiving search.
  @visibleForTesting
  static String normalizeForSearch(String text) => text
      .toLowerCase()
      .replaceAll(RegExp('[ً-ٰٟـ]'), '')
      .replaceAll(RegExp('[أإآٱ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .trim();

  void _emitLoaded() {
    if (!isClosed) emit(ContactsPickerStates.loaded(revision: ++_revision));
  }
}
