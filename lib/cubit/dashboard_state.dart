import '../models/rsvp_response.dart';

enum DashboardStatus { loading, ready, error, permissionDenied }

class DashboardState {
  final DashboardStatus status;
  final List<RsvpResponse> all;
  final String? error;
  final bool isMock;

  const DashboardState({
    required this.status,
    required this.all,
    this.error,
    this.isMock = false,
  });

  const DashboardState.initial()
      : status = DashboardStatus.loading,
        all = const [],
        error = null,
        isMock = false;

  // Derived stats — نحسبها هنا لسهولة الاستخدام
  int get totalResponses => all.length;
  int get attendingCount => all.where((r) => r.isAttending).length;
  int get declinedCount => all.where((r) => r.isDeclined).length;
  int get pendingCount => all.where((r) => r.attendanceStatus == AttendanceStatus.pending).length;
  int get totalAttendees => all.where((r) => r.isAttending).fold<int>(0, (s, r) => s + r.guestCount);
  double get avgPerInvite => totalResponses == 0 ? 0 : totalAttendees / totalResponses;

  List<RsvpResponse> get recent {
    final sorted = [...all];
    sorted.sort((a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
    return sorted.take(8).toList();
  }

  List<RsvpResponse> get messagesFiltered {
    final msgs = all.where((r) => r.hasMessage).toList();
    msgs.sort((a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
    return msgs;
  }

  List<RsvpResponse> sortedAll() {
    final s = [...all];
    s.sort((a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
    return s;
  }

  DashboardState copyWith({
    DashboardStatus? status,
    List<RsvpResponse>? all,
    String? error,
    bool? isMock,
  }) =>
      DashboardState(
        status: status ?? this.status,
        all: all ?? this.all,
        error: error,
        isMock: isMock ?? this.isMock,
      );

  bool get isLoading => status == DashboardStatus.loading;
  bool get isPermissionDenied => status == DashboardStatus.permissionDenied;
}
