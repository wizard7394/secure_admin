import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/service_locator.dart';
import '../bloc/course_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/course_repository.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CourseBloc>()..add(FetchCourses()),
      child: const _CoursesView(),
    );
  }
}

class _CoursesView extends StatelessWidget {
  const _CoursesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        title: const Text(
          'COURSE MANAGEMENT',
          style: TextStyle(
            color: Color(0xFF00E676),
            letterSpacing: 4,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFF00E676)),
            tooltip: 'EXPORT VAULT DATA',
            onPressed: () => _exportVault(context),
          ),
          IconButton(
            icon: const Icon(Icons.upload, color: Colors.orangeAccent),
            tooltip: 'IMPORT VAULT DATA',
            onPressed: () => _importVault(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 32.0, left: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showCreateCourseDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text(
                'NEW PACKAGE',
                style: TextStyle(letterSpacing: 1),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676).withValues(alpha: 0.1),
                foregroundColor: const Color(0xFF00E676),
                side: const BorderSide(color: Color(0xFF00E676)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading || state is CourseInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00E676)),
            );
          } else if (state is CourseError) {
            return Center(
              child: Text(
                'CORE ERROR: ${state.message}',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'monospace',
                ),
              ),
            );
          } else if (state is CourseLoaded) {
            if (state.courses.isEmpty) {
              return const Center(
                child: Text(
                  'NO ACTIVE COURSES FOUND IN DATABASE',
                  style: TextStyle(color: Colors.white38, letterSpacing: 2),
                ),
              );
            }

            return Column(
              children: [
                _buildHeaderRow(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 8,
                    ),
                    itemCount: state.courses.length,
                    itemBuilder: (context, index) {
                      final course = state.courses[index];
                      return _buildCourseCard(context, course);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _exportVault(BuildContext context) async {
    try {
      final repo = sl<AdminCourseRepository>();
      final data = await repo.exportVault();
      final jsonStr = jsonEncode(data);
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF141414),
          title: const Text(
            'VAULT EXPORT',
            style: TextStyle(color: Color(0xFF00E676)),
          ),
          content: SizedBox(
            width: 500,
            child: TextField(
              controller: TextEditingController(text: jsonStr),
              maxLines: 10,
              readOnly: true,
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: 'monospace',
                fontSize: 10,
              ),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.black,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'CLOSE',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonStr));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('COPIED TO CLIPBOARD!')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('COPY JSON'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ERROR: $e')));
    }
  }

  void _importVault(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text(
          'VAULT IMPORT',
          style: TextStyle(color: Colors.orangeAccent),
        ),
        content: SizedBox(
          width: 500,
          child: TextField(
            controller: ctrl,
            maxLines: 10,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 10,
            ),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.black,
              hintText: 'Paste JSON here...',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              try {
                final data = jsonDecode(ctrl.text);
                await sl<AdminCourseRepository>().importVault(data);
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                context.read<CourseBloc>().add(FetchCourses());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('IMPORT SUCCESSFUL!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('ERROR: $e')));
              }
            },
            child: const Text('IMPORT & OVERWRITE'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    const headerStyle = TextStyle(
      color: Colors.white54,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
      fontSize: 12,
    );
    return Container(
      margin: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF00E676).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
      ),
      child: const Row(
        children: [
          SizedBox(width: 60, child: Text('ID', style: headerStyle)),
          Expanded(flex: 3, child: Text('COURSE TITLE', style: headerStyle)),
          Expanded(flex: 2, child: Text('TOTAL VIDEOS', style: headerStyle)),
          Expanded(
            flex: 2,
            child: Text('ENROLLED STUDENTS', style: headerStyle),
          ),
          SizedBox(width: 120, child: Text('STATUS', style: headerStyle)),
          SizedBox(
            width: 100,
            child: Text(
              'ACTIONS',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, dynamic course) {
    final bool isActive = course['is_active'] ?? true;
    final int courseId = course['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/courses/$courseId'),
          borderRadius: BorderRadius.circular(4),
          hoverColor: Colors.white.withValues(alpha: 0.02),
          child: Ink(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    courseId.toString(),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    course['title'] ?? 'Unknown Course',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${course['total_videos'] ?? 0} Chapters',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${course['total_students'] ?? 0} Users',
                    style: const TextStyle(
                      color: Color(0xFF00E676),
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    isActive ? 'ACTIVE' : 'DISABLED',
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFF00E676)
                          : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        onPressed: () =>
                            _confirmDeleteCourse(context, courseId),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateCourseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final watermarkTextController = TextEditingController();
    final watermarkColorController = TextEditingController(text: '#FF0000');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text(
          'CREATE NEW SECURE PACKAGE',
          style: TextStyle(
            color: Color(0xFF00E676),
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField('COURSE TITLE', titleController),
              const SizedBox(height: 16),
              _buildDialogField(
                'DYNAMIC WATERMARK TEXT',
                watermarkTextController,
              ),
              const SizedBox(height: 16),
              _buildDialogField(
                'WATERMARK COLOR (HEX)',
                watermarkColorController,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                context.read<CourseBloc>().add(
                  CreateCourseEvent(
                    titleController.text,
                    watermarkTextController.text,
                    watermarkColorController.text,
                  ),
                );
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E676),
              foregroundColor: Colors.black,
            ),
            child: const Text('SAVE PACKAGE'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCourse(BuildContext context, int courseId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text(
          'DANGER: PERMANENT DELETION',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
        content: const Text(
          'Are you completely sure you want to destroy this course package? All associated nodes and licenses will be purged.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ABORT', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CourseBloc>().add(DeleteCourseEvent(courseId));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('DELETE CORES'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0A0A0A),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00E676)),
            ),
          ),
        ),
      ],
    );
  }
}
