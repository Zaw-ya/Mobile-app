import 'dart:math' as math;

import 'package:app/core/theming/colors.dart';
import 'package:app/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

class DonutSegment {
  final double value;
  final Color color;

  const DonutSegment({required this.value, required this.color});
}

/// Donut chart drawn entirely with [CustomPainter].
///
/// - Each segment is separated by a visible gap.
/// - Percentage labels are drawn outside each arc at the midpoint angle.
/// - Center shows title / value / subtitle.
/// - Numbers (value, %) use ThmanyahSans. Labels use ManchetteFine.
class DonutChart extends StatelessWidget {
  final List<DonutSegment> segments;
  final String centerTitle;
  final String centerValue;
  final String centerSubtitle;
  final double size;
  final double strokeWidth;
  final bool? isConfirmStatisticsTab;

  const DonutChart({
    super.key,
    required this.segments,
    required this.centerTitle,
    required this.centerValue,
    required this.centerSubtitle,
    this.size = 270,
    this.strokeWidth = 28,
    this.isConfirmStatisticsTab,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutPainter(
          segments: segments,
          centerTitle: centerTitle,
          centerValue: centerValue,
          centerSubtitle: centerSubtitle,
          strokeWidth: strokeWidth,
          isConfirmStatisticsTab: isConfirmStatisticsTab ?? false,
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final String centerTitle;
  final String centerValue;
  final String centerSubtitle;
  final double strokeWidth;
  final bool isConfirmStatisticsTab;

  _DonutPainter({
    required this.segments,
    required this.centerTitle,
    required this.centerValue,
    required this.centerSubtitle,
    required this.strokeWidth,
    required this.isConfirmStatisticsTab,
  });

  static const double _gapDegrees = 5.0;
  static const double _gap = _gapDegrees * math.pi / 180;
  static const double _labelMargin = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.2 - strokeWidth / 2 - _labelMargin;

    final active = segments.where((s) => s.value > 0).toList();
    final total = active.fold<double>(0.0, (sum, s) => sum + s.value);

    if (total == 0 || active.isEmpty) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = AppColor.gray200,
      );
    } else {
      final totalGapAngle = _gap * active.length;
      final availableAngle = 2 * math.pi - totalGapAngle;

      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      double currentAngle = -math.pi / 2;

      for (final seg in active) {
        final sweep = (seg.value / total) * availableAngle;
        if (sweep <= 0) continue;

        arcPaint.color = seg.color;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          currentAngle,
          sweep,
          false,
          arcPaint,
        );

        final midAngle = currentAngle + sweep / 2;
        final labelR = radius + strokeWidth / 2 + 22;
        final labelPos = Offset(
          center.dx + labelR * math.cos(midAngle),
          center.dy + labelR * math.sin(midAngle),
        );
        final pct = (seg.value / total * 100).round();
        _drawText(
          canvas,
          '$pct%',
          labelPos,
          fontSize: 13,
          color: seg.color,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.thmanyahSans,
        );

        currentAngle += sweep + _gap;
      }
    }

    // Center text
    _drawText(
      canvas,
      centerTitle,
      Offset(center.dx,
          isConfirmStatisticsTab ? center.dy - 18 : center.dy - 22),
      fontSize: isConfirmStatisticsTab ? 13 : 16,
      color: AppColor.gray600,
      fontFamily: FontFamily.manchetteFine,
    );
    _drawText(
      canvas,
      centerValue,
      Offset(center.dx,
          isConfirmStatisticsTab ? center.dy + 5 : center.dy + 10),
      fontSize: isConfirmStatisticsTab ? 20 : 36,
      color: AppColor.primaryDark,
      fontWeight: FontWeight.bold,
      fontFamily: FontFamily.thmanyahSans,
    );
    _drawText(
      canvas,
      centerSubtitle,
      Offset(center.dx,
          isConfirmStatisticsTab ? center.dy + 26 : center.dy + 36),
      fontSize: isConfirmStatisticsTab ? 10 : 13,
      color: AppColor.gray400,
      fontFamily: FontFamily.manchetteFine,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset center, {
    double fontSize = 12,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    String fontFamily = FontFamily.manchetteFine,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.centerValue != centerValue ||
      old.segments.length != segments.length;
}
