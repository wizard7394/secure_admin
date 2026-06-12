import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_admin/features/courses/presentation/screens/course_details_screen.dart';
import 'package:secure_admin/features/courses/presentation/screens/courses_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import 'main_layout.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/login'),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/courses',
          builder: (context, state) => const CoursesScreen(),
        ),
        GoRoute(
          path: '/courses/:id',
          builder: (context, state) {
            final courseId = state.pathParameters['id']!;
            return CourseDetailsScreen(courseId: int.parse(courseId));
          },
        ),
      ],
    ),
  ],
);
