import '../data/models/draft_guest.dart';

/// What happened when the draft was added to the list.
class SubmitOutcome {
  final int added;
  final int total;

  /// Rows the backend refused; they stay in the draft with their error.
  final List<DraftGuest> failed;

  /// Names of added rows that came with a warning (same name, other number).
  final List<String> warned;

  const SubmitOutcome({
    required this.added,
    required this.total,
    this.failed = const [],
    this.warned = const [],
  });
}
