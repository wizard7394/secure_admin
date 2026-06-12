import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc(this._repository) : super(DashboardInitial()) {
    on<FetchDashboardStats>(_onFetchDashboardStats);
  }

  Future<void> _onFetchDashboardStats(
    FetchDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final data = await _repository.getDashboardStats();
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
