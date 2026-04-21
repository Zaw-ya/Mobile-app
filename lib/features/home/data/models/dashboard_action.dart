import 'package:flutter/material.dart';

class DashboardAction {
  final String text;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const DashboardAction({
    required this.text,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}
