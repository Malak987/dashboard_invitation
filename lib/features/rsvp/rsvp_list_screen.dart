import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';
import '../../models/rsvp_response.dart';
import 'widgets/rsvp_card.dart';

class RsvpListScreen extends StatefulWidget {
  const RsvpListScreen({super.key});
  @override
  State<RsvpListScreen> createState() => _RsvpListScreenState();
}

class _RsvpListScreenState extends State<RsvpListScreen> {
  String _filter = 'all'; // all / attending / declined / pending
  String _query = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: WeddingTheme.ivory,
        appBar: AppBar(
          title: Text('الحضور', style: GoogleFonts.cairo(fontWeight: FontWeight.w800)),
          centerTitle: true,
          backgroundColor: WeddingTheme.ivory,
          surfaceTintColor: Colors.transparent,
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.isLoading) return const Center(child: CircularProgressIndicator(color: WeddingTheme.gold));
            if (state.isPermissionDenied) {
              return Center(child: Text('يرجى تحديث Firestore Rules', style: GoogleFonts.cairo(color: WeddingTheme.textMid)));
            }
            final allSorted = state.sortedAll();
            final filtered = allSorted.where((r) {
              final matchesFilter = _filter == 'all' ||
                  (_filter == 'attending' && r.isAttending) ||
                  (_filter == 'declined' && r.isDeclined) ||
                  (_filter == 'pending' && r.attendanceStatus == AttendanceStatus.pending);
              final matchesSearch = _query.isEmpty || r.guestName.toLowerCase().contains(_query.toLowerCase());
              return matchesFilter && matchesSearch;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Column(
                    children: [
                      // Search
                      TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _query = v),
                        decoration: InputDecoration(
                          hintText: 'ابحث بالاسم...',
                          hintStyle: GoogleFonts.cairo(color: WeddingTheme.textLight, fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded, color: WeddingTheme.textLight),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(icon: const Icon(Icons.clear_rounded, size: 18), onPressed: () => setState(() { _query = ''; _searchCtrl.clear(); }))
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: WeddingTheme.divider)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: WeddingTheme.divider)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: WeddingTheme.gold, width: 1.2)),
                        ),
                        style: GoogleFonts.cairo(fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      // Filters
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _chip('الكل', 'all', state.totalResponses),
                            const SizedBox(width: 8),
                            _chip('سيحضرون', 'attending', state.attendingCount),
                            const SizedBox(width: 8),
                            _chip('لن يحضروا', 'declined', state.declinedCount),
                            const SizedBox(width: 8),
                            _chip('لم يردوا', 'pending', state.pendingCount),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // count bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: WeddingTheme.divider)),
                    child: Row(
                      children: [
                        Text('النتائج:', style: GoogleFonts.cairo(fontSize: 12, color: WeddingTheme.textLight)),
                        const SizedBox(width: 6),
                        Text('${filtered.length}', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: WeddingTheme.textDark)),
                        const Spacer(),
                        if (_filter == 'attending')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: WeddingTheme.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                            child: Text('إجمالي الأشخاص: ${filtered.where((r) => r.isAttending).fold<int>(0, (s, r) => s + r.guestCount)}', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: WeddingTheme.goldDark)),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: WeddingTheme.softShadow),
                              child: const Icon(Icons.search_off_rounded, size: 32, color: WeddingTheme.textLight),
                            ),
                            const SizedBox(height: 12),
                            Text('لا توجد نتائج', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: WeddingTheme.textMid)),
                            Text('جرّب تغيير الفلتر أو البحث', style: GoogleFonts.cairo(fontSize: 12, color: WeddingTheme.textLight)),
                          ]),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => RsvpCard(r: filtered[i]),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _chip(String label, String value, int count) {
    final selected = _filter == value;
    return ChoiceChip(
      label: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: selected ? Colors.white : WeddingTheme.textMid)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(color: selected ? Colors.white.withOpacity(0.25) : WeddingTheme.ivoryDark, borderRadius: BorderRadius.circular(20)),
          child: Text('$count', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w800, color: selected ? Colors.white : WeddingTheme.textDark)),
        ),
      ]),
      selected: selected,
      onSelected: (_) => setState(() => _filter = value),
      selectedColor: WeddingTheme.gold,
      backgroundColor: Colors.white,
      side: BorderSide(color: selected ? WeddingTheme.gold : WeddingTheme.divider),
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    );
  }
}
