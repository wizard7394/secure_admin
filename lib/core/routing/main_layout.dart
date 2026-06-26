import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/service_locator.dart';
import '../../features/auth/data/auth_repository.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Row(
        children: [
          Container(
            width: 260,
            color: const Color(0xFF141414),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'DRM\nCOMMAND CENTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Divider(
                  color: const Color(0xFF00E676).withValues(alpha: 0.2),
                  height: 1,
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  title: 'DASHBOARD',
                  icon: Icons.dashboard_outlined,
                  route: '/dashboard',
                  isActive: currentPath.startsWith('/dashboard'),
                ),
                _buildMenuItem(
                  context,
                  title: 'COURSES',
                  icon: Icons.library_books_outlined,
                  route: '/courses',
                  isActive: currentPath.startsWith('/courses'),
                ),
                _buildMenuItem(
                  context,
                  title: 'USERS',
                  icon: Icons.people_outline,
                  route: '/users',
                  isActive: currentPath.startsWith('/users'),
                ),
                _buildMenuItem(
                  context,
                  title: 'NOTIFICATION CENTER',
                  icon: Icons.notifications_active_outlined,
                  route: '/notifications',
                  isActive: currentPath.startsWith('/notifications'),
                ),
                const Spacer(),
                _buildLogoutItem(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
          Container(
            width: 1,
            color: const Color(0xFF00E676).withValues(alpha: 0.2),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    required bool isActive,
  }) {
    final color = isActive ? const Color(0xFF00E676) : Colors.white54;

    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isActive ? const Color(0xFF00E676) : Colors.transparent,
              width: 4,
            ),
          ),
          color: isActive
              ? const Color(0xFF00E676).withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 13,
                letterSpacing: 1.5,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return InkWell(
      onTap: () async {
        await sl<AuthRepository>().logout();
        if (context.mounted) {
          context.go('/login');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 20),
            SizedBox(width: 16),
            Text(
              'LOGOUT',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 13,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
