abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final Map<String, dynamic> stats;
  final int timestamp;

  DashboardLoaded(this.stats, {this.timestamp = 0});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
