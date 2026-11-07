import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/phone_number_helper.dart';
import '../../../core/helpers/search_normalizer.dart' as search_text;
import '../data/contacts/device_contacts_service.dart';
import '../data/local/recent_titles_storage.dart';
import '../data/models/draft_guest.dart';
import '../data/models/guest_requests.dart';
import '../data/models/guest_title.dart';
import 'contacts_picker_states.dart';
import 'guest_validation.dart';

/// The review's tabs: the rows waiting for a title, or all of them.
enum ReviewFilter { untitled, all }

/// Review rows sharing a title; the title is what makes them a group.
class ReviewTitleGroup {
  final GuestTitle title;
  final List<DraftGuest> rows;

  const ReviewTitleGroup(this.title, this.rows);
}

/// Picking guests from the device contacts, then reviewing them before they
/// go to the draft. Numbers are never converted: a local number stays
/// flagged until the client edits it or picks a country for that row.
class ContactsPickerCubit extends Cubit<ContactsPickerStates> {
  final DeviceContactsService _contacts;
  final RecentTitlesStorage _recentTitles;

  ContactsPickerCubit(this._contacts, this._recentTitles)
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

  /// Review rows ticked for a group title.
  final Set<String> _reviewSelected = {};

  /// Review row → the contact and number it came from.
  Map<String, String> _reviewOrigin = {};
  ReviewFilter _reviewFilter = ReviewFilter.untitled;
  String _reviewQuery = '';
  List<String> _recent = [];

  ContactsAccess get access => _access;
  bool get isLimited => _access == ContactsAccess.limited;
  String get query => _query;
  int get selectedCount => _selected.length;
  bool get hasContacts => _all.isNotEmpty;

  // ── Access ────────────────────────────────────────────────────────────────

  /// [taken] are the numbers already on the list or in the draft.
  Future<void> start(Set<String> taken) async {
    _taken = taken;
    _recent = await _recentTitles.load();
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

  ReviewFilter get reviewFilter => _reviewFilter;
  String get reviewQuery => _reviewQuery;
  int get untitledCount => _untitled.length;
  int get reviewSelectedCount => _reviewSelected.length;

  /// Rows of the current tab that match the review search.
  List<DraftGuest> get reviewVisibleRows {
    final q = normalizeForSearch(_reviewQuery);
    final digits = PhoneNumberHelper.cleanDigits(_reviewQuery);
    return _review.where((row) {
      if (_reviewFilter == ReviewFilter.untitled && !isUntitled(row)) {
        return false;
      }
      if (_reviewQuery.isEmpty) return true;
      return normalizeForSearch(row.name).contains(q) ||
          (digits.length >= 3 &&
              PhoneNumberHelper.cleanDigits(row.phoneInput).contains(digits));
    }).toList();
  }

  /// Visible rows that have a title, grouped by it; "no title" comes last.
  List<ReviewTitleGroup> get reviewGroups {
    final groups = <GuestTitle, List<DraftGuest>>{};
    for (final row in reviewVisibleRows) {
      if (!isUntitled(row)) groups.putIfAbsent(row.title, () => []).add(row);
    }
    final none = groups.remove(const GuestTitle.none());
    return [
      for (final entry in groups.entries)
        ReviewTitleGroup(entry.key, entry.value),
      if (none != null) ReviewTitleGroup(const GuestTitle.none(), none),
    ];
  }

  /// Builds the review rows from the selection. A known title in the contact
  /// name is taken off and preselected. Rows that are still valid keep what
  /// was done to them, so going back to pick one more contact loses nothing.
  void startReview() {
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final previous = {
      for (final row in _review) _reviewOrigin[row.localId]: row,
    };
    final wasUntitled = _untitled.toSet();
    final origins = <String, String>{};
    final rows = <DraftGuest>[];
    var i = 0;
    _untitled.clear();
    for (final contact in _all) {
      if (!_selected.containsKey(contact.id)) continue;
      final origin = '${contact.id}|${_selected[contact.id]}';
      final kept = previous[origin];
      final row = kept ?? _rowFor(contact, '$stamp-${i++}');
      if (kept != null && wasUntitled.contains(kept.localId)) {
        _untitled.add(kept.localId);
      }
      origins[row.localId] = origin;
      rows.add(row);
    }
    _reviewOrigin = origins;
    _review = rows;
    _reviewSelected.clear();
    _reviewQuery = '';
    // Rows needing a fix come first, and stay put while the client edits
    _review = [
      ...rows.where((r) => reviewContentIssue(r) != null),
      ...rows.where((r) => reviewContentIssue(r) == null),
    ];
    _reviewFilter =
        _untitled.isEmpty ? ReviewFilter.all : ReviewFilter.untitled;
    _emitLoaded();
  }

  DraftGuest _rowFor(PickedContact contact, String localId) {
    final (title, name) = GuestTitles.split(contact.name);
    // A number with its own code is shown as country + national number
    final phone = PhoneNumberHelper.splitForField(_selected[contact.id]);
    final hasTitle = title.kind != GuestTitleKind.none;
    if (!hasTitle) _untitled.add(localId);
    return DraftGuest(
      localId: localId,
      title: title,
      name: name,
      phoneInput: phone.text,
      countryRegion: phone.country?.region,
      source: DraftGuest.sourceContacts,
    );
  }

  bool isUntitled(DraftGuest row) => _untitled.contains(row.localId);

  void setReviewFilter(ReviewFilter filter) {
    if (filter == _reviewFilter) return;
    _reviewFilter = filter;
    _reviewSelected.clear();
    _emitLoaded();
  }

  void searchReview(String query) {
    _reviewQuery = query.trim();
    _emitLoaded();
  }

  bool isReviewSelected(DraftGuest row) =>
      _reviewSelected.contains(row.localId);

  void toggleReviewSelected(DraftGuest row) {
    if (!_reviewSelected.remove(row.localId)) {
      _reviewSelected.add(row.localId);
    }
    _emitLoaded();
  }

  bool get allReviewVisibleSelected {
    final visible = reviewVisibleRows;
    return visible.isNotEmpty && visible.every(isReviewSelected);
  }

  /// Selects every visible row, or unselects them when all are selected.
  void toggleAllReviewVisible() {
    final ids = reviewVisibleRows.map((r) => r.localId);
    if (allReviewVisibleSelected) {
      _reviewSelected.removeAll(ids);
    } else {
      _reviewSelected.addAll(ids);
    }
    _emitLoaded();
  }

  /// Gives [title] to the selected rows, whatever title they had.
  Future<void> applyTitleToSelected(GuestTitle title) async {
    _setTitle(_reviewSelected.toSet(), title);
    _reviewSelected.clear();
    if (_untitled.isEmpty) _reviewFilter = ReviewFilter.all;
    await rememberTitle(title);
    _emitLoaded();
  }

  /// Gives [title] to the rows still waiting for one.
  void applyTitleToUntitled(GuestTitle title) {
    _setTitle(_untitled.toSet(), title);
    _reviewFilter = ReviewFilter.all;
    _emitLoaded();
  }

  /// Changes the title of every row that has [from].
  Future<void> renameReviewTitle(GuestTitle from, GuestTitle to) async {
    _setTitle({
      for (final row in _review)
        if (!isUntitled(row) && row.title == from) row.localId,
    }, to);
    await rememberTitle(to);
    _emitLoaded();
  }

  void _setTitle(Set<String> ids, GuestTitle title) {
    final normalized = GuestTitles.fromText(title.text);
    _review = [
      for (final row in _review)
        if (ids.contains(row.localId))
          row.copyWith(title: normalized)
        else
          row,
    ];
    _untitled.removeAll(ids);
  }

  void updateReviewRow(DraftGuest row, {bool titleChanged = false}) {
    if (titleChanged) _untitled.remove(row.localId);
    _review = [
      for (final r in _review) r.localId == row.localId ? row : r,
    ];
    _emitLoaded();
  }

  void removeReviewRow(String localId) {
    _review = _review.where((r) => r.localId != localId).toList();
    _untitled.remove(localId);
    _reviewSelected.remove(localId);
    _emitLoaded();
  }

  /// Translation key of what is wrong with [row], or null when it can be added.
  String? reviewIssue(DraftGuest row) {
    if (isUntitled(row)) return 'guests_title_required';
    return GuestValidation.title(row.title) ?? reviewContentIssue(row);
  }

  /// Like [reviewIssue], without the row's title choice.
  String? reviewContentIssue(DraftGuest row) {
    final title = isUntitled(row) ? const GuestTitle.none() : row.title;
    final nameIssue = GuestValidation.name(title, row.name);
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

  int get reviewContentIssueCount =>
      _review.where((r) => reviewContentIssue(r) != null).length;

  int get reviewIssueCount =>
      _review.where((r) => reviewIssue(r) != null).length;

  List<DraftGuest> get readyRows =>
      _review.where((r) => reviewIssue(r) == null).toList();

  // ── Recent titles ─────────────────────────────────────────────────────────

  List<String> get recentTitles => List.unmodifiable(_recent);

  Future<void> rememberTitle(GuestTitle title) async {
    _recent = await _recentTitles.remember(title);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Kept for the tests; the rule lives in core/helpers/search_normalizer.
  @visibleForTesting
  static String normalizeForSearch(String text) =>
      search_text.normalizeForSearch(text);

  void _emitLoaded() {
    if (!isClosed) emit(ContactsPickerStates.loaded(revision: ++_revision));
  }
}
