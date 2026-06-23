import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockUsers = [
      {
        'id': '1',
        'number': '09367013231',
        'name': 'AmirHosein Moallemi',
        'email': 'admin@nabegheha.com',
        'active': true,
      },
      {
        'id': '2',
        'number': '09123456789',
        'name': 'John Doe',
        'email': 'john@example.com',
        'active': true,
      },
      {
        'id': '3',
        'number': '09198765432',
        'name': 'Jane Smith',
        'email': 'jane.smith@domain.com',
        'active': false,
      },
      {
        'id': '4',
        'number': '09021112233',
        'name': 'Alice Hacker',
        'email': 'alice@crypto.org',
        'active': true,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        title: const Text(
          'USER MANAGEMENT',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
              child: Row(
                children: const [
                  SizedBox(
                    width: 50,
                    child: Text(
                      'ID',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'NUMBER',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'FULL NAME',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'EMAIL',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'STATUS',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockUsers.length,
              itemBuilder: (context, index) {
                final user = mockUsers[index];
                final isActive = user['active'] as bool;

                return InkWell(
                  onTap: () => context.go('/users/${user['id']}'),
                  hoverColor: const Color(0xFF00E676).withValues(alpha: 0.05),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.02),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            user['id'].toString(),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontFamily: 'monospace',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            user['number'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            user['name'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            user['email'].toString(),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: isActive
                                    ? const Color(0xFF00E676)
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isActive ? 'ACTIVE' : 'BANNED',
                                style: TextStyle(
                                  color: isActive
                                      ? const Color(0xFF00E676)
                                      : Colors.redAccent,
                                  fontFamily: 'monospace',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.white24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
