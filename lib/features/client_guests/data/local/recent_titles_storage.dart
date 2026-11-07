import 'dart:convert';

import '../../../../core/helpers/app_utilities.dart';
import '../models/guest_title.dart';
import 'guest_draft_storage.dart';

/// The user's last custom titles, newest first, on this device only. Dropping
/// a title from this list changes nothing for the guests who have it.
class RecentTitlesStorage {
  static const int limit = 5;
  static const String _prefix = 'guest_recent_titles';

  final AppUtilities _utilities;

  RecentTitlesStorage(this._utilities);

  Future<List<String>> load() async {
    final raw = await _utilities.getString(_key, '');
    if (raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List).cast<String>();
    } catch (_) {
      return [];
    }
  }

  /// Puts a custom [title] first, without a repeat, and drops the oldest past
  /// [limit]. Presets and "no title" aren't kept. Returns the new list.
  Future<List<String>> remember(GuestTitle title) async {
    final current = await load();
    final normalized = GuestTitles.fromText(title.text);
    if (normalized.kind != GuestTitleKind.custom) return current;

    final text = normalized.text;
    final next = [
      text,
      ...current.where((t) => t.toLowerCase() != text.toLowerCase()),
    ].take(limit).toList();
    await _utilities.setString(_key, jsonEncode(next));
    return next;
  }

  /// Call before the session is cleared (logout, account deletion), since the
  /// key needs the token.
  Future<void> clearForCurrentUser() => _utilities.remove(_key);

  String get _key => '$_prefix:${guestStorageUserKey(_utilities)}';
}
