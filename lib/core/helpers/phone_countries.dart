import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'search_normalizer.dart';

/// Sections of the country picker, in display order.
enum PhoneCountryGroup { arab, english, europe, other }

/// A country of the phone country picker. The calling code comes from
/// phone_numbers_parser's metadata, so it always matches validation.
class PhoneCountry {
  /// ISO 3166 alpha-2, e.g. "SA". Kept even when the calling code is
  /// shared (+1 US / Canada, +7 Russia / Kazakhstan).
  final String region;
  final String callingCode;
  final PhoneCountryGroup group;
  final String nameAr;
  final String nameEn;

  const PhoneCountry({
    required this.region,
    required this.callingCode,
    required this.group,
    required this.nameAr,
    required this.nameEn,
  });

  /// Name in the UI language.
  String name(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;
}

/// The picker's country catalog. Names are kept here, next to their ISO
/// codes, instead of in the translation files: the search matches the
/// Arabic and the English name at the same time, and easy_localization
/// only exposes the current language.
class PhoneCountries {
  PhoneCountries._();

  static const _catalog = <(IsoCode, PhoneCountryGroup, String, String)>[
    // Arab League: the Gulf first
    (IsoCode.SA, PhoneCountryGroup.arab, 'السعودية', 'Saudi Arabia'),
    (IsoCode.AE, PhoneCountryGroup.arab, 'الإمارات', 'United Arab Emirates'),
    (IsoCode.KW, PhoneCountryGroup.arab, 'الكويت', 'Kuwait'),
    (IsoCode.QA, PhoneCountryGroup.arab, 'قطر', 'Qatar'),
    (IsoCode.BH, PhoneCountryGroup.arab, 'البحرين', 'Bahrain'),
    (IsoCode.OM, PhoneCountryGroup.arab, 'عُمان', 'Oman'),
    (IsoCode.EG, PhoneCountryGroup.arab, 'مصر', 'Egypt'),
    (IsoCode.JO, PhoneCountryGroup.arab, 'الأردن', 'Jordan'),
    (IsoCode.LB, PhoneCountryGroup.arab, 'لبنان', 'Lebanon'),
    (IsoCode.SY, PhoneCountryGroup.arab, 'سوريا', 'Syria'),
    (IsoCode.IQ, PhoneCountryGroup.arab, 'العراق', 'Iraq'),
    (IsoCode.PS, PhoneCountryGroup.arab, 'فلسطين', 'Palestine'),
    (IsoCode.YE, PhoneCountryGroup.arab, 'اليمن', 'Yemen'),
    (IsoCode.SD, PhoneCountryGroup.arab, 'السودان', 'Sudan'),
    (IsoCode.LY, PhoneCountryGroup.arab, 'ليبيا', 'Libya'),
    (IsoCode.TN, PhoneCountryGroup.arab, 'تونس', 'Tunisia'),
    (IsoCode.DZ, PhoneCountryGroup.arab, 'الجزائر', 'Algeria'),
    (IsoCode.MA, PhoneCountryGroup.arab, 'المغرب', 'Morocco'),
    (IsoCode.MR, PhoneCountryGroup.arab, 'موريتانيا', 'Mauritania'),
    (IsoCode.SO, PhoneCountryGroup.arab, 'الصومال', 'Somalia'),
    (IsoCode.DJ, PhoneCountryGroup.arab, 'جيبوتي', 'Djibouti'),
    (IsoCode.KM, PhoneCountryGroup.arab, 'جزر القمر', 'Comoros'),
    // English-speaking
    (IsoCode.US, PhoneCountryGroup.english, 'الولايات المتحدة', 'United States'),
    (IsoCode.GB, PhoneCountryGroup.english, 'المملكة المتحدة', 'United Kingdom'),
    (IsoCode.CA, PhoneCountryGroup.english, 'كندا', 'Canada'),
    (IsoCode.AU, PhoneCountryGroup.english, 'أستراليا', 'Australia'),
    (IsoCode.IE, PhoneCountryGroup.english, 'أيرلندا', 'Ireland'),
    (IsoCode.NZ, PhoneCountryGroup.english, 'نيوزيلندا', 'New Zealand'),
    (IsoCode.ZA, PhoneCountryGroup.english, 'جنوب أفريقيا', 'South Africa'),
    // Europe: the main countries, the other EU members, then Turkey
    (IsoCode.DE, PhoneCountryGroup.europe, 'ألمانيا', 'Germany'),
    (IsoCode.FR, PhoneCountryGroup.europe, 'فرنسا', 'France'),
    (IsoCode.IT, PhoneCountryGroup.europe, 'إيطاليا', 'Italy'),
    (IsoCode.ES, PhoneCountryGroup.europe, 'إسبانيا', 'Spain'),
    (IsoCode.NL, PhoneCountryGroup.europe, 'هولندا', 'Netherlands'),
    (IsoCode.BE, PhoneCountryGroup.europe, 'بلجيكا', 'Belgium'),
    (IsoCode.CH, PhoneCountryGroup.europe, 'سويسرا', 'Switzerland'),
    (IsoCode.AT, PhoneCountryGroup.europe, 'النمسا', 'Austria'),
    (IsoCode.SE, PhoneCountryGroup.europe, 'السويد', 'Sweden'),
    (IsoCode.NO, PhoneCountryGroup.europe, 'النرويج', 'Norway'),
    (IsoCode.DK, PhoneCountryGroup.europe, 'الدنمارك', 'Denmark'),
    (IsoCode.FI, PhoneCountryGroup.europe, 'فنلندا', 'Finland'),
    (IsoCode.PT, PhoneCountryGroup.europe, 'البرتغال', 'Portugal'),
    (IsoCode.GR, PhoneCountryGroup.europe, 'اليونان', 'Greece'),
    (IsoCode.PL, PhoneCountryGroup.europe, 'بولندا', 'Poland'),
    (IsoCode.CZ, PhoneCountryGroup.europe, 'التشيك', 'Czechia'),
    (IsoCode.HU, PhoneCountryGroup.europe, 'المجر', 'Hungary'),
    (IsoCode.RO, PhoneCountryGroup.europe, 'رومانيا', 'Romania'),
    (IsoCode.BG, PhoneCountryGroup.europe, 'بلغاريا', 'Bulgaria'),
    (IsoCode.HR, PhoneCountryGroup.europe, 'كرواتيا', 'Croatia'),
    (IsoCode.SK, PhoneCountryGroup.europe, 'سلوفاكيا', 'Slovakia'),
    (IsoCode.SI, PhoneCountryGroup.europe, 'سلوفينيا', 'Slovenia'),
    (IsoCode.LT, PhoneCountryGroup.europe, 'ليتوانيا', 'Lithuania'),
    (IsoCode.LV, PhoneCountryGroup.europe, 'لاتفيا', 'Latvia'),
    (IsoCode.EE, PhoneCountryGroup.europe, 'إستونيا', 'Estonia'),
    (IsoCode.LU, PhoneCountryGroup.europe, 'لوكسمبورغ', 'Luxembourg'),
    (IsoCode.MT, PhoneCountryGroup.europe, 'مالطا', 'Malta'),
    (IsoCode.CY, PhoneCountryGroup.europe, 'قبرص', 'Cyprus'),
    (IsoCode.TR, PhoneCountryGroup.europe, 'تركيا', 'Turkey'),
    // Other popular countries (large expat and visitor communities in the Gulf)
    (IsoCode.IN, PhoneCountryGroup.other, 'الهند', 'India'),
    (IsoCode.PK, PhoneCountryGroup.other, 'باكستان', 'Pakistan'),
    (IsoCode.BD, PhoneCountryGroup.other, 'بنغلاديش', 'Bangladesh'),
    (IsoCode.PH, PhoneCountryGroup.other, 'الفلبين', 'Philippines'),
    (IsoCode.ID, PhoneCountryGroup.other, 'إندونيسيا', 'Indonesia'),
    (IsoCode.MY, PhoneCountryGroup.other, 'ماليزيا', 'Malaysia'),
    (IsoCode.LK, PhoneCountryGroup.other, 'سريلانكا', 'Sri Lanka'),
    (IsoCode.NP, PhoneCountryGroup.other, 'نيبال', 'Nepal'),
    (IsoCode.AF, PhoneCountryGroup.other, 'أفغانستان', 'Afghanistan'),
    (IsoCode.IR, PhoneCountryGroup.other, 'إيران', 'Iran'),
    (IsoCode.ET, PhoneCountryGroup.other, 'إثيوبيا', 'Ethiopia'),
    (IsoCode.KE, PhoneCountryGroup.other, 'كينيا', 'Kenya'),
    (IsoCode.UG, PhoneCountryGroup.other, 'أوغندا', 'Uganda'),
    (IsoCode.NG, PhoneCountryGroup.other, 'نيجيريا', 'Nigeria'),
    (IsoCode.CN, PhoneCountryGroup.other, 'الصين', 'China'),
    (IsoCode.JP, PhoneCountryGroup.other, 'اليابان', 'Japan'),
    (IsoCode.KR, PhoneCountryGroup.other, 'كوريا الجنوبية', 'South Korea'),
    (IsoCode.RU, PhoneCountryGroup.other, 'روسيا', 'Russia'),
    (IsoCode.KZ, PhoneCountryGroup.other, 'كازاخستان', 'Kazakhstan'),
    (IsoCode.BR, PhoneCountryGroup.other, 'البرازيل', 'Brazil'),
    (IsoCode.MX, PhoneCountryGroup.other, 'المكسيك', 'Mexico'),
    (IsoCode.SG, PhoneCountryGroup.other, 'سنغافورة', 'Singapore'),
    (IsoCode.TH, PhoneCountryGroup.other, 'تايلاند', 'Thailand'),
  ];

  /// Every country in display order: the Arab group first.
  static final List<PhoneCountry> all = [
    for (final (iso, group, ar, en) in _catalog)
      PhoneCountry(
        region: iso.name,
        callingCode: PhoneNumber(isoCode: iso, nsn: '').countryCode,
        group: group,
        nameAr: ar,
        nameEn: en,
      ),
  ];

  static final Map<String, PhoneCountry> _byRegion = {
    for (final country in all) country.region: country,
  };

  static PhoneCountry? byRegion(String? region) =>
      region == null ? null : _byRegion[region.toUpperCase()];

  /// Countries matching [query], in display order: the Arabic name
  /// (forgiving letter variants), the English name, the ISO code, or the
  /// calling code with or without "+".
  static List<PhoneCountry> search(String query) {
    final q = query.trim();
    if (q.isEmpty) return all;

    final digits = q.replaceAll(RegExp(r'[\s+]'), '');
    if (RegExp(r'^\d+$').hasMatch(digits)) {
      return all.where((c) => c.callingCode.startsWith(digits)).toList();
    }

    final text = normalizeForSearch(q);
    final upper = q.toUpperCase();
    return all
        .where((c) =>
            normalizeForSearch(c.nameAr).contains(text) ||
            c.nameEn.toLowerCase().contains(text) ||
            c.region == upper)
        .toList();
  }
}
