import 'package:get_it/get_it.dart';
import 'package:secure_admin/features/courses/data/course_repository.dart';
import 'package:secure_admin/features/courses/presentation/bloc/course_bloc.dart';
import 'package:secure_admin/features/courses/presentation/bloc/course_details_bloc.dart';
import 'package:secure_admin/features/dashboard/data/dashboard_repository.dart';
import 'package:secure_admin/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:secure_admin/features/devices/data/device_repository.dart';
import 'package:secure_admin/features/devices/presentation/bloc/device_bloc.dart';
import '../network/api_client.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepository());
  sl.registerLazySingleton<AdminCourseRepository>(
    () => AdminCourseRepository(),
  );
  sl.registerLazySingleton<DeviceRepository>(() => DeviceRepository());

  // BLoCs
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));
  sl.registerFactory<DashboardBloc>(() => DashboardBloc(sl()));
  sl.registerFactory<CourseBloc>(() => CourseBloc(sl()));
  sl.registerFactory<CourseDetailsBloc>(() => CourseDetailsBloc(sl()));
  sl.registerFactory<DeviceBloc>(() => DeviceBloc(sl()));
}
