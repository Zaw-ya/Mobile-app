import 'package:app/core/theming/colors.dart';
import 'package:flutter/material.dart';

/// Returns a navy-opacity tier for event index — brand-consistent palette.
Color getEventColor(int index) {
  const tiers = [
    AppColor.primaryDark,
    Color(0xCC262938), // 80 %
    Color(0x99262938), // 60 %
    Color(0x66262938), // 40 %
    Color(0x40262938), // 25 %
  ];
  return tiers[index % tiers.length];
}
