import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../../models/rsvp_response.dart';

class RecentMessagesSection extends StatelessWidget {
  final List<RsvpResponse> messages;
  final VoidCallback onSeeAll;
  const RecentMessagesSection({super.key, required this.messages, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WeddingTheme.divider),
        boxShadow: WeddingTheme.softShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 4, height: 20, decoration: BoxDecoration(color: WeddingTheme.gold, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 10),
              Text('رسائل الضيوف', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: WeddingTheme.textDark)),
              const SizedBox(width: 6),
              const Text('❤️', style: TextStyle(fontSize: 16)),
              const Spacer(),
              InkWell(
                onTap: onSeeAll,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: WeddingTheme.ivoryDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: WeddingTheme.divider)),
                  child: Row(children: [
                    Text('عرض كل الرسائل', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: WeddingTheme.brown)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_back_rounded, size: 14, color: WeddingTheme.brown),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (messages.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFFFFF0F3), shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border_rounded, color: WeddingTheme.declineRose, size: 26),
                ),
                const SizedBox(height: 10),
                Text('لا توجد رسائل بعد', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: WeddingTheme.textMid)),
                Text('رسائل التهاني ستظهر هنا تلقائياً ✨', style: GoogleFonts.cairo(fontSize: 12, color: WeddingTheme.textLight)),
              ]),
            )
          else
            ...messages.take(3).map((m) => _msgCard(m)),
        ],
      ),
    );
  }

  Widget _msgCard(RsvpResponse r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, WeddingTheme.cream]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WeddingTheme.divider),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(gradient: WeddingTheme.goldGradient, shape: BoxShape.circle),
                child: Center(child: Text(r.guestName.characters.first, style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.guestName, style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 13, color: WeddingTheme.textDark)),
                  Text(
                    r.createdAt != null ? '${r.createdAt!.day}/${r.createdAt!.month}/${r.createdAt!.year}' : 'الآن',
                    style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textLight),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFFFF0F3), shape: BoxShape.circle),
                child: const Icon(Icons.favorite, size: 14, color: WeddingTheme.declineRose),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: WeddingTheme.ivory.withOpacity(0.7), borderRadius: BorderRadius.circular(12)),
            child: Text('"${r.message}"', style: GoogleFonts.cairo(fontSize: 13, height: 1.6, color: WeddingTheme.textDark, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
