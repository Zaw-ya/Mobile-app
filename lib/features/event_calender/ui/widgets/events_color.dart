import 'package:flutter/material.dart';

/// Generates consistent colors for events
Color getEventColor(int index) {
  final colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];
  return colors[index % colors.length];
}
