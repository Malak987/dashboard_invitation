import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';
import '../../models/rsvp_response.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: WeddingTheme.ivory,
        appBar: AppBar(
          title: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('رسائل الضيوف', style: GoogleFonts.cairo(fontWeight: FontWeight.w800)),
            const SizedBox(width: 6),
            const Text('❤️', style: TextStyle(fontSize: 18)),
          ]),
          centerTitle: true,
          backgroundColor: WeddingTheme.ivory,
          surfaceTintColor: Colors.transparent,
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.isLoading) return const Center(child: CircularProgressIndicator(color: WeddingTheme.gold));
            final msgs = state.messagesFiltered;
            if (msgs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(color: const Color(0xFFFFF0F3), shape: BoxShape.circle, border: Border.all(color: WeddingTheme.declineRose.withOpacity(0.15), width: 1.5)),
                      child: const Icon(Icons.favorite_rounded, size: 36, color: WeddingTheme.declineRose),
                    ),
                    const SizedBox(height: 16),
                    Text('لا توجد رسائل بعد', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: WeddingTheme.textDark)),
                    const SizedBox(height: 6),
                    Text('رسائل وتهاني الضيوف من موقع الدعوة\nستظهر هنا تلقائياً لحظياً ✨', style: GoogleFonts.cairo(color: WeddingTheme.textMid, height: 1.6), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: WeddingTheme.divider)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text('في انتظار أول رسالة...', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: WeddingTheme.textMid)),
                      ]),
                    ),
                  ]),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: msgs.length,
              itemBuilder: (_, i) => _MessageCard(msg: msgs[i], isFirst: i == 0),
            );
          },
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final RsvpResponse msg;
  final bool isFirst;
  const _MessageCard({required this.msg, required this.isFirst});

  @override
  Widget build(BuildContext context) {
    final date = msg.createdAt != null ? '${msg.createdAt!.day}/${msg.createdAt!.month}/${msg.createdAt!.year} • ${msg.createdAt!.hour.toString().padLeft(2, '0')}:${msg.createdAt!.minute.toString().padLeft(2, '0')}' : 'الآن';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isFirst ? WeddingTheme.gold.withOpacity(0.35) : WeddingTheme.divider),
        boxShadow: isFirst ? WeddingTheme.goldShadow : WeddingTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFirst)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                gradient: WeddingTheme.goldGradient,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(children: [
                const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text('أحدث رسالة', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                const Spacer(),
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('جديد', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(gradient: WeddingTheme.goldGradient, shape: BoxShape.circle),
                      child: Center(child: Text(msg.guestName.characters.first, style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w800))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(msg.guestName, style: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: WeddingTheme.textDark, fontSize: 14)),
                        Text(date, style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textLight)),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xFFFFF0F3), borderRadius: BorderRadius.circular(20)),
                      child: Row(children: [
                        const Icon(Icons.favorite, size: 12, color: WeddingTheme.declineRose),
                        const SizedBox(width: 4),
                        Text(msg.isAttending ? 'سيحضر' : msg.isDeclined ? 'اعتذر' : 'رسالة', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: WeddingTheme.brown)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: WeddingTheme.ivory,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: WeddingTheme.divider.withOpacity(0.6)),
                  ),
                  child: Text(
                    '"${msg.message}"',
                    style: GoogleFonts.cairo(fontSize: 14, height: 1.7, color: WeddingTheme.textDark, fontWeight: FontWeight.w500),
                  ),
                ),
                if (msg.isAttending) ...[
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.groups_rounded, size: 14, color: WeddingTheme.textLight),
                    const SizedBox(width: 6),
                    Text('${msg.guestCount} ${msg.guestCount == 1 ? 'شخص' : 'أشخاص'}', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: WeddingTheme.textMid)),
                    const Spacer(),
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: WeddingTheme.attendGreen, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('مؤكد الحضور', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: WeddingTheme.attendGreen)),
                  ]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
