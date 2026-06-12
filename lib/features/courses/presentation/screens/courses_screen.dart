import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/service_locator.dart';
import '../bloc/course_bloc.dart';

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

  void _showAddCourseDialog(BuildContext context, CourseBloc bloc) {
    final titleController = TextEditingController();
    final wmTextController = TextEditingController();
    final wmColorController = TextEditingController(text: '#FFFFFF');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: const Color(0xFF00E676).withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        title: const Text(
          'CREATE NEW COURSE',
          style: TextStyle(
            color: Color(0xFF00E676),
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'COURSE TITLE',
                labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            TextField(
              controller: wmTextController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'WATERMARK TEXT',
                labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            TextField(
              controller: wmColorController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'WATERMARK COLOR HEX',
                labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              bloc.add(
                CreateCourseEvent(
                  titleController.text,
                  wmTextController.text,
                  wmColorController.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text(
              'EXECUTE',
              style: TextStyle(color: Color(0xFF00E676)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseBloc>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        title: const Text(
          'COURSES MANAGEMENT',
          style: TextStyle(
            color: Color(0xFF00E676),
            letterSpacing: 2,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF00E676)),
            onPressed: () => _showAddCourseDialog(context, bloc),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF00E676).withValues(alpha: 0.2),
            height: 1,
          ),
        ),
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
                'SYSTEM FAULT: ${state.message}',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'monospace',
                ),
              ),
            );
          } else if (state is CourseLoaded) {
            final courses = state.courses;
            return GridView.builder(
              padding: const EdgeInsets.all(32),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.8,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return InkWell(
                  onTap: () => context.go('/courses/${course['id']}'),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      border: Border.all(
                        color: const Color(0xFF00E676).withValues(alpha: 0.1),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                course['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () =>
                                  bloc.add(DeleteCourseEvent(course['id'])),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'COURSE_ID: ${course['id']}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
