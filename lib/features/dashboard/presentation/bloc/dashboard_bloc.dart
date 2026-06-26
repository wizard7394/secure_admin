import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../data/dashboard_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;
  Timer? _liveTimer;
  bool _isFetching = false; // قفل جلوگیری از رگبار ریکوئست

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<FetchDashboardStats>(_onFetchStats);
    on<StartLiveUpdate>(_onStartLiveUpdate);
    on<StopLiveUpdate>(_onStopLiveUpdate);
  }

  Future<void> _onFetchStats(
    FetchDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    // اگر ریکوئست قبلی هنوز تو راهه یا تموم نشده، ریکوئست جدید رو دراپ کن
    if (_isFetching) return;
    _isFetching = true;

    try {
      if (state is! DashboardLoaded) {
        emit(DashboardLoading());
      }
      final stats = await repository.getDashboardStats();
      emit(
        DashboardLoaded(
          stats,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (e) {
      if (state is! DashboardLoaded) {
        emit(DashboardError(e.toString()));
      }
    } finally {
      // قفل رو باز کن تا تایمر بعدی بتونه کار کنه
      _isFetching = false;
    }
  }

  void _onStartLiveUpdate(StartLiveUpdate event, Emitter<DashboardState> emit) {
    if (_liveTimer != null && _liveTimer!.isActive) return;

    add(FetchDashboardStats());

    _liveTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      add(FetchDashboardStats());
    });
  }

  void _onStopLiveUpdate(StopLiveUpdate event, Emitter<DashboardState> emit) {
    _liveTimer?.cancel();
    _liveTimer = null;
  }

  @override
  Future<void> close() {
    _liveTimer?.cancel();
    return super.close();
  }
}
