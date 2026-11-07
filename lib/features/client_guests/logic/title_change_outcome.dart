/// A guest whose title didn't change, and the backend's reason.
class SkippedTitleChange {
  final String name;
  final String code;

  const SkippedTitleChange({required this.name, required this.code});
}

/// What happened when a title was changed for guests already on the list.
class TitleChangeOutcome {
  final int updated;
  final List<SkippedTitleChange> skipped;

  const TitleChangeOutcome({required this.updated, this.skipped = const []});
}
