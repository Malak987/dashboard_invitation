import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

class StatCardsGrid extends StatelessWidget {
  final int totalResponses;
  final int attending;
  final int declined;
  final int totalAttendees;
  const StatCardsGrid({super.key, required this.totalResponses, required this.attending, required this.declined, required this.totalAttendees});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        _StatCard(title: 'إجمالي الردود', value: '$totalResponses', subtitle: 'عدد الأشخاص الذين ردّوا', icon: Icons.mail_outline_rounded, gradient: const LinearGradient(colors: [Color(0xFF6B4F3B), Color(0xFF8B6B4F)])),
        _StatCard(title: 'سيحضرون', value: '$attending', subtitle: 'أكدوا الحضور', icon: Icons.check_circle_rounded, gradient: const LinearGradient(colors: [Color(0xFF6B8F7B), Color(0xFF8FBFA3)])),
        _StatCard(title: 'لن يحضروا', value: '$declined', subtitle: 'اعتذروا عن الحضور', icon: Icons.cancel_rounded, gradient: const LinearGradient(colors: [Color(0xFFC98B8B), Color(0xFFE0A6A6)])),
        _StatCard(title: 'إجمالي الحضور', value: '$totalAttendees', subtitle: 'شخص متوقع حضورهم', icon: Icons.groups_rounded, gradient: WeddingTheme.goldGradient, isGold: true),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value, subtitle;
  final IconData icon;
  final Gradient gradient;
  final bool isGold;
  const _StatCard({required this.title, required this.value, required this.subtitle, required this.icon, required this.gradient, this.isGold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WeddingTheme.divider, width: 1),
        boxShadow: WeddingTheme.softShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: isGold ? WeddingTheme.gold.withOpacity(0.12) : const Color(0xFFF5F3F0), borderRadius: BorderRadius.circular(20)),
                child: Text(title, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: isGold ? WeddingTheme.goldDark : WeddingTheme.textMid)),
              ),
            ],
          ),
          const Spacer(),
          Text(value, style: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.w800, color: WeddingTheme.textDark, height: 1)),
          const SizedBox(height: 2),
          Text(subtitle, style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textLight, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
