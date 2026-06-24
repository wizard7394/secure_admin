import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../data/dashboard_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;
  Timer? _liveTimer;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<FetchDashboardStats>(_onFetchStats);
    on<StartLiveUpdate>(_onStartLiveUpdate);
    on<StopLiveUpdate>(_onStopLiveUpdate);
  }

  Future<void> _onFetchStats(
    FetchDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (state is! DashboardLoaded) {
        emit(DashboardLoading());
      }

      final stats = await repository.getDashboardStats();

      // با اتچ کردن میلی‌ثانیه، Bloc مجبور میشه صفحه رو آپدیت کنه
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
    }
  }

  void _onStartLiveUpdate(StartLiveUpdate event, Emitter<DashboardState> emit) {
    add(FetchDashboardStats());

    _liveTimer?.cancel();
    _liveTimer = Timer.periodic(const Duration(seconds: 2), (_) {
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
