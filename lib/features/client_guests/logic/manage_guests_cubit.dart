import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/phone_number_helper.dart';
import '../../../core/networking/api_result.dart';
import '../client_guests_flags.dart';
import '../data/local/guest_draft_storage.dart';
import '../data/local/recent_titles_storage.dart';
import '../data/models/draft_guest.dart';
import '../data/models/event_guests_response.dart';
import '../data/models/guest_op_response.dart';
import '../data/models/guest_requests.dart';
import '../data/models/guest_title.dart';
import '../data/repo/client_guests_repo.dart';
import 'manage_guests_states.dart';
import 'submit_outcome.dart';
import 'title_change_outcome.dart';

/// Guest list of one event: the server list, the local draft, the edit
/// deadline, adding the draft to the list and editing / deleting guests.
class ManageGuestsCubit extends Cubit<ManageGuestsStates> {
  final ClientGuestsRepo _repo;
  final GuestDraftStorage _drafts;
  final RecentTitlesStorage _recentTitles;

  /// Whether titles of guests already on the list can be used; see
  /// [ClientGuestsFlags.titlesOnListEnabled].
  final bool titlesOnList;

  ManageGuestsCubit(
    this._repo,
    this._drafts,
    this._recentTitles, {
    this.titlesOnList = ClientGuestsFlags.titlesOnListEnabled,
  }) : super(const ManageGuestsStates.initial());

  int _eventId = 0;
  EventGuestsResponse? _view;
  List<DraftGuest> _draft = [];
  bool _draftDirty = false;
  String _query = '';
  GuestTitle? _titleFilter;
  List<String> _recent = [];
  int _revision = 0;

  // ── Read ──────────────────────────────────────────────────────────────────

  bool get hasLoaded => _view != null;
  bool get canEdit => _view?.canEdit ?? false;
  String? get cannotEditCode => _view?.cannotEditCode;
  String? get supportWhatsappNumber => _view?.supportWhatsappNumber;
  List<DraftGuest> get draft => List.unmodifiable(_draft);
  bool get hasDraft => _draft.isNotEmpty;

  /// Any guest on the list, whatever the search.
  bool get hasGuests => (_view?.guests ?? const []).isNotEmpty;
  bool get isDraftDirty => _draftDirty;
  String get query => _query;

  /// Deadline as sent (event-local wall time), for DateTimeHelper.
  String? get deadlineLocalText => _view?.editDeadlineLocal;

  /// Deadline as event-local wall time: shown as-is, never converted.
  DateTime? get deadlineLocal =>
      DateTime.tryParse(_view?.editDeadlineLocal ?? '');

  DateTime? get deadlineUtc =>
      DateTime.tryParse(_view?.editDeadlineUtc ?? '')?.toUtc();

  /// Preselected country for typed numbers, from the event's time zone.
  PhoneCountry? get defaultCountry =>
      PhoneNumberHelper.countryForTimeZone(_view?.timeZoneId);

  /// Server guests matching the search and the title filter, newest first.
  List<ClientGuest> get guests {
    final all = [...?_view?.guests]
      ..sort((a, b) => (b.guestId ?? 0).compareTo(a.guestId ?? 0));
    return all.where((g) {
      if (titlesOnList && !_matchesTitle(g.titleAndName.$1)) return false;
      return _query.isEmpty || _matches(g.name ?? '', g.phoneDigits);
    }).toList();
  }

  List<DraftGuest> get filteredDraft => _draft.where((d) {
        if (!_matchesTitle(d.title)) return false;
        return _query.isEmpty ||
            _matches(d.fullName, d.phoneDigits ?? d.phoneInput);
      }).toList();

  GuestTitle? get titleFilter => _titleFilter;

  bool _matchesTitle(GuestTitle title) =>
      _titleFilter == null || title == _titleFilter;

  /// Every title in use and how many guests have it: the draft, and the list
  /// too once titles on the list are available.
  Map<GuestTitle, int> get titleCounts {
    final counts = <GuestTitle, int>{};
    void count(GuestTitle title) =>
        counts[title] = (counts[title] ?? 0) + 1;
    for (final row in _draft) {
      count(row.title);
    }
    if (titlesOnList) {
      for (final guest in _view?.guests ?? const <ClientGuest>[]) {
        count(guest.titleAndName.$1);
      }
    }
    return counts;
  }

  List<String> get recentTitles => List.unmodifiable(_recent);

  bool _matches(String name, String phone) {
    final q = _query.toLowerCase();
    final digits = PhoneNumberHelper.cleanDigits(_query);
    return name.toLowerCase().contains(q) ||
        (digits.isNotEmpty && phone.contains(digits));
  }

  /// Name of the server guest or draft row that already has [digits], if any.
  String? duplicateOf(String digits,
      {String? exceptLocalId, int? exceptGuestId}) {
    for (final g in _view?.guests ?? const <ClientGuest>[]) {
      if (g.guestId != exceptGuestId && g.phoneDigits == digits) return g.name;
    }
    for (final d in _draft) {
      if (d.localId != exceptLocalId && d.phoneDigits == digits) {
        return d.fullName;
      }
    }
    return null;
  }

  /// Every number already on the list or in the draft.
  Set<String> get takenPhones => {
        for (final g in _view?.guests ?? const <ClientGuest>[]) g.phoneDigits,
        for (final d in _draft)
          if (d.phoneDigits != null) d.phoneDigits!,
      };

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> load(int eventId) async {
    _eventId = eventId;
    if (!isClosed) emit(const ManageGuestsStates.loading());
    // The draft shows right away, the list loads under it
    _draft = await _drafts.load(eventId);
    _recent = await _recentTitles.load();
    await _fetch(reportErrors: true);
  }

  Future<void> refresh() => _fetch(reportErrors: true);

  /// The screen calls this every minute: once the deadline passes, the list
  /// is reloaded so it turns view-only without waiting for the next action.
  Future<void> checkDeadline() async {
    final deadline = deadlineUtc;
    if (canEdit &&
        deadline != null &&
        DateTime.now().toUtc().isAfter(deadline)) {
      await _fetch(reportErrors: false);
    }
  }

  Future<bool> _fetch({required bool reportErrors}) async {
    final result = await _repo.getEventGuests(_eventId);
    final failure = result.when<String?>(
      success: (view) {
        _view = view;
        return null;
      },
      failure: (code) => code,
    );
    if (failure == null) {
      _emitLoaded();
      return true;
    }
    if (failure == GuestErrorCodes.eventNotFound) {
      _draft = [];
      await _drafts.clear(_eventId);
    }
    if (reportErrors && !isClosed) {
      emit(ManageGuestsStates.error(message: messageFor(failure)));
    }
    return false;
  }

  void search(String query) {
    _query = query.trim();
    _emitLoaded();
  }

  void setTitleFilter(GuestTitle? title) {
    _titleFilter = title;
    _emitLoaded();
  }

  Future<void> rememberTitle(GuestTitle title) async {
    _recent = await _recentTitles.remember(title);
    _emitLoaded();
  }

  // ── Draft ─────────────────────────────────────────────────────────────────

  void addToDraft(List<DraftGuest> rows) {
    if (rows.isEmpty) return;
    _draft = [...rows, ..._draft];
    _draftDirty = true;
    _emitLoaded();
  }

  void updateDraft(DraftGuest row) {
    _draft = [
      for (final d in _draft) d.localId == row.localId ? row : d,
    ];
    _draftDirty = true;
    _emitLoaded();
  }

  void removeFromDraft(Iterable<String> localIds) {
    final ids = localIds.toSet();
    _draft = _draft.where((d) => !ids.contains(d.localId)).toList();
    _draftDirty = true;
    _emitLoaded();
  }

  /// Gives [title] to draft rows; nothing is sent until they are added.
  void applyTitleToDraft(Set<String> localIds, GuestTitle title) {
    final normalized = GuestTitles.fromText(title.text);
    _draft = [
      for (final d in _draft)
        localIds.contains(d.localId) ? d.copyWith(title: normalized) : d,
    ];
    _draftDirty = true;
    _clearEmptyFilter();
    _emitLoaded();
  }

  // The chosen title may have just lost its last guest
  void _clearEmptyFilter() {
    if (_titleFilter != null && !titleCounts.containsKey(_titleFilter)) {
      _titleFilter = null;
    }
  }

  Future<void> saveDraft({bool notify = true}) async {
    await _drafts.save(_eventId, _draft);
    _draftDirty = false;
    if (notify && !isClosed) {
      emit(ManageGuestsStates.actionSuccess(
          message: 'guests_draft_saved_toast'.tr()));
    }
    _emitLoaded();
  }

  /// Leaving with unsaved changes and choosing "discard": back to the saved draft.
  Future<void> discardDraftChanges() async {
    _draft = await _drafts.load(_eventId);
    _draftDirty = false;
  }

  Future<void> deleteDraft() async {
    _draft = [];
    await _drafts.clear(_eventId);
    _draftDirty = false;
    _emitLoaded();
  }

  // ── Add the draft to the list ─────────────────────────────────────────────

  Future<void> submitDraft() async {
    if (!canEdit || _draft.isEmpty) return;

    // Rows with an invalid number never reach the backend
    _draft = [
      for (final row in _draft)
        row.phoneDigits == null
            ? row.withError(GuestErrorCodes.invalidPhone, null)
            : row,
    ];
    final ready = _draft.where((d) => d.phoneDigits != null).toList();
    if (ready.isEmpty) {
      _emitLoaded();
      return;
    }

    final total = ready.length;
    var added = 0;
    final warned = <String>[];
    final failedById = <String, DraftGuest>{};
    final addedIds = <String>{};
    String? stopCode;

    for (var start = 0; start < total; start += AddGuestsRequest.maxBatchSize) {
      final batch = ready.sublist(
          start, (start + AddGuestsRequest.maxBatchSize).clamp(0, total));
      if (!isClosed) {
        emit(ManageGuestsStates.submitting(done: start, total: total));
      }

      final result = await _repo.addGuests(
        _eventId,
        [
          for (final row in batch)
            GuestInput(
              name: row.fullName,
              phone: row.phoneDigits!,
              noOfMembers: row.noOfMembers,
              title: GuestTitles.wireText(row.title),
            ),
        ],
      );

      final rows = result.when<List<GuestOpResult>?>(
        success: (response) => response.rows ?? const [],
        failure: (code) {
          stopCode = code;
          return null;
        },
      );
      if (rows == null) break;

      for (var i = 0; i < batch.length; i++) {
        final row = batch[i];
        final op = i < rows.length ? rows[i] : null;
        if (op?.success == true) {
          added++;
          addedIds.add(row.localId);
          if ((op!.warnings ?? const []).isNotEmpty) warned.add(row.fullName);
        } else {
          failedById[row.localId] =
              row.withError(op?.code ?? GuestErrorCodes.unknown, op?.message);
        }
      }
    }

    // Reload: shows the new guests, and tells whether a request whose answer
    // was lost (or a "duplicate" from a retry) was in fact saved
    await _fetch(reportErrors: false);
    final saved = {
      for (final g in _view?.guests ?? const <ClientGuest>[])
        g.phoneDigits: (g.name ?? '').trim(),
    };
    bool alreadySaved(DraftGuest row) => saved[row.phoneDigits] == row.fullName;

    final remaining = <DraftGuest>[];
    for (final row in _draft) {
      if (addedIds.contains(row.localId)) continue;
      if (alreadySaved(row)) {
        added++;
        failedById.remove(row.localId);
        continue;
      }
      remaining.add(failedById[row.localId] ?? row);
    }
    _draft = remaining;
    await saveDraft(notify: false);

    // A refused request (deadline passed, concurrent change, no answer)
    // stops the remaining batches; what was saved is still reported
    if (stopCode != null && !isClosed) {
      emit(ManageGuestsStates.actionError(message: messageFor(stopCode!)));
    }
    if ((stopCode == null || added > 0) && !isClosed) {
      emit(ManageGuestsStates.submitResult(SubmitOutcome(
        added: added,
        total: total,
        failed: remaining.where((r) => r.hasError).toList(),
        warned: warned,
      )));
    }
    _emitLoaded();
  }

  // ── Guests already on the list ────────────────────────────────────────────

  /// Saves an edit straight to the server (not through the draft).
  Future<bool> updateGuest(int guestId, GuestInput guest) async {
    if (!isClosed) emit(const ManageGuestsStates.actionLoading());
    final result = await _repo.updateGuest(_eventId, guestId, guest);
    return _afterGuestChange(result, 'guests_saved_toast');
  }

  Future<bool> deleteGuest(int guestId) async {
    if (!isClosed) emit(const ManageGuestsStates.actionLoading());
    final result = await _repo.deleteGuest(_eventId, guestId);
    return _afterGuestChange(result, 'guests_deleted_toast');
  }

  Future<bool> _afterGuestChange(
      ApiResult<GuestOpResult> result, String successKey) async {
    final failure = result.when<String?>(
      success: (_) => null,
      failure: (code) => code,
    );

    // The list may have changed under us in every case except bad input
    if (failure == null || _reloadAfter.contains(failure)) {
      await _fetch(reportErrors: false);
    }
    if (isClosed) return failure == null;
    emit(failure == null
        ? ManageGuestsStates.actionSuccess(message: successKey.tr())
        : ManageGuestsStates.actionError(message: messageFor(failure)));
    _emitLoaded();
    return failure == null;
  }

  static const Set<String> _reloadAfter = {
    GuestErrorCodes.guestLocked,
    GuestErrorCodes.guestNotFound,
    GuestErrorCodes.windowClosed,
    GuestErrorCodes.windowNotConfigured,
    GuestErrorCodes.concurrentUpdate,
  };

  // ── Titles of guests already on the list ──────────────────────────────────

  /// How many of [guestIds] were sent an invitation, as far as the list knows;
  /// the backend still decides when the change is applied.
  int lockedCount(Set<int> guestIds) =>
      (_view?.guests ?? const <ClientGuest>[])
          .where((g) => guestIds.contains(g.guestId) && (g.isLocked ?? false))
          .length;

  /// Sends the change in batches. A refused batch (deadline passed, no answer)
  /// stops the rest; what was already changed is still reported.
  Future<void> applyTitleToGuests(Set<int> guestIds, GuestTitle title) async {
    if (!canEdit || guestIds.isEmpty) return;
    if (!isClosed) emit(const ManageGuestsStates.titleChanging());

    final ids = guestIds.toList();
    final names = {
      for (final g in _view?.guests ?? const <ClientGuest>[])
        g.guestId: g.name ?? '',
    };
    final wireTitle = GuestTitles.wireText(GuestTitles.fromText(title.text));
    var updated = 0;
    final skipped = <SkippedTitleChange>[];
    String? stopCode;

    for (var start = 0;
        start < ids.length;
        start += AddGuestsRequest.maxBatchSize) {
      final batch = ids.sublist(
          start, (start + AddGuestsRequest.maxBatchSize).clamp(0, ids.length));
      final result =
          await _repo.updateGuestsTitle(_eventId, batch, wireTitle);
      final response = result.when<GuestsTitleResponse?>(
        success: (response) => response,
        failure: (code) {
          stopCode = code;
          return null;
        },
      );
      if (response == null) break;
      updated += response.updated?.length ?? 0;
      for (final row in response.skipped ?? const <GuestOpResult>[]) {
        skipped.add(SkippedTitleChange(
          name: names[row.guestId] ?? '',
          code: row.code ?? GuestErrorCodes.unknown,
        ));
      }
    }

    // Reload in every case: an answer may be lost after the change was saved
    await _fetch(reportErrors: false);
    _clearEmptyFilter();
    if (updated > 0) _recent = await _recentTitles.remember(title);

    if (isClosed) return;
    if (stopCode != null) {
      emit(ManageGuestsStates.actionError(message: messageFor(stopCode!)));
    }
    if (stopCode == null || updated > 0) {
      emit(ManageGuestsStates.titleChangeResult(
          TitleChangeOutcome(updated: updated, skipped: skipped)));
    }
    _emitLoaded();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// The text for a backend code; the UI never shows the server's message
  /// for codes it knows.
  static String messageFor(String code) => switch (code) {
        GuestErrorCodes.windowClosed => 'guests_err_window_closed'.tr(),
        GuestErrorCodes.windowNotConfigured =>
          'guests_window_not_configured'.tr(),
        GuestErrorCodes.guestLocked => 'guests_err_guest_locked'.tr(),
        GuestErrorCodes.guestNotFound => 'guests_err_guest_not_found'.tr(),
        GuestErrorCodes.invalidPhone => 'guests_err_invalid_phone'.tr(),
        GuestErrorCodes.duplicatePhone => 'guests_err_duplicate_phone'.tr(),
        GuestErrorCodes.invalidInput => 'guests_err_invalid_input'.tr(),
        GuestErrorCodes.eventNotFound => 'guests_err_event_not_found'.tr(),
        GuestErrorCodes.concurrentUpdate => 'guests_err_concurrent'.tr(),
        GuestErrorCodes.network => 'guests_submit_network'.tr(),
        _ => 'some_error'.tr(),
      };

  void _emitLoaded() {
    if (!isClosed) emit(ManageGuestsStates.loaded(revision: ++_revision));
  }
}
