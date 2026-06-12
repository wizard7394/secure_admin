import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/service_locator.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(FetchDashboardStats()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        title: const Text(
          'COMMAND CENTER',
          style: TextStyle(
            color: Color(0xFF00E676),
            letterSpacing: 4,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF00E676).withValues(alpha: 0.2),
            height: 1,
          ),
        ),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00E676),
                strokeWidth: 2,
              ),
            );
          } else if (state is DashboardError) {
            return Center(
              child: Text(
                'SYSTEM FAULT: ${state.message}',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'monospace',
                ),
              ),
            );
          } else if (state is DashboardLoaded) {
            final stats = state.stats;
            final recentTransactions =
                stats['recent_transactions'] as List<dynamic>? ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildStatCard(
                        'TOTAL USERS',
                        stats['total_users']?.toString() ?? '0',
                        Icons.people_outline,
                      ),
                      const SizedBox(width: 24),
                      _buildStatCard(
                        'ACTIVE LICENSES',
                        stats['total_licenses']?.toString() ?? '0',
                        Icons.vpn_key_outlined,
                      ),
                      const SizedBox(width: 24),
                      _buildStatCard(
                        'COURSES',
                        stats['total_courses']?.toString() ?? '0',
                        Icons.library_books_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'RECENT TRANSACTIONS LOG',
                    style: TextStyle(
                      color: Color(0xFF00E676),
                      fontSize: 14,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = recentTransactions[index];
                      final isSuccess = tx['status'] == 'success';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414),
                          border: Border(
                            left: BorderSide(
                              color: isSuccess
                                  ? const Color(0xFF00E676)
                                  : Colors.redAccent,
                              width: 4,
                            ),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          title: Text(
                            tx['user'] ?? 'UNKNOWN_IDENTITY',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            tx['course'] ?? 'UNKNOWN_RESOURCE',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Text(
                            '${tx['amount']} IRT',
                            style: TextStyle(
                              color: isSuccess
                                  ? const Color(0xFF00E676)
                                  : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFF00E676).withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
                Icon(icon, color: const Color(0xFF00E676), size: 20),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
