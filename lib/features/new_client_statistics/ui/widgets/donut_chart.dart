import 'dart:math' as math;

import 'package:app/core/theming/colors.dart';
import 'package:flutter/material.dart';

/// A single arc segment in the donut chart.
class DonutSegment {
  final double value;
  final Color color;

  const DonutSegment({required this.value, required this.color});
}

/// Donut chart drawn entirely with [CustomPainter].
///
/// - Each segment is separated by a visible gap (like the design image).
/// - Percentage labels are drawn outside each arc at the midpoint angle.
/// - Center shows title / value / subtitle.
class DonutChart extends StatelessWidget {
  final List<DonutSegment> segments;

  /// Small label above the center number (e.g. "جميع الضيوف").
  final String centerTitle;

  /// Large number in the center (e.g. "228").
  final String centerValue;

  /// Small label below the center number (e.g. "ضيف").
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

// ── Painter ───────────────────────────────────────────────────────────────────

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

  // Gap between segments in radians (~6°) — clearly visible like the design.
  static const double _gapDegrees = 6.0;
  static const double _gap = _gapDegrees * math.pi / 180;

  // Extra space outside the ring reserved for percentage labels.
  static const double _labelMargin = 22.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Shrink the radius to leave room for labels outside the ring.
    final radius = size.width / 2 - strokeWidth / 2 - _labelMargin;

    final active = segments.where((s) => s.value > 0).toList();
    final total = active.fold<double>(0.0, (sum, s) => sum + s.value);

    if (total == 0 || active.isEmpty) {
      // Empty state — single grey ring.
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = Colors.grey.shade200,
      );
    } else {
      final totalGapAngle = _gap * active.length;
      final availableAngle = 2 * math.pi - totalGapAngle;

      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt; // flat ends → clean gap

      // Start from the top (−90°).
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

        // ── Percentage label ────────────────────────────────────────────
        final midAngle = currentAngle + sweep / 2;
        // Push the label a bit further out than the arc's outer edge.
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
          fontSize: 18,
          color: seg.color,
          fontWeight: FontWeight.w700,
        );

        // Advance past the arc AND the gap.
        currentAngle += sweep + _gap;
      }
    }

    // ── Center text ────────────────────────────────────────────────────────
    _drawText(
      canvas,
      centerTitle,
      Offset(
          center.dx, isConfirmStatisticsTab ? center.dy - 18 : center.dy - 22),
      fontSize: isConfirmStatisticsTab ? 14 : 18,
      color: AppColor.gray600,
    );
    _drawText(
      canvas,
      centerValue,
      Offset(
          center.dx, isConfirmStatisticsTab ? center.dy + 5 : center.dy + 10),
      fontSize: isConfirmStatisticsTab ? 20 : 35,
      color: AppColor.primaryColor,
      fontWeight: FontWeight.bold,
    );
    _drawText(
      canvas,
      centerSubtitle,
      Offset(center.dx,isConfirmStatisticsTab?center.dy + 25: center.dy + 36),
      fontSize: isConfirmStatisticsTab ? 10 : 14,
      color: AppColor.gray300,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset center, {
    double fontSize = 12,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
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
      old.centerValue != centerValue || old.segments.length != segments.length;
}
