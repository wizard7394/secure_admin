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
      separatorBuilder: (_, _) => const Divider(color: Color(0xFF1A1A1A)),
      itemBuilder: (context, index) {
        final device = devices[index];
        return ListTile(
          title: Text(
            'Hardware ID: ${device['hardware_id']}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
            ),
          ),
          subtitle: Text(
            'User ID: ${device['user_id']} | Last Login: ${device['last_login']}',
            style: const TextStyle(color: Colors.white54),
          ),
          trailing: Icon(
            device['is_blocked'] == true ? Icons.block : Icons.check_circle,
            color: device['is_blocked'] == true
                ? Colors.red
                : const Color(0xFF00E676),
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
      separatorBuilder: (_, _) => const Divider(color: Color(0xFF1A1A1A)),
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
              backgroundColor: const Color(0xFF00E676),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              context.read<DeviceBloc>().add(
                UnblockDeviceEvent(item['hardware_id']),
              );
            },
            child: const Text(
              'UNBLOCK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
