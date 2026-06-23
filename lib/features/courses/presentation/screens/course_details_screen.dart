import 'package:flutter/material.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        leading: BackButton(color: const Color(0xFF00E676)),
        title: Text(
          'COURSE CONTENT (ID: $courseId)',
          style: const TextStyle(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'LESSONS MANAGEMENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('ADD LESSON'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF00E676,
                    ).withValues(alpha: 0.1),
                    foregroundColor: const Color(0xFF00E676),
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFF00E676)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLessonItem(
              '01',
              'Introduction to Architecture',
              '12:45',
              true,
            ),
            _buildLessonItem('02', 'Setting up the Environment', '08:20', true),
            _buildLessonItem(
              '03',
              'Core Memory Decryption Logic',
              '24:15',
              false,
            ),
            _buildLessonItem('04', 'Handling API Security', '18:30', false),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(
    String number,
    String title,
    String duration,
    bool isFree,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white54,
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isFree
                  ? const Color(0xFF00E676).withValues(alpha: 0.1)
                  : Colors.orangeAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isFree
                    ? const Color(0xFF00E676).withValues(alpha: 0.5)
                    : Colors.orangeAccent.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              isFree ? 'FREE' : 'SECURED',
              style: TextStyle(
                color: isFree ? const Color(0xFF00E676) : Colors.orangeAccent,
                fontSize: 10,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Text(
            duration,
            style: const TextStyle(
              color: Colors.white54,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 24),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white54,
              size: 20,
            ),
            onPressed: () {},
            hoverColor: Colors.white10,
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 20,
            ),
            onPressed: () {},
            hoverColor: Colors.redAccent.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}
