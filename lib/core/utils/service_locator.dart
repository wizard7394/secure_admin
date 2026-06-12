import 'package:get_it/get_it.dart';
import 'package:secure_admin/features/courses/data/course_repository.dart';
import 'package:secure_admin/features/courses/presentation/bloc/course_bloc.dart';
import 'package:secure_admin/features/courses/presentation/bloc/course_details_bloc.dart';
import 'package:secure_admin/features/dashboard/data/dashboard_repository.dart';
import 'package:secure_admin/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../network/api_client.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // BLoCs
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));

  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepository());

  sl.registerFactory<DashboardBloc>(() => DashboardBloc(sl()));

  sl.registerLazySingleton<AdminCourseRepository>(
    () => AdminCourseRepository(),
  );

  sl.registerFactory<CourseBloc>(() => CourseBloc(sl()));

  sl.registerFactory<CourseDetailsBloc>(() => CourseDetailsBloc(sl()));
}
