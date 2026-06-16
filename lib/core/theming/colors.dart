// import 'package:flutter/material.dart';

// // Base colors
// const Color bgColor = Color(0xff33364E);
// const Color bgColorOverlay = Color(0xff252A41);
// const Color navBarBackground = Color(0xff181c2f);
// const Color primaryColor = Color(0xff2175F1);
// const Color greenPrimaryColor = Color(0xff2E6C63);
// const Color secondaryColor = Color(0xff6D42F4);
// const Color whiteSmokeColor = Color(0xffF5F5F5);
// const Color greenColor = Color(0xff35818f);
// const Color errorColor = Color(0xFFB00020);
// const Color whiteTextColor = Color(0xFFFFFFFF);

// const Color gray600 = Color(0xFF64687D);
// const Color gray50 = Color(0xFFF5F5F5);

// // Improved gradient definitions with explicit parameters
// const LinearGradient gradient1 = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [primaryColor, secondaryColor],
//   stops: [0.0, 1.0],
// );

// const LinearGradient containerGradient = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [Color(0xff1AD3A4), Color(0xff3082D9)],
//   stops: [0.0, 1.0],
// );

// const LinearGradient gradient3 = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [Color(0xffEF745F), Color(0xffF7BB6A)],
//   stops: [0.0, 1.0],
// );

// const LinearGradient gradient4 = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [Color(0xffFF6AB3), Color(0xffFC2DAC)],
//   stops: [0.0, 1.0],
// );

// const LinearGradient greenGradient = LinearGradient(
//   begin: Alignment.centerLeft,
//   end: Alignment.centerRight,
//   colors: [Color(0xff2E6C63), Color(0xff509170)],
// );

// abstract class AppColor {
//   static const Color primaryColor = Color(0xff2E6C63);
//   static const Color lightPrimaryColor = Color(0xFFF5F5F5);
//   static const Color secondaryColor = Color(0xFFD0A471);
//   static const Color secondaryColorShade = Color(0xFFFFF0CC);
//   static const Color whiteColor = Colors.white;
//   static const Color black = Colors.black;
//   static const Color darkGray = Color(0xFF949D9E);
//   static const Color lightGray = Color(0xFFDCDEDE);
//   static const Color veryLightGrey = Color(0xFFF3F5F7);
//   static const Color iconColor = Color(0xFFC9CECF);
//   static const Color gray50 = Color(0xFFF6F7F9);
//   static const Color gray100 = Color(0xFFE7E8EC);
//   static const Color gray200 = Color(0xffC5C7D1);
//   static const Color gray300 = Color(0xffAFB1BE);
//   static const Color gray400 = Color(0xff999BAD);
//   static const Color gray500 = Color(0xff81859A);
//   static const Color gray600 = Color(0xff64687D);
//   static const Color gray700 = Color(0xFF535566);
//   static const Color gray800 = Color(0xFF40424F);
//   static const Color gray900 = Color(0xFF2D2F39);
//   static const Color transferBackground = Color(0xFFFFEDED);
//   static const Color receiveBackground = Color(0xFFDAF7EC);
//   static const Color mainRed = Color(0xFFDE4949);
//   static const Color yearsBackground = Color(0xFFC88F4D);
//   static const Color homeBackground = Color(0xFFDCFFEE);
//   static const Color containerBackground = Color(0xFFC4E8D6);
//   static const Color container2Background = Color(0xFFE9E9D7);
//   static const Color locationBackground = Color(0xFFF4DEBB);

//   static const LinearGradient greenGradient = LinearGradient(
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//     colors: [Color(0xff2E6C63), Color(0xff509170)],
//   );
//   static const LinearGradient secondaryGradient = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [Color(0xFFDCFFEE), Colors.white],
//   );
// }

import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════
// Special Cards Brand Seeds
// ═══════════════════════════════════════════════
const Color kNavy        = Color(0xFF262938); // #262938 — primary dark
const Color kCream       = Color(0xFFEDEAE4); // #EDEAE4 — primary light
const Color kOnlineGreen = Color(0xFF2E7D32); // semantic "connected" state

// ═══════════════════════════════════════════════
// Core Palette
// ═══════════════════════════════════════════════
const Color kBlack        = Color(0xFF000000);
const Color kWhite        = Color(0xFFFFFFFF);
const Color kGold         = Color(0xFFB8860B);
const Color kGoldLight    = Color(0xFFD4A017);  // درجة أفتح
const Color kGoldDark     = Color(0xFF8B6508);  // درجة أغمق
const Color kOffWhite     = Color(0xFFFAF8F2);  // أبيض دافئ
const Color kDarkSurface  = Color(0xFF1A1A1A);  // أسود مش pure
const Color kDarkOverlay  = Color(0xFF2A2A2A);

// ═══════════════════════════════════════════════
// Legacy Variables (kept for compatibility)
// ═══════════════════════════════════════════════
const Color bgColor           = kDarkSurface;
const Color bgColorOverlay    = kDarkOverlay;
const Color navBarBackground  = kBlack;
const Color primaryColor      = kGold;
const Color greenPrimaryColor = kGoldDark;
const Color secondaryColor    = kGoldLight;
const Color whiteSmokeColor   = kOffWhite;
const Color greenColor        = kGold;
const Color errorColor        = Color(0xFFB00020);
const Color whiteTextColor    = kWhite;
const Color gray600           = Color(0xFF64687D);
const Color gray50            = Color(0xFFF5F5F5);

// ═══════════════════════════════════════════════
// Legacy Gradients (kept for compatibility)
// ═══════════════════════════════════════════════
const LinearGradient gradient1 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kGold, kGoldLight],
);

const LinearGradient containerGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kGoldDark, kGold],
);

const LinearGradient gradient3 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFEF745F), Color(0xFFF7BB6A)],
);

const LinearGradient gradient4 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kGold, kGoldLight],
);

const LinearGradient greenGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [kGoldDark, kGold],
);

// ═══════════════════════════════════════════════
// AppColor Class
// ═══════════════════════════════════════════════
abstract class AppColor {
  // ── Primary ──
  static const Color primaryColor         = kGold;
  static const Color lightPrimaryColor    = kOffWhite;
  static const Color secondaryColor       = kGoldLight;
  static const Color secondaryColorShade  = Color(0xFFFFF8E1);

  // ── Neutrals ──
  static const Color whiteColor   = kWhite;
  static const Color black        = kBlack;
  static const Color darkGray     = Color(0xFF949D9E);
  static const Color lightGray    = Color(0xFFDCDEDE);
  static const Color veryLightGrey= Color(0xFFF3F5F7);
  static const Color iconColor    = Color(0xFFC9CECF);

  // ── Gray Scale ──
  static const Color gray50  = Color(0xFFF6F7F9);
  static const Color gray100 = Color(0xFFE7E8EC);
  static const Color gray200 = Color(0xFFC5C7D1);
  static const Color gray300 = Color(0xFFAFB1BE);
  static const Color gray400 = Color(0xFF999BAD);
  static const Color gray500 = Color(0xFF81859A);
  static const Color gray600 = Color(0xFF64687D);
  static const Color gray700 = Color(0xFF535566);
  static const Color gray800 = Color(0xFF40424F);
  static const Color gray900 = Color(0xFF2D2F39);

  // ── Semantic ──
  static const Color errorColor           = Color(0xFFB00020);
  static const Color transferBackground   = Color(0xFFFFEDED);
  static const Color receiveBackground    = Color(0xFFFFF8E1);
  static const Color mainRed              = Color(0xFFDE4949);

  // ── App Specific ──
  static const Color yearsBackground      = kGold;
  static const Color homeBackground       = Color(0xFFFFF8E1);
  static const Color containerBackground  = Color(0xFFFFEDD5);
  static const Color container2Background = Color(0xFFFFF3CD);
  static const Color locationBackground   = Color(0xFFFFF0CC);

  // ── Gradients ──
  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    // colors: [kGoldDark, kGold],
    colors: [kBlack, gray700],

  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF8E1), kWhite],
  );

      static const LinearGradient lightGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kGold, Color.fromARGB(255, 255, 209, 91)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kGoldDark, kGold, kGoldLight],
    stops: [0.0, 0.5, 1.0],
  );
    static const LinearGradient blackGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kBlack, gray400,kWhite],
  );

  // ── Special Cards brand entries (Phase 1 will wire these in) ──
  static const Color primaryDark  = kNavy;   // #262938
  static const Color primaryLight = kCream;  // #EDEAE4

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [kNavy, Color(0xFF3A3E55)],
  );

  // ── Semantic colors ──
  static const Color semanticError   = Color(0xFFDC2626); // red-600
  static const Color semanticSuccess = Color(0xFF16A34A); // green-600
  static const Color semanticWarning = Color(0xFFF59E0B); // amber-400
  static const Color semanticInfo    = Color(0xFF2563EB); // blue-600

  // ── Chart data palette (7 distinct accessible series colors) ──
  static const Color chartBlue   = Color(0xFF2563EB);
  static const Color chartPurple = Color(0xFF7C3AED);
  static const Color chartOrange = Color(0xFFF97316);
  static const Color chartGreen  = Color(0xFF16A34A);
  static const Color chartRed    = Color(0xFFDC2626);
  static const Color chartYellow = Color(0xFFFBBF24);
  static const Color chartCyan   = Color(0xFF06B6D4);
}