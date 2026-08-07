import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme.dart';
import '../../../models/rsvp_response.dart';

class RsvpCard extends StatelessWidget {
  final RsvpResponse r;
  const RsvpCard({super.key, required this.r});

  @override
  Widget build(BuildContext context) {
    final isAtt = r.isAttending;
    final isDec = r.isDeclined;
    final color = isAtt ? WeddingTheme.attendGreen : isDec ? WeddingTheme.declineRose : WeddingTheme.pendingGrey;
    final bg = isAtt ? WeddingTheme.attendGreen.withOpacity(0.09) : isDec ? WeddingTheme.declineRose.withOpacity(0.09) : WeddingTheme.pendingGrey.withOpacity(0.08);
    final dateStr = r.createdAt != null ? DateFormat('d MMMM yyyy • hh:mm a', 'ar').format(r.createdAt!) : '—';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: WeddingTheme.divider),
        boxShadow: WeddingTheme.softShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
                child: Center(
                  child: Text(r.guestName.characters.first, style: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: color, fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.guestName, style: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: WeddingTheme.textDark, fontSize: 14)),
                  if (r.phone != null && r.phone!.trim().isNotEmpty)
                    Row(children: [
                      const Icon(Icons.phone_rounded, size: 12, color: WeddingTheme.textLight),
                      const SizedBox(width: 4),
                      Text(r.phone!, style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textLight)),
                    ]),
                  Text(dateStr, style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textLight)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                child: Text(r.attendanceStatus.labelAr, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ),
          if (isAtt) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: WeddingTheme.cream, borderRadius: BorderRadius.circular(12), border: Border.all(color: WeddingTheme.divider)),
              child: Row(
                children: [
                  const Icon(Icons.groups_rounded, size: 18, color: WeddingTheme.goldDark),
                  const SizedBox(width: 8),
                  Text('عدد الأشخاص:', style: GoogleFonts.cairo(fontSize: 12, color: WeddingTheme.textMid, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: WeddingTheme.gold, borderRadius: BorderRadius.circular(20)),
                    child: Text('${r.guestCount} ${r.guestCount == 1 ? 'شخص' : r.guestCount == 2 ? 'شخصين' : 'أشخاص'}', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
          if (r.hasMessage) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: WeddingTheme.ivory, borderRadius: BorderRadius.circular(12), border: Border.all(color: WeddingTheme.divider.withOpacity(0.6))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote_rounded, size: 18, color: WeddingTheme.gold),
                  const SizedBox(width: 8),
                  Expanded(child: Text(r.message, style: GoogleFonts.cairo(fontSize: 13, height: 1.6, color: WeddingTheme.textDark))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
