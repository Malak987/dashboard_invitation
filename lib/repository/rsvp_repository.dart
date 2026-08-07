import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rsvp_response.dart';
import '../services/mock_data.dart';

/// طبقة البيانات — نفس Collection المستخدم في موقع الدعوة: guestResponses
/// تدعم realtime عبر snapshots() + fallback للـ mock عند عدم توفر Firebase
class RsvpRepository {
  static final RsvpRepository instance = RsvpRepository._internal();
  RsvpRepository._internal();

  // تأخير تهيئة Firestore حتى الاستخدام الفعلي (lazy) ليمر الاختبار بدون Firebase
  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection('guestResponses');

  bool _useMock = false;
  bool _immediateMock = false;
  Stream<List<RsvpResponse>>? _cached;

  void useMockMode({bool immediate = false}) {
    _useMock = true;
    _immediateMock = immediate;
  }

  bool get isMock => _useMock;
  bool get isImmediateMock => _immediateMock;

  /// Stream رئيسي — يغذي الـ Dashboard والـ RSVP والـ Messages
  Stream<List<RsvpResponse>> watchAllResponses() {
    if (_useMock) {
      if (_immediateMock) {
        return Stream.value(MockData.sampleResponses()).asBroadcastStream();
      }
      return MockData.mockRealtimeStream().asBroadcastStream();
    }
    // إذا لم يكن Firebase مهيأ، نسقط تلقائياً للـ mock
    try {
      _cached ??= _col
          .snapshots()
          .map((qs) => qs.docs.map((d) => RsvpResponse.fromFirestore(d.id, d.data())).toList())
          .handleError((e) => throw e)
          .asBroadcastStream();
      return _cached!;
    } catch (e) {
      // fallback للمعاينة في حالة no-app
      _useMock = true;
      return MockData.mockRealtimeStream().asBroadcastStream();
    }
  }

  Stream<List<RsvpResponse>> watchMessages() {
    return watchAllResponses().map((all) => all.where((r) => r.hasMessage).toList()
      ..sort((a, b) => (b.createdAt ?? DateTime(2000)).compareTo(a.createdAt ?? DateTime(2000))));
  }

  static bool isPermissionDenied(Object e) {
    final s = e.toString();
    return s.contains('permission-denied') || s.contains('PERMISSION_DENIED') || s.contains('permission_denied');
  }

  static bool isNetworkError(Object e) {
    final s = e.toString().toLowerCase();
    return s.contains('unavailable') || s.contains('network') || s.contains('failed-precondition');
  }

  // للاختبارات: إعادة الضبط
  void resetForTest() {
    _useMock = false;
    _cached = null;
  }
}
