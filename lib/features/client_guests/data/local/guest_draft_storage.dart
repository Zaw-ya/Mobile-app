import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../models/draft_guest.dart';

/// Keeps each event's guest draft on this device only, per user and event.
/// Nothing here is sent to the backend.
class GuestDraftStorage {
  static const int _version = 1;
  static const String _draftPrefix = 'guest_draft_v$_version';
  static const String _indexPrefix = 'guest_drafts_index';

  final AppUtilities _utilities;

  GuestDraftStorage(this._utilities);

  Future<List<DraftGuest>> load(int eventId) async {
    final raw = await _utilities.getString(_draftKey(eventId), '');
    if (raw.isEmpty) return [];
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return (json['items'] as List)
          .map((e) => DraftGuest.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Guest draft for event $eventId is unreadable: $e');
      await clear(eventId);
      return [];
    }
  }

  /// Saves the draft; an empty list removes it.
  Future<void> save(int eventId, List<DraftGuest> items) async {
    if (items.isEmpty) return clear(eventId);
    await _utilities.setString(
      _draftKey(eventId),
      jsonEncode({
        'version': _version,
        'eventId': eventId,
        'updatedAt': DateTime.now().toUtc().toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
      }),
    );
    final index = await _index();
    if (index.add(eventId)) await _saveIndex(index);
  }

  Future<void> clear(int eventId) async {
    await _utilities.remove(_draftKey(eventId));
    final index = await _index();
    if (index.remove(eventId)) await _saveIndex(index);
  }

  Future<int> count(int eventId) async => (await load(eventId)).length;

  /// Removes every draft of the signed-in user. Call before the session is
  /// cleared (logout, account deletion), since the key needs the token.
  Future<void> clearAllForCurrentUser() async {
    for (final eventId in await _index()) {
      await _utilities.remove(_draftKey(eventId));
    }
    await _utilities.remove(_indexKey);
  }

  String _draftKey(int eventId) => '$_draftPrefix:$_userKey:$eventId';

  String get _indexKey => '$_indexPrefix:$_userKey';

  Future<Set<int>> _index() async {
    final raw = await _utilities.getString(_indexKey, '');
    if (raw.isEmpty) return {};
    try {
      return (jsonDecode(raw) as List).cast<int>().toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveIndex(Set<int> index) => index.isEmpty
      ? _utilities.remove(_indexKey)
      : _utilities.setString(_indexKey, jsonEncode(index.toList()));

  /// The user id from the token's "sid" claim (the one the backend reads),
  /// or the saved username when the token can't be read.
  String get _userKey {
    final sid = userIdFromToken(_utilities.serverToken);
    if (sid != null) return sid;
    final username = _utilities.username.trim().toLowerCase();
    return username.isEmpty ? 'anonymous' : username;
  }

  @visibleForTesting
  static String? userIdFromToken(String token) {
    try {
      final parts = token.replaceFirst('Bearer ', '').trim().split('.');
      if (parts.length != 3) return null;
      final payload = jsonDecode(
              utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))))
          as Map<String, dynamic>;
      for (final entry in payload.entries) {
        if (entry.key == 'sid' || entry.key.endsWith('/sid')) {
          return entry.value?.toString();
        }
      }
    } catch (_) {}
    return null;
  }
}
