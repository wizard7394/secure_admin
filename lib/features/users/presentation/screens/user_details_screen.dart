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
            _buildDevicesTab(context),
            _buildHeatmapTab(context),
            _buildTransactionsTab(context),
            _buildLogsTab(context),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACCOUNT STATUS',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: 'ENABLE',
                      dropdownColor: const Color(0xFF1A1A1A),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
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
                      items: ['ENABLE', 'DISABLE'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: value == 'ENABLE'
                                  ? const Color(0xFF00E676)
                                  : Colors.redAccent,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {},
                    ),
                  ],
                ),
              ),
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

  Widget _buildTextField(String label, String value) {
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

  Widget _buildHeaderContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF00E676).withValues(alpha: 0.5),
            width: 2,
          ),
        ),
      ),
      child: Row(children: children),
    );
  }

  Widget _buildDevicesTab(BuildContext context) {
    const headerStyle = TextStyle(
      color: Colors.white54,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _buildHeaderContainer(
            children: [
              const SizedBox(width: 50, child: Text('ID', style: headerStyle)),
              const Expanded(
                flex: 2,
                child: Text('DEVICE NAME', style: headerStyle),
              ),
              const SizedBox(
                width: 150,
                child: Text('STATUS', style: headerStyle),
              ),
              const Expanded(
                flex: 2,
                child: Text('REASON', style: headerStyle),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDeviceRow(
                  context,
                  '1',
                  'ROG STRIX Z790-F GAMING WIFI',
                  'ENABLE',
                  'Active verified slot',
                  true,
                ),
                _buildDeviceRow(
                  context,
                  '2',
                  'ASUSTeK COMPUTER INC.',
                  'DISABLE',
                  'Auto-blocked: Motherboard changed',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceRow(
    BuildContext context,
    String id,
    String name,
    String status,
    String reason,
    bool isActive,
  ) {
    return InkWell(
      onTap: () => _showDeviceDetailsDialog(context, name),
      hoverColor: const Color(0xFF00E676).withValues(alpha: 0.05),
      child: Container(
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
                status,
                style: TextStyle(
                  color: isActive ? const Color(0xFF00E676) : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                reason,
                style: const TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeviceDetailsDialog(BuildContext context, String deviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: Text(
          'HARDWARE SPECIFICATIONS: $deviceName',
          style: const TextStyle(
            color: Color(0xFF00E676),
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        content: const SizedBox(
          width: 500,
          child: Text(
            "CPU: Intel Core i7-13700K 16-Core\nGPU: NVIDIA GeForce RTX 4090 24GB\nRAM: 64GB DDR5 6000MHz\nOS: Windows 11 Pro Build 22621\nMotherboard UUID: 4C4C4544-004B-4A10-8032-B8C04F505332\nCapture Hardware: Clean (No Capture Cards)",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              height: 1.8,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapTab(BuildContext context) {
    const headerStyle = TextStyle(
      color: Colors.white54,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _buildHeaderContainer(
            children: [
              const SizedBox(width: 50, child: Text('ID', style: headerStyle)),
              const Expanded(
                flex: 3,
                child: Text('COURSE NAME', style: headerStyle),
              ),
              const Expanded(
                flex: 2,
                child: Text('TOTAL PROGRESS', style: headerStyle),
              ),
              const SizedBox(
                width: 150,
                child: Text('TOTAL VIDEOS', style: headerStyle),
              ),
              const SizedBox(
                width: 150,
                child: Text('STATUS', style: headerStyle),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildHeatmapCourseRow(
                  context,
                  '1',
                  'Python Security Masterclass',
                  0.65,
                  '300',
                  'IN PROGRESS',
                ),
                _buildHeatmapCourseRow(
                  context,
                  '2',
                  'Linux LPIC-1 Administration',
                  1.0,
                  '120',
                  'COMPLETED',
                ),
                _buildHeatmapCourseRow(
                  context,
                  '3',
                  'Flutter Advanced Architecture',
                  0.0,
                  '85',
                  'UNWATCHED',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapCourseRow(
    BuildContext context,
    String id,
    String courseName,
    double progress,
    String totalVideos,
    String status,
  ) {
    final bool isCompleted = progress == 1.0;
    final bool isUnwatched = progress == 0.0;
    final Color statusColor = isCompleted
        ? const Color(0xFF00E676)
        : (isUnwatched ? Colors.white24 : Colors.orangeAccent);

    return InkWell(
      onTap: () => _showMatrixHeatmapDialog(context, courseName, totalVideos),
      hoverColor: const Color(0xFF00E676).withValues(alpha: 0.05),
      child: Container(
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
              flex: 3,
              child: Text(
                courseName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        color: statusColor,
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 45,
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          color: statusColor,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                '$totalVideos Videos',
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMatrixHeatmapDialog(
    BuildContext context,
    String courseName,
    String totalVideos,
  ) {
    final int count = int.parse(totalVideos);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D0D0D),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'VISUAL HEATMAP MATRIX: $courseName',
              style: const TextStyle(
                color: Color(0xFF00E676),
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '$totalVideos Videos Total',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 750,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildLegendDot(const Color(0xFF00E676), 'Completed'),
                  const SizedBox(width: 16),
                  _buildLegendDot(
                    Colors.orangeAccent,
                    'Half Watched (Drop-off)',
                  ),
                  const SizedBox(width: 16),
                  _buildLegendDot(Colors.white10, 'Unwatched'),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(count, (index) {
                      Color dotColor = Colors.white10;
                      double mockProg = 0.0;

                      if (index < count * 0.4) {
                        dotColor = const Color(0xFF00E676);
                        mockProg = 1.0;
                      } else if (index < count * 0.65) {
                        dotColor = Colors.orangeAccent;
                        mockProg = 0.45;
                      }

                      return Tooltip(
                        message:
                            'Video #${index + 1} - Progress: ${(mockProg * 100).toInt()}%',
                        preferBelow: false,
                        child: InkWell(
                          onTap: () => _showTelemetryDetailsDialog(
                            context,
                            'Video #${index + 1}',
                            mockProg,
                          ),
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: dotColor,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.02),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CLOSE PANEL',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  void _showTelemetryDetailsDialog(
    BuildContext context,
    String videoTitle,
    double progress,
  ) {
    final status = progress == 1.0
        ? 'COMPLETED'
        : (progress == 0.0 ? 'UNWATCHED' : 'IN PROGRESS');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: Text(
          'SPECIFIC TELEMETRY: $videoTitle',
          style: const TextStyle(
            color: Color(0xFF00E676),
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        content: SizedBox(
          width: 450,
          child: Text(
            "Overall Status: $status\nTotal Playtime: 24m 12s\nAverage Speed: 1.50x\nSeek Jumps (Skipped): 3 times\nPause Count: 1 time\nDrop-off Point: ${progress == 1.0 ? 'End of Video' : '11m 05s'}\nLast IP Address: 94.101.182.3\nTelemetry Result: Verified Genuine View",
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              height: 1.8,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BACK', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab(BuildContext context) {
    const headerStyle = TextStyle(
      color: Colors.white54,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _buildHeaderContainer(
            children: [
              const SizedBox(width: 100, child: Text('ID', style: headerStyle)),
              const SizedBox(
                width: 150,
                child: Text('DATE', style: headerStyle),
              ),
              const Expanded(child: Text('DESCRIPTION', style: headerStyle)),
              const SizedBox(
                width: 150,
                child: Text('AMOUNT', style: headerStyle),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildTransactionRow(
                  context,
                  'TX-9921',
                  '2026-06-23',
                  'Hardware Reset Fee',
                  '+50,000 IRT',
                  true,
                ),
                _buildTransactionRow(
                  context,
                  'TX-8840',
                  '2026-01-15',
                  'Python Security Package',
                  '+1,200,000 IRT',
                  true,
                ),
                _buildTransactionRow(
                  context,
                  'TX-8841',
                  '2026-01-16',
                  'Linux LPIC-1 (Failed)',
                  '0 IRT',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(
    BuildContext context,
    String id,
    String date,
    String desc,
    String amount,
    bool isSuccess,
  ) {
    return InkWell(
      onTap: () => _showTransactionDetailsDialog(context, id),
      hoverColor: const Color(0xFF00E676).withValues(alpha: 0.05),
      child: Container(
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
              width: 100,
              child: Text(
                id.replaceAll('TX-', ''),
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
            SizedBox(
              width: 150,
              child: Text(
                amount,
                style: TextStyle(
                  color: isSuccess ? const Color(0xFF00E676) : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetailsDialog(BuildContext context, String txId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: Text(
          'TRANSACTION DETAILS: $txId',
          style: const TextStyle(
            color: Color(0xFF00E676),
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        content: const SizedBox(
          width: 500,
          child: Text(
            "Gateway: ZarinPal\nRef ID: 0000000000000000000000000000458921\nCard PAN: 5022-29**-****-1234\nTimestamp: 2026-06-23 14:35:22 UTC\nStatus: SUCCESS - Verified by callback",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              height: 1.8,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsTab(BuildContext context) {
    const headerStyle = TextStyle(
      color: Colors.white54,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _buildHeaderContainer(
            children: [
              const SizedBox(width: 50, child: Text('ID', style: headerStyle)),
              const SizedBox(
                width: 180,
                child: Text('DATE', style: headerStyle),
              ),
              const Expanded(child: Text('MESSAGE', style: headerStyle)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
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
                  context,
                  '1',
                  '2026-06-23 10:15',
                  'Decryption failed. Invalid IV vector in memory block 0x4A.',
                  true,
                ),
                _buildLogRow(
                  context,
                  '2',
                  '2026-06-22 18:40',
                  'MediaKit renderer crashed. Unsupported GPU driver detected.',
                  true,
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
                  context,
                  '3',
                  '2026-06-23 09:00',
                  'Payment received via WooCommerce. Slot automatically reset.',
                  false,
                ),
                _buildLogRow(
                  context,
                  '4',
                  '2026-06-20 12:00',
                  'System auto-blocked due to unauthorized login attempt from new hardware.',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogRow(
    BuildContext context,
    String id,
    String date,
    String message,
    bool isCrash,
  ) {
    return InkWell(
      onTap: () => _showLogDetailsDialog(context, id, message, isCrash),
      hoverColor: const Color(0xFF00E676).withValues(alpha: 0.05),
      child: Container(
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
              width: 180,
              child: Text(
                date,
                style: const TextStyle(
                  color: Colors.white54,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: isCrash
                      ? Colors.redAccent.withValues(alpha: 0.8)
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogDetailsDialog(
    BuildContext context,
    String logId,
    String shortMsg,
    bool isCrash,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: Text(
          'LOG TRACE ID: $logId',
          style: TextStyle(
            color: isCrash ? Colors.redAccent : const Color(0xFF00E676),
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        content: SizedBox(
          width: 700,
          child: SingleChildScrollView(
            child: Text(
              isCrash
                  ? "FATAL ERROR OCCURRED:\n$shortMsg\n\n--- STACK TRACE ---\n[0x00A1F] libcrypto.so: EVP_DecryptUpdate + 0x42\n[0x00B22] secure_player_core: _decrypt_chunk + 0x18A\n[0x00C33] media_kit_video: render_frame + 0x9F\n\nDump saved to: /var/logs/crash_$logId.dmp"
                  : "EVENT TRIGGERED:\n$shortMsg\n\n--- METADATA ---\nAction: AUTO_BLOCK_MISMATCH\nTrigger: Webhook / Web API\nPayload Hash: 8f4e2d1a...\nStatus: Committed to DB successfully",
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }
}
