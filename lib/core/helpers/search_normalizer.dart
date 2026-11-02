/// Lower-case text with Arabic letter variants folded (أ/إ/آ/ٱ → ا,
/// ة → ه, ى → ي) and diacritics and tatweel removed, so a search forgives
/// how a name was typed.
String normalizeForSearch(String text) => text
    .toLowerCase()
    .replaceAll(RegExp('[ً-ٰٟـ]'), '')
    .replaceAll(RegExp('[أإآٱ]'), 'ا')
    .replaceAll('ة', 'ه')
    .replaceAll('ى', 'ي')
    .trim();
