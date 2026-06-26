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
  // تزریق نمونه آپدیت شده ApiClient به رپازیتوری‌ها برای پردازش روت‌ها
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AdminCourseRepository>(
    () => AdminCourseRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<DeviceRepository>(() => DeviceRepository());

  // BLoCs
  // پاس دادن دقیق نمونه‌ها به کانستراکتورهای موقعیت‌محور و نام‌دار
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepository>()));
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(repository: sl<DashboardRepository>()),
  );
  sl.registerFactory<CourseBloc>(() => CourseBloc(sl<AdminCourseRepository>()));
  sl.registerFactory<CourseDetailsBloc>(
    () => CourseDetailsBloc(sl<AdminCourseRepository>()),
  );
  sl.registerFactory<DeviceBloc>(() => DeviceBloc(sl<DeviceRepository>()));
}
