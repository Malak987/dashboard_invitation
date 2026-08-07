import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/rsvp_repository.dart';
import '../services/mock_data.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final RsvpRepository _repo;
  StreamSubscription? _sub;
  bool _started = false;

  DashboardCubit({RsvpRepository? repository})
      : _repo = repository ?? RsvpRepository.instance,
        super(const DashboardState.initial());

  void start({bool forceMock = false}) {
    if (_started) return;
    _started = true;

    if (forceMock) {
      _repo.useMockMode();
      _listenMock();
      return;
    }

    // نحاول Firestore أولاً، ولو فشل permission-denied نحول تلقائياً للـ mock للمعاينة
    try {
      _sub = _repo.watchAllResponses().listen(
        (list) {
          if (isClosed) return;
          emit(DashboardState(
            status: DashboardStatus.ready,
            all: list,
            isMock: _repo.isMock,
          ));
        },
        onError: (e, st) {
          if (RsvpRepository.isPermissionDenied(e)) {
            // تلقائياً نحول لـ mock للمعاينة مع تنبيه
            _sub?.cancel();
            _repo.useMockMode();
            // نحتفظ بحالة permissionDenied أولاً ثم ننتقل للـ mock بعد ثانيتين للمعاينة
            emit(DashboardState(status: DashboardStatus.permissionDenied, all: const [], error: e.toString()));
            Future.delayed(const Duration(seconds: 2), () {
              if (!isClosed) _listenMock(showMockNote: true);
            });
          } else {
            emit(state.copyWith(status: DashboardStatus.error, error: e.toString()));
          }
        },
      );
    } catch (e) {
      emit(DashboardState(status: DashboardStatus.error, all: const [], error: e.toString()));
    }
  }

  void _listenMock({bool showMockNote = false}) {
    _sub?.cancel();
    final isImmediate = _repo.isImmediateMock;
    final stream = isImmediate
        ? Stream.value(MockData.sampleResponses())
        : MockData.mockRealtimeStream();
    _sub = stream.listen((list) {
      if (isClosed) return;
      emit(DashboardState(status: DashboardStatus.ready, all: list, isMock: true));
    });
  }

  void useMockNow() {
    _sub?.cancel();
    _started = false;
    _repo.useMockMode();
    emit(const DashboardState.initial());
    start(forceMock: true);
  }

  void retry() {
    _sub?.cancel();
    _started = false;
    emit(const DashboardState.initial());
    start();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
