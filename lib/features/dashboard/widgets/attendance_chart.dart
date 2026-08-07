import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import 'dart:math' as math;

class AttendanceChart extends StatelessWidget {
  final int attending;
  final int declined;
  final int pending;
  final int totalAttendees;
  const AttendanceChart({super.key, required this.attending, required this.declined, required this.pending, required this.totalAttendees});

  @override
  Widget build(BuildContext context) {
    final total = attending + declined + pending;
    final hasData = total > 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WeddingTheme.divider),
        boxShadow: WeddingTheme.softShadow,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 22, decoration: BoxDecoration(color: WeddingTheme.gold, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 10),
              Text('إحصائيات الحضور', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: WeddingTheme.textDark)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: WeddingTheme.ivoryDark, borderRadius: BorderRadius.circular(20)),
                child: Text('مباشر • Realtime', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: WeddingTheme.brown)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: _DonutPainter(attending: attending, declined: declined, pending: pending),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$total', style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w800, color: WeddingTheme.textDark, height: 1)),
                        Text('رد', style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textLight)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    _legendRow('سيحضرون', attending, WeddingTheme.attendGreen, '${total == 0 ? 0 : ((attending / total) * 100).toStringAsFixed(0)}%'),
                    const SizedBox(height: 10),
                    _legendRow('لن يحضروا', declined, WeddingTheme.declineRose, '${total == 0 ? 0 : ((declined / total) * 100).toStringAsFixed(0)}%'),
                    if (pending > 0) ...[
                      const SizedBox(height: 10),
                      _legendRow('لم يردوا', pending, WeddingTheme.pendingGrey, '${((pending / total) * 100).toStringAsFixed(0)}%'),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [WeddingTheme.gold.withOpacity(0.10), WeddingTheme.gold.withOpacity(0.06)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: WeddingTheme.gold.withOpacity(0.18)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: WeddingTheme.gold, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.celebration_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('إجمالي الحضور المتوقع', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: WeddingTheme.textMid)),
                      Text('$totalAttendees شخص', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: WeddingTheme.brownDark)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: WeddingTheme.divider)),
                  child: Row(children: [
                    const Icon(Icons.groups_rounded, size: 16, color: WeddingTheme.goldDark),
                    const SizedBox(width: 6),
                    Text('$totalAttendees', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: WeddingTheme.brownDark)),
                  ]),
                ),
              ],
            ),
          ),
          if (!hasData) ...[
            const SizedBox(height: 12),
            Text('لا توجد ردود بعد — شارك رابط الدعوة مع ضيوفك', style: GoogleFonts.cairo(fontSize: 12, color: WeddingTheme.textLight)),
          ],
        ],
      ),
    );
  }

  Widget _legendRow(String label, int count, Color color, String percent) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600, color: WeddingTheme.textDark))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
          child: Text('$count • $percent', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final int attending, declined, pending;
  _DonutPainter({required this.attending, required this.declined, required this.pending});

  @override
  void paint(Canvas canvas, Size size) {
    final total = attending + declined + pending;
    if (total == 0) {
      final paint = Paint()
        ..color = const Color(0xFFEEE6DC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromLTWH(7, 7, size.width - 14, size.height - 14), -math.pi / 2, math.pi * 2, false, paint);
      return;
    }
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 7;
    final rect = Rect.fromCircle(center: center, radius: radius);
    double start = -math.pi / 2;

    void drawSegment(int value, Color color) {
      if (value == 0) return;
      final sweep = (value / total) * math.pi * 2;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;
      // gap 2 deg
      final gap = 0.04;
      canvas.drawArc(rect, start + gap / 2, sweep - gap, false, paint);
      start += sweep;
    }

    drawSegment(attending, const Color(0xFF6B8F7B));
    drawSegment(declined, const Color(0xFFC98B8B));
    drawSegment(pending, const Color(0xFFD8D0C5));
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.attending != attending || oldDelegate.declined != declined || oldDelegate.pending != pending;
}
