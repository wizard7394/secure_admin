import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/service_locator.dart';
import '../bloc/device_bloc.dart';
import '../bloc/device_event.dart';
import '../bloc/device_state.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeviceBloc>()..add(FetchDevicesEvent()),
      child: const DevicesView(),
    );
  }
}

class DevicesView extends StatelessWidget {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'SECURITY & DEVICES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const TabBar(
            indicatorColor: Color(0xFF00E676),
            labelColor: Color(0xFF00E676),
            unselectedLabelColor: Colors.white54,
            dividerColor: Color(0xFF1A1A1A),
            tabs: [
              Tab(text: 'REGISTERED DEVICES'),
              Tab(text: 'BLACKLISTED HARDWARE'),
            ],
          ),
          Expanded(
            child: BlocBuilder<DeviceBloc, DeviceState>(
              builder: (context, state) {
                if (state is DeviceLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00E676)),
                  );
                } else if (state is DeviceError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                } else if (state is DeviceLoaded) {
                  return TabBarView(
                    children: [
                      _buildDevicesList(state.devices),
                      _buildBlacklist(context, state.blacklistedDevices),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList(List<dynamic> devices) {
    if (devices.isEmpty) {
      return const Center(
        child: Text(
          'No devices found',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(32),
      itemCount: devices.length,
      separatorBuilder: (_, __) =>
          const Divider(color: Color(0xFF1A1A1A), height: 32),
      itemBuilder: (context, index) {
        final device = devices[index];
        final loginDate = device['last_login'] != null
            ? device['last_login'].toString().split('T')[0]
            : 'Unknown';

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1A1A1A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mobile: ${device['mobile']}',
                    style: const TextStyle(
                      color: Color(0xFF00E676),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: device['is_blocked'] == true
                          ? const Color(0xFF141414)
                          : Colors.redAccent.withValues(alpha: 0.1),
                      foregroundColor: device['is_blocked'] == true
                          ? const Color(0xFF00E676)
                          : Colors.redAccent,
                      elevation: 0,
                      side: BorderSide(
                        color: device['is_blocked'] == true
                            ? const Color(0xFF00E676)
                            : Colors.redAccent,
                      ),
                    ),
                    onPressed: () {
                      // اینجا چون جدول Device هست، آیدی و وضعیت فیلد is_blocked رو میفرستیم
                      context.read<DeviceBloc>().add(
                        ToggleBlockEvent(
                          device['id'],
                          !(device['is_blocked'] == true),
                        ),
                      );
                    },
                    child: Text(
                      device['is_blocked'] == true ? 'UNBLOCK' : 'BLOCK DEVICE',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                device['system_specs'] ?? 'No specs captured',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'HWID: ${device['short_hash']}  |  Last Login: $loginDate',
                style: const TextStyle(
                  color: Colors.white38,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBlacklist(BuildContext context, List<dynamic> blacklists) {
    if (blacklists.isEmpty) {
      return const Center(
        child: Text(
          'No blacklisted devices',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(32),
      itemCount: blacklists.length,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFF1A1A1A)),
      itemBuilder: (context, index) {
        final item = blacklists[index];
        return ListTile(
          title: Text(
            'Hardware ID: ${item['hardware_id']}',
            style: const TextStyle(
              color: Colors.redAccent,
              fontFamily: 'monospace',
            ),
          ),
          subtitle: Text(
            'Reason: ${item['reason']}',
            style: const TextStyle(color: Colors.white54),
          ),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF141414),
              foregroundColor: const Color(0xFF00E676),
              elevation: 0,
              side: const BorderSide(color: Color(0xFF00E676)),
            ),
            onPressed: () {
              context.read<DeviceBloc>().add(
                UnblockDeviceEvent(item['hardware_id']),
              );
            },
            child: const Text(
              'UNBLOCK',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
