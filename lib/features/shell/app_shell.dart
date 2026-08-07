import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';
import '../dashboard/dashboard_screen.dart';
import '../rsvp/rsvp_list_screen.dart';
import '../messages/messages_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _idx = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(
        onSeeAllRsvp: () => setState(() => _idx = 1),
        onSeeAllMessages: () => setState(() => _idx = 2),
      ),
      const RsvpListScreen(),
      const MessagesScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -4)),
          ],
          border: Border(top: BorderSide(color: WeddingTheme.divider, width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 4),
            child: BottomNavigationBar(
              currentIndex: _idx,
              onTap: (i) => setState(() => _idx = i),
              backgroundColor: Colors.white,
              elevation: 0,
              selectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 11),
              unselectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.w500, fontSize: 11),
              selectedItemColor: WeddingTheme.goldDark,
              unselectedItemColor: WeddingTheme.textLight,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: _navIcon(Icons.dashboard_rounded, 0),
                  activeIcon: _navIconActive(Icons.dashboard_rounded),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: _navIcon(Icons.people_alt_rounded, 1),
                  activeIcon: _navIconActive(Icons.people_alt_rounded),
                  label: 'الحضور',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _navIcon(Icons.favorite_rounded, 2),
                      BlocBuilder<DashboardCubit, DashboardState>(
                        builder: (c, s) {
                          final unread = s.messagesFiltered.length;
                          if (unread == 0) return const SizedBox.shrink();
                          return Positioned(
                            right: -6,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(color: WeddingTheme.gold, borderRadius: BorderRadius.circular(10)),
                              child: Text('$unread', style: GoogleFonts.cairo(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  activeIcon: _navIconActive(Icons.favorite_rounded),
                  label: 'الرسائل',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int idx) {
    final isActive = _idx == idx;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isActive ? WeddingTheme.gold.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22, color: isActive ? WeddingTheme.goldDark : WeddingTheme.textLight),
    );
  }

  Widget _navIconActive(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: WeddingTheme.goldGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: WeddingTheme.goldShadow,
      ),
      child: Icon(icon, size: 22, color: Colors.white),
    );
  }
}
