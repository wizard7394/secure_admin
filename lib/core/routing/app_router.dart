import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_layout.dart';
import '../../core/utils/service_locator.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/courses/presentation/screens/courses_screen.dart';
import '../../features/courses/presentation/screens/course_details_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../../features/users/presentation/screens/user_details_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  redirect: (context, state) async {
    final isAuthenticated = await sl<AuthRepository>().isAuthenticated();
    final isGoingToLogin = state.uri.path == '/login';

    if (!isAuthenticated && !isGoingToLogin) {
      return '/login';
    }

    if (isAuthenticated && isGoingToLogin) {
      return '/dashboard';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
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
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final courseId = state.pathParameters['id']!;
                return CourseDetailsScreen(courseId: courseId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const UsersScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final userId = state.pathParameters['id']!;
                return UserDetailsScreen(userId: userId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const Scaffold(
            backgroundColor: Color(0xFF0A0A0A),
            body: Center(
              child: Text(
                'NOTIFICATION CENTER COMING SOON',
                style: TextStyle(color: Colors.white54, letterSpacing: 2),
              ),
            ),
          ),
        ),
      ],
    ),
  ],
);
