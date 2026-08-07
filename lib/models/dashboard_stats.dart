class DashboardStats {
  final int totalResponses;
  final int attendingCount;
  final int declinedCount;
  final int pendingCount;
  final int totalAttendees; // sum guestCount for attending
  final double avgPerInvitation;

  const DashboardStats({
    required this.totalResponses,
    required this.attendingCount,
    required this.declinedCount,
    required this.pendingCount,
    required this.totalAttendees,
    required this.avgPerInvitation,
  });

  const DashboardStats.empty()
      : totalResponses = 0,
        attendingCount = 0,
        declinedCount = 0,
        pendingCount = 0,
        totalAttendees = 0,
        avgPerInvitation = 0;

  bool get isEmpty => totalResponses == 0;
}

DashboardStats aggregateStats(List<dynamic> responses) {
  // يعمل مع List<RsvpResponse>
  var attending = 0, declined = 0, pending = 0, attendees = 0;
  for (final r in responses) {
    // dynamic to avoid import cycle, نثق أن له attendanceStatus و guestCount
    final status = r.attendanceStatus;
    final count = r.guestCount as int;
    if (status.toString().contains('attending')) {
      attending++;
      attendees += count;
    } else if (status.toString().contains('declined')) {
      declined++;
    } else {
      pending++;
    }
  }
  final total = responses.length;
  final avg = total == 0 ? 0.0 : attendees / total;
  return DashboardStats(
    totalResponses: total,
    attendingCount: attending,
    declinedCount: declined,
    pendingCount: pending,
    totalAttendees: attendees,
    avgPerInvitation: avg,
  );
}
