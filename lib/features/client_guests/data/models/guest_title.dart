/// The title (لقب) written before a guest's name on the card.
///
/// The full name always carries the title (`prefix` stays null); the title is
/// also sent on its own so the backend can tell it from a first name. This
/// file is the one place that knows the title lists, how they are joined and
/// how they are split back.
enum GuestTitleKind { preset, custom, none }

class GuestTitle {
  final GuestTitleKind kind;

  /// The written title; empty for [GuestTitleKind.none].
  final String text;

  const GuestTitle._(this.kind, this.text);

  const GuestTitle.preset(String text) : this._(GuestTitleKind.preset, text);

  const GuestTitle.custom(String text) : this._(GuestTitleKind.custom, text);

  const GuestTitle.none() : this._(GuestTitleKind.none, '');

  Map<String, dynamic> toJson() => {'kind': kind.name, 'text': text};

  factory GuestTitle.fromJson(Map<String, dynamic> json) {
    final kind =
        GuestTitleKind.values.asNameMap()[json['kind']] ?? GuestTitleKind.none;
    final text = (json['text'] as String?) ?? '';
    return switch (kind) {
      GuestTitleKind.preset => GuestTitle.preset(text),
      GuestTitleKind.custom => GuestTitle.custom(text),
      GuestTitleKind.none => const GuestTitle.none(),
    };
  }

  @override
  bool operator ==(Object other) =>
      other is GuestTitle && other.kind == kind && other.text == text;

  @override
  int get hashCode => Object.hash(kind, text);
}

class GuestTitles {
  GuestTitles._();

  static const List<String> arabic = ['المكرم', 'المكرمة', 'عزيزي', 'عزيزتي'];
  static const List<String> english = ['Mr.', 'Mrs.', 'Ms.', 'Dear'];

  /// The preset titles offered for [languageCode]. Today the source is the
  /// app language; switching to the event's card language later only changes
  /// what callers pass here.
  static List<String> presetsFor(String languageCode) =>
      languageCode == 'ar' ? arabic : english;

  static final RegExp _spaces = RegExp(r'\s+');

  /// A title from free text: empty is "no title", and a known preset (in
  /// either language) is that preset rather than a custom title.
  static GuestTitle fromText(String? text) {
    final clean = (text ?? '').trim().replaceAll(_spaces, ' ');
    if (clean.isEmpty) return const GuestTitle.none();
    final key = _key(clean);
    for (final preset in [...arabic, ...english]) {
      if (_key(preset) == key) return GuestTitle.preset(preset);
    }
    return GuestTitle.custom(clean);
  }

  /// The title alone as sent to the backend; null for "no title".
  static String? wireText(GuestTitle title) {
    final clean = title.text.trim().replaceAll(_spaces, ' ');
    return title.kind == GuestTitleKind.none || clean.isEmpty ? null : clean;
  }

  /// The full name sent to the backend. "No title" sends the name as typed.
  static String compose(GuestTitle title, String name) {
    final cleanName = name.trim();
    if (title.kind == GuestTitleKind.none || title.text.trim().isEmpty) {
      return cleanName;
    }
    return '${title.text.trim()} $cleanName'.replaceAll(_spaces, ' ');
  }

  /// Splits a known preset title (Arabic or English) off a full name, so a
  /// saved guest can be edited with its title. Anything else, including a
  /// custom title, comes back as "no title" with the full name untouched,
  /// because a custom title can't be told apart from a first name.
  static (GuestTitle, String) split(String fullName) {
    final name = fullName.trim();
    final words = name.split(_spaces);
    if (words.length < 2) return (const GuestTitle.none(), name);

    final first = _key(words.first);
    for (final preset in [...arabic, ...english]) {
      if (_key(preset) == first) {
        return (
          GuestTitle.preset(preset),
          name.substring(words.first.length).trim(),
        );
      }
    }
    return (const GuestTitle.none(), name);
  }

  /// Like [split], but a title the backend stored (custom ones too) wins over
  /// guessing, as long as the name still starts with it.
  static (GuestTitle, String) splitKnown(String fullName, String? storedTitle) {
    final name = fullName.trim();
    final stored = wireText(fromText(storedTitle));
    if (stored != null && name.startsWith('$stored ')) {
      return (fromText(stored), name.substring(stored.length).trim());
    }
    return split(name);
  }

  /// Removes [title] from the start of [name] when it was typed twice
  /// (e.g. a contact saved as "المكرم أحمد" with "المكرم" selected).
  static String stripRepeatedTitle(GuestTitle title, String name) {
    final words = name.trim().split(_spaces);
    if (title.kind == GuestTitleKind.none || words.length < 2) {
      return name.trim();
    }
    if (_key(words.first) != _key(title.text)) return name.trim();
    return name.trim().substring(words.first.length).trim();
  }

  // Case-insensitive, and "Mr" matches "Mr."
  static String _key(String word) {
    var key = word.trim().toLowerCase();
    if (key.endsWith('.')) key = key.substring(0, key.length - 1);
    return key;
  }
}
