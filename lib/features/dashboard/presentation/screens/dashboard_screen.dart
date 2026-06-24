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
      create: (context) => sl<DashboardBloc>()..add(StartLiveUpdate()),
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
            fontSize: 16,
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
              child: CircularProgressIndicator(color: Color(0xFF00E676)),
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
            final server = state.stats['server'] ?? {};
            final metrics = state.stats['metrics'] ?? {};

            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SERVER RESOURCES',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildSimpleCard(
                        'CPU USAGE',
                        server['cpu_usage'] ?? '0%',
                        Icons.memory,
                      ),
                      const SizedBox(width: 24),
                      _buildSimpleCard(
                        'RAM USAGE',
                        server['ram_usage'] ?? '0GB',
                        Icons.developer_board,
                      ),
                      const SizedBox(width: 24),
                      _buildSimpleCard(
                        'STORAGE',
                        server['storage'] ?? '0GB',
                        Icons.storage,
                      ),
                      const SizedBox(width: 24),
                      _buildSimpleCard(
                        'SYSTEM OS',
                        server['os'] ?? 'Unknown',
                        Icons.terminal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'PLATFORM METRICS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildSimpleCard(
                        'TOTAL USERS',
                        metrics['total_users'] ?? '0',
                        Icons.people_outline,
                        highlight: true,
                      ),
                      const SizedBox(width: 24),
                      _buildSimpleCard(
                        'ONLINE USERS',
                        metrics['online_users'] ?? '0',
                        Icons.circle,
                        highlight: true,
                        isLive: true,
                      ),
                      const SizedBox(width: 24),
                      _buildSimpleCard(
                        'BLOCKED DEVICES',
                        metrics['blocked_devices'] ?? '0',
                        Icons.block,
                        customColor: Colors.orangeAccent,
                      ),
                      const SizedBox(width: 24),
                      _buildSimpleCard(
                        'FAILED LOGINS',
                        metrics['failed_logins'] ?? '0',
                        Icons.security_outlined,
                        customColor: Colors.redAccent,
                      ),
                    ],
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

  Widget _buildSimpleCard(
    String title,
    String value,
    IconData icon, {
    bool highlight = false,
    bool isLive = false,
    Color? customColor,
  }) {
    final mainColor =
        customColor ?? (highlight ? const Color(0xFF00E676) : Colors.white70);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
                    letterSpacing: 1.5,
                  ),
                ),
                Icon(icon, color: mainColor, size: isLive ? 12 : 18),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              value,
              style: TextStyle(
                color: highlight ? Colors.white : mainColor,
                fontSize: 28,
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
