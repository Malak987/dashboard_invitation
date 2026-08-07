import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'صباح الخير';
    if (h < 17) return 'مساء الخير';
    return 'مساء الخير';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: WeddingTheme.goldGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: WeddingTheme.goldShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${_greeting()} ❤️', style: GoogleFonts.cairo(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('متابعة دعوة الزفاف', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.92))),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text('سيف & ميرنا', style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(width: 6),
                      Text('23 أغسطس 2026', style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withOpacity(0.9))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}
