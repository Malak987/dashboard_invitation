import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';
import 'widgets/greeting_header.dart';
import 'widgets/stat_cards.dart';
import 'widgets/attendance_chart.dart';
import 'widgets/recent_rsvp.dart';
import 'widgets/recent_messages.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onSeeAllRsvp;
  final VoidCallback? onSeeAllMessages;
  const DashboardScreen({super.key, this.onSeeAllRsvp, this.onSeeAllMessages});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: WeddingTheme.ivory,
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.isLoading) return const _LoadingView();
            if (state.isPermissionDenied) {
              return _PermissionDeniedView(onMock: () => context.read<DashboardCubit>().useMockNow());
            }
            if (state.status == DashboardStatus.error) {
              return _ErrorView(msg: state.error ?? 'حدث خطأ', onRetry: () => context.read<DashboardCubit>().retry());
            }
            return _DashboardContent(state: state, onSeeAllRsvp: onSeeAllRsvp, onSeeAllMessages: onSeeAllMessages);
          },
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardState state;
  final VoidCallback? onSeeAllRsvp;
  final VoidCallback? onSeeAllMessages;
  const _DashboardContent({required this.state, this.onSeeAllRsvp, this.onSeeAllMessages});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: false,
          floating: false,
          expandedHeight: 0,
          backgroundColor: WeddingTheme.ivory,
          surfaceTintColor: Colors.transparent,
          title: Text('دعوة الزفاف ❤️', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: WeddingTheme.brownDark, fontSize: 16)),
          centerTitle: true,
          actions: [
            if (state.isMock)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: WeddingTheme.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: WeddingTheme.gold.withOpacity(0.3))),
                  child: Row(children: [
                    const Icon(Icons.visibility_rounded, size: 12, color: WeddingTheme.goldDark),
                    const SizedBox(width: 4),
                    Text('وضع المعاينة', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: WeddingTheme.goldDark)),
                  ]),
                ),
              ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverList.list(
            children: [
              const GreetingHeader(),
              const SizedBox(height: 16),
              StatCardsGrid(
                totalResponses: state.totalResponses,
                attending: state.attendingCount,
                declined: state.declinedCount,
                totalAttendees: state.totalAttendees,
              ),
              const SizedBox(height: 16),
              AttendanceChart(
                attending: state.attendingCount,
                declined: state.declinedCount,
                pending: state.pendingCount,
                totalAttendees: state.totalAttendees,
              ),
              const SizedBox(height: 16),
              RecentRsvpSection(
                items: state.recent,
                onSeeAll: onSeeAllRsvp ?? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('افتح تبويب الحضور', style: GoogleFonts.cairo()))),
              ),
              const SizedBox(height: 16),
              RecentMessagesSection(
                messages: state.messagesFiltered,
                onSeeAll: onSeeAllMessages ?? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('افتح تبويب الرسائل', style: GoogleFonts.cairo()))),
              ),
              const SizedBox(height: 12),
              if (state.isMock)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: WeddingTheme.gold.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: WeddingTheme.gold.withOpacity(0.15), shape: BoxShape.circle), child: const Icon(Icons.info_outline_rounded, size: 18, color: WeddingTheme.goldDark)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('وضع المعاينة نشط', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 13, color: WeddingTheme.brownDark)),
                          Text('البيانات الحالية تجريبية. لتوصيل البيانات الحقيقية، حدّث Firestore Rules كما في README.', style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textMid, height: 1.4)),
                        ]),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Center(child: Text('صُنع بحب لسيف & ميرنا ❤️', style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textLight))),
              const SizedBox(height: 4),
              Center(child: Text('sofamirna-2026 • guestResponses • Realtime', style: GoogleFonts.cairo(fontSize: 10, color: WeddingTheme.textLight.withOpacity(0.7)))),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(gradient: WeddingTheme.goldGradient, shape: BoxShape.circle, boxShadow: WeddingTheme.goldShadow),
          child: const Icon(Icons.favorite, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 16),
        Text('جاري تحميل الدعوة...', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: WeddingTheme.textMid)),
        const SizedBox(height: 12),
        const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.5, color: WeddingTheme.gold)),
      ]),
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  final VoidCallback onMock;
  const _PermissionDeniedView({required this.onMock});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: WeddingTheme.softShadow),
            child: const Icon(Icons.lock_outline_rounded, size: 38, color: WeddingTheme.goldDark),
          ),
          const SizedBox(height: 18),
          Text('الوصول محمي حالياً', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: WeddingTheme.textDark)),
          const SizedBox(height: 8),
          Text(
            'قواعد Firestore في موقع الدعوة تمنع القراءة بدون تسجيل دخول (isAdmin). ولأن تطبيق العريس بدون Login، يجب تحديث القواعد للسماح بالقراءة.',
            style: GoogleFonts.cairo(fontSize: 13, color: WeddingTheme.textMid, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(14)),
            child: SelectableText(
              r'''rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /guestResponses/{id} {
      allow list, get: if true; // للسماح لتطبيق العريس بدون Login
      allow create, update: if isRsvpBaseValid();
      allow delete: if false;
    }
  }
}''',
              style: GoogleFonts.cairo(fontSize: 11, color: const Color(0xFFB5FFB5), height: 1.5),
              textDirection: TextDirection.ltr,
            ),
          ),
          const SizedBox(height: 10),
          Text('انسخ هذا التعديل إلى firestore.rules ثم: firebase deploy --only firestore:rules', style: GoogleFonts.cairo(fontSize: 11, color: WeddingTheme.textLight), textAlign: TextAlign.center),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onMock,
              icon: const Icon(Icons.visibility_rounded, color: Colors.white, size: 18),
              label: Text('المتابعة في وضع المعاينة (بيانات تجريبية)', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: WeddingTheme.brown, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.read<DashboardCubit>().retry(),
            child: Text('إعادة المحاولة', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: WeddingTheme.goldDark)),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;
  const _ErrorView({required this.msg, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: WeddingTheme.textLight),
          const SizedBox(height: 12),
          Text('تعذر تحميل البيانات', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: WeddingTheme.textDark)),
          const SizedBox(height: 6),
          Text(msg, style: GoogleFonts.cairo(fontSize: 12, color: WeddingTheme.textMid), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, style: ElevatedButton.styleFrom(backgroundColor: WeddingTheme.gold), child: Text('إعادة المحاولة', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700))),
          TextButton(onPressed: () => context.read<DashboardCubit>().useMockNow(), child: Text('فتح وضع المعاينة', style: GoogleFonts.cairo(color: WeddingTheme.brown))),
        ]),
      ),
    );
  }
}
