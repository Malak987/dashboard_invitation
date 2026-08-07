import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme.dart';
import '../../../models/rsvp_response.dart';

class RecentRsvpSection extends StatelessWidget {
  final List<RsvpResponse> items;
  final VoidCallback onSeeAll;
  const RecentRsvpSection({super.key, required this.items, required this.onSeeAll});

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
              Text('آخر الردود', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: WeddingTheme.textDark)),
              const Spacer(),
              InkWell(
                onTap: onSeeAll,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: WeddingTheme.goldGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text('عرض كل الردود', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_back_rounded, size: 14, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: WeddingTheme.ivoryDark, shape: BoxShape.circle),
                    child: const Icon(Icons.inbox_rounded, color: WeddingTheme.textLight, size: 28),
                  ),
                  const SizedBox(height: 10),
                  Text('لا توجد ردود بعد', style: GoogleFonts.cairo(color: WeddingTheme.textMid, fontWeight: FontWeight.w600)),
                  Text('شارك رابط الدعوة ليبدأ الضيوف بالرد', style: GoogleFonts.cairo(fontSize: 12, color: WeddingTheme.textLight)),
                ],
              ),
            )
          else
            ...items.take(6).map((r) => _row(r)),
        ],
      ),
    );
  }

  Widget _row(RsvpResponse r) {
    final isAtt = r.isAttending;
    final isDec = r.isDeclined;
    final color = isAtt ? WeddingTheme.attendGreen : isDec ? WeddingTheme.declineRose : WeddingTheme.pendingGrey;
    final bg = isAtt ? WeddingTheme.attendGreen.withOpacity(0.10) : isDec ? WeddingTheme.declineRose.withOpacity(0.10) : WeddingTheme.pendingGrey.withOpacity(0.10);
    final date = r.createdAt != null ? DateFormat('d MMM • hh:mm a', 'ar').format(r.createdAt!) : 'الآن';
    // fallback ar formatting manually if needed
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: WeddingTheme.cream, borderRadius: BorderRadius.circular(14), border: Border.all(color: WeddingTheme.divider.withOpacity(0.7))),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.18))),
            child: Icon(isAtt ? Icons.check_rounded : isDec ? Icons.close_rounded : Icons.hourglass_empty_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.guestName, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700, color: WeddingTheme.textDark)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                      child: Text(r.attendanceStatus.labelAr, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    if (isAtt)
                      Text('${r.guestCount} ${r.guestCount == 1 ? 'شخص' : r.guestCount == 2 ? 'شخصين' : 'أشخاص'}', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: WeddingTheme.textMid))
                    else
                      Text(date, style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textLight)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isAtt)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: WeddingTheme.divider)),
                  child: Row(children: [
                    const Icon(Icons.groups_rounded, size: 14, color: WeddingTheme.goldDark),
                    const SizedBox(width: 4),
                    Text('${r.guestCount}', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 13, color: WeddingTheme.brownDark)),
                  ]),
                ),
              const SizedBox(height: 4),
              Text(_timeAgo(r.createdAt), style: GoogleFonts.cairo(fontSize: 10, color: WeddingTheme.textLight)),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return 'الآن';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} ي';
    return DateFormat('d/MM').format(dt);
  }
}
