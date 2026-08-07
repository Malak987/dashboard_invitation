import 'package:cloud_firestore/cloud_firestore.dart';

enum AttendanceStatus { attending, declined, pending }

extension AttendanceStatusX on AttendanceStatus {
  String get firestoreValue => switch (this) {
        AttendanceStatus.attending => 'attending',
        AttendanceStatus.declined => 'declined',
        AttendanceStatus.pending => 'pending',
      };

  String get labelAr => switch (this) {
        AttendanceStatus.attending => 'سيحضر',
        AttendanceStatus.declined => 'لن يحضر',
        AttendanceStatus.pending => 'لم يرد',
      };

  String get emoji => switch (this) {
        AttendanceStatus.attending => '🟢',
        AttendanceStatus.declined => '🔴',
        AttendanceStatus.pending => '⚪',
      };

  static AttendanceStatus fromFirestore(Object? raw) => switch (raw) {
        'attending' => AttendanceStatus.attending,
        'declined' => AttendanceStatus.declined,
        _ => AttendanceStatus.pending,
      };
}

class RsvpResponse {
  final String id;
  final String eventId;
  final String guestId;
  final String guestName;
  final AttendanceStatus attendanceStatus;
  final int guestCount; // 1..5 if attending else 0
  final String message;
  final String language;
  final String deviceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? phone; // اختياري — قد يضاف مستقبلاً

  const RsvpResponse({
    required this.id,
    required this.eventId,
    required this.guestId,
    required this.guestName,
    required this.attendanceStatus,
    required this.guestCount,
    required this.message,
    required this.language,
    required this.deviceId,
    this.createdAt,
    this.updatedAt,
    this.phone,
  });

  factory RsvpResponse.fromFirestore(String id, Map<String, dynamic> data) {
    DateTime? readTs(Object? v) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      return null;
    }

    int readInt(Object? v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return RsvpResponse(
      id: id,
      eventId: (data['eventId'] ?? '').toString(),
      guestId: (data['guestId'] ?? id).toString(),
      guestName: (data['guestName'] ?? '').toString().trim().isEmpty ? 'ضيف' : (data['guestName'] as String).trim(),
      attendanceStatus: AttendanceStatusX.fromFirestore(data['attendanceStatus']),
      guestCount: readInt(data['guestCount']),
      message: (data['message'] ?? '').toString(),
      language: (data['language'] ?? 'ar').toString(),
      deviceId: (data['deviceId'] ?? '').toString(),
      createdAt: readTs(data['createdAt']),
      updatedAt: readTs(data['updatedAt']),
      phone: data['phone']?.toString() ?? data['phoneNumber']?.toString(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'eventId': eventId,
        'guestId': guestId,
        'guestName': guestName,
        'attendanceStatus': attendanceStatus.firestoreValue,
        'guestCount': attendanceStatus == AttendanceStatus.attending ? guestCount : 0,
        'message': message.trim(),
        'language': language,
        'deviceId': deviceId,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  bool get hasMessage => message.trim().isNotEmpty;
  bool get isAttending => attendanceStatus == AttendanceStatus.attending;
  bool get isDeclined => attendanceStatus == AttendanceStatus.declined;
}
