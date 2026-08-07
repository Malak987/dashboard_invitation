import '../models/rsvp_response.dart';

/// بيانات تجريبية للمعاينة عندما لا يتوفر Firestore أو عند permission-denied
/// تحاكي نفس شكل guestResponses الحقيقي
class MockData {
  static List<RsvpResponse> sampleResponses() {
    final now = DateTime.now();
    return [
      RsvpResponse(
        id: 'engagement_001_guest_1',
        eventId: 'engagement_001',
        guestId: 'guest_1',
        guestName: 'أحمد محمد',
        attendanceStatus: AttendanceStatus.attending,
        guestCount: 4,
        message: 'ألف مبروك وربنا يسعدكم ويتمم لكم على خير ❤️ بارك الله لكما',
        language: 'ar',
        deviceId: 'dev1',
        createdAt: now.subtract(const Duration(hours: 2)),
        phone: '01012345678',
      ),
      RsvpResponse(
        id: 'engagement_001_guest_2',
        eventId: 'engagement_001',
        guestId: 'guest_2',
        guestName: 'محمد علي',
        attendanceStatus: AttendanceStatus.attending,
        guestCount: 2,
        message: 'مبروك يا سيف وميرنا، ربنا يتمم بخير',
        language: 'ar',
        deviceId: 'dev2',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      RsvpResponse(
        id: 'engagement_001_guest_3',
        eventId: 'engagement_001',
        guestId: 'guest_3',
        guestName: 'سارة أحمد',
        attendanceStatus: AttendanceStatus.declined,
        guestCount: 0,
        message: 'آسفة جداً مش هقدر أحضر لظروف السفر، ألف مبروك ❤️',
        language: 'ar',
        deviceId: 'dev3',
        createdAt: now.subtract(const Duration(hours: 7)),
      ),
      RsvpResponse(
        id: 'engagement_001_guest_4',
        eventId: 'engagement_001',
        guestId: 'guest_4',
        guestName: 'عائلة الحاج محمود',
        attendanceStatus: AttendanceStatus.attending,
        guestCount: 5,
        message: 'بالرفاه والبنين إن شاء الله',
        language: 'ar',
        deviceId: 'dev4',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      RsvpResponse(
        id: 'engagement_001_guest_5',
        eventId: 'engagement_001',
        guestId: 'guest_5',
        guestName: 'نورا خالد',
        attendanceStatus: AttendanceStatus.attending,
        guestCount: 3,
        message: 'ربنا يسعدكم ويهنيكم يا رب 🥰',
        language: 'ar',
        deviceId: 'dev5',
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      RsvpResponse(
        id: 'engagement_001_guest_6',
        eventId: 'engagement_001',
        guestId: 'guest_6',
        guestName: 'يوسف إبراهيم',
        attendanceStatus: AttendanceStatus.declined,
        guestCount: 0,
        message: '',
        language: 'ar',
        deviceId: 'dev6',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      RsvpResponse(
        id: 'engagement_001_guest_7',
        eventId: 'engagement_001',
        guestId: 'guest_7',
        guestName: 'خالد حسن',
        attendanceStatus: AttendanceStatus.attending,
        guestCount: 2,
        message: 'ألف مبروك يا غالي ❤️',
        language: 'ar',
        deviceId: 'dev7',
        createdAt: now.subtract(const Duration(days: 2, hours: 4)),
      ),
      RsvpResponse(
        id: 'engagement_001_guest_8',
        eventId: 'engagement_001',
        guestId: 'guest_8',
        guestName: 'إسراء محمد',
        attendanceStatus: AttendanceStatus.pending,
        guestCount: 0,
        message: '',
        language: 'ar',
        deviceId: 'dev8',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      RsvpResponse(
        id: 'engagement_001_guest_9',
        eventId: 'engagement_001',
        guestId: 'guest_9',
        guestName: 'عمر سعد',
        attendanceStatus: AttendanceStatus.attending,
        guestCount: 1,
        message: 'مبروك مبروك 🎉',
        language: 'ar',
        deviceId: 'dev9',
        createdAt: now.subtract(const Duration(days: 3, hours: 2)),
      ),
      RsvpResponse(
        id: 'engagement_001_guest_10',
        eventId: 'engagement_001',
        guestId: 'guest_10',
        guestName: 'ليلى سمير',
        attendanceStatus: AttendanceStatus.attending,
        guestCount: 4,
        message: 'ربنا يجمعكم على خير وسعادة دايمًا',
        language: 'ar',
        deviceId: 'dev10',
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      // extra for bigger numbers
      RsvpResponse(
        id: 'engagement_001_guest_11',
        eventId: 'engagement_001',
        guestId: 'guest_11',
        guestName: 'حسام الدين',
        attendanceStatus: AttendanceStatus.attending,
        guestCount: 3,
        message: 'ألف مبروك للعروسين',
        language: 'ar',
        deviceId: 'dev11',
        createdAt: now.subtract(const Duration(days: 4, hours: 6)),
      ),
      RsvpResponse(
        id: 'engagement_001_guest_12',
        eventId: 'engagement_001',
        guestId: 'guest_12',
        guestName: 'د. منى',
        attendanceStatus: AttendanceStatus.declined,
        guestCount: 0,
        message: 'بالتوفيق والسعادة',
        language: 'ar',
        deviceId: 'dev12',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  /// Stream محاكي realtime — يضيف حدث جديد كل 18 ثانية للمعاينة
  static Stream<List<RsvpResponse>> mockRealtimeStream() async* {
    var list = sampleResponses();
    yield list;
    // mock تحديث بعد فترة لاظهار ال realtime
    await Future.delayed(const Duration(seconds: 18));
    final extra = RsvpResponse(
      id: 'engagement_001_guest_live',
      eventId: 'engagement_001',
      guestId: 'guest_live',
      guestName: 'ضيف جديد ✨',
      attendanceStatus: AttendanceStatus.attending,
      guestCount: 2,
      message: 'تأكيد جديد الآن — Realtime شغال ❤️',
      language: 'ar',
      deviceId: 'live',
      createdAt: DateTime.now(),
    );
    list = [extra, ...list];
    yield list;
  }
}
