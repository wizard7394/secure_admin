import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF141414),
          elevation: 0,
          leading: const BackButton(color: Color(0xFF00E676)),
          title: Text(
            'USER DOSSIER (ID: $userId)',
            style: const TextStyle(
              color: Color(0xFF00E676),
              letterSpacing: 4,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFF00E676),
            indicatorWeight: 3,
            labelColor: Color(0xFF00E676),
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'PROFILE'),
              Tab(text: 'DEVICES'),
              Tab(text: 'HEATMAP'),
              Tab(text: 'TRANSACTIONS'),
              Tab(text: 'LOGS & EVENTS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProfileTab(),
            _buildDevicesTab(),
            _buildHeatmapTab(),
            _buildTransactionsTab(),
            _buildLogsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'IDENTITY INFORMATION',
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
              _buildTextField('FULL NAME', 'AmirHosein Moallemi'),
              const SizedBox(width: 24),
              _buildTextField('MOBILE NUMBER', '09367013231'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildTextField('EMAIL ADDRESS', 'admin@nabegheha.com'),
              const SizedBox(width: 24),
              _buildTextField('ACCOUNT STATUS', 'ACTIVE', isReadOnly: true),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E676).withValues(alpha: 0.1),
              foregroundColor: const Color(0xFF00E676),
              side: const BorderSide(color: Color(0xFF00E676)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            ),
            child: const Text(
              'UPDATE PROFILE',
              style: TextStyle(letterSpacing: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String value, {
    bool isReadOnly = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            readOnly: isReadOnly,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF141414),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00E676)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesTab() {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        _buildDeviceRow(
          '1',
          'ROG STRIX Z790-F GAMING WIFI',
          'NO',
          'Active verified slot',
        ),
        _buildDeviceRow(
          '2',
          'ASUSTeK COMPUTER INC.',
          'YES',
          'Auto-blocked: Motherboard changed',
        ),
      ],
    );
  }

  Widget _buildDeviceRow(
    String id,
    String name,
    String isBlocked,
    String reason,
  ) {
    final blocked = isBlocked == 'YES';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              id,
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              blocked ? 'BLOCKED' : 'ACTIVE',
              style: TextStyle(
                color: blocked ? Colors.redAccent : const Color(0xFF00E676),
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(reason, style: const TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapTab() {
    return const Center(
      child: Text(
        'TELEMETRY & HEATMAP DATA WILL BE RENDERED HERE',
        style: TextStyle(color: Colors.white54, letterSpacing: 2),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        _buildTransactionRow(
          'TX-9921',
          '2026-06-23',
          'Hardware Reset Fee',
          '+50,000 IRT',
        ),
        _buildTransactionRow(
          'TX-8840',
          '2026-01-15',
          'Python Security Package',
          '+1,200,000 IRT',
        ),
      ],
    );
  }

  Widget _buildTransactionRow(
    String id,
    String date,
    String desc,
    String amount,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              id,
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: 'monospace',
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              date,
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: Text(desc, style: const TextStyle(color: Colors.white)),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF00E676),
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsTab() {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        const Text(
          'PLAYER CRASH LOGS',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildLogRow(
          '1',
          '2026-06-23 10:15',
          'Decryption failed. Invalid IV vector in memory block 0x4A.',
        ),
        _buildLogRow(
          '2',
          '2026-06-22 18:40',
          'MediaKit renderer crashed. Unsupported GPU driver detected.',
        ),
        const SizedBox(height: 48),
        const Text(
          'SYSTEM EVENT LOGS',
          style: TextStyle(
            color: Color(0xFF00E676),
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildLogRow(
          '3',
          '2026-06-23 09:00',
          'Payment received via WooCommerce. Slot automatically reset.',
        ),
        _buildLogRow(
          '4',
          '2026-06-20 12:00',
          'System auto-blocked due to unauthorized login attempt from new hardware.',
        ),
      ],
    );
  }

  Widget _buildLogRow(String id, String date, String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              id,
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: 'monospace',
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Text(
              date,
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
