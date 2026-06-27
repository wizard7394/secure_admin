import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/service_locator.dart';
import '../bloc/course_details_bloc.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CourseDetailsBloc>()..add(FetchCourseDetails(int.parse(courseId))),
      child: _CourseDetailsView(courseId: courseId),
    );
  }
}

class _CourseDetailsView extends StatelessWidget {
  final String courseId;

  const _CourseDetailsView({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        leading: const BackButton(color: Color(0xFF00E676)),
        title: BlocBuilder<CourseDetailsBloc, CourseDetailsState>(
          builder: (context, state) {
            String titleStr = 'COURSE CONTENT (ID: $courseId)';
            if (state is CourseDetailsLoaded) {
              final courseTitle = state.courseData['title'] ?? 'UNKNOWN';
              titleStr = '$courseTitle (ID: $courseId)';
            }
            return Text(
              titleStr.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF00E676),
                letterSpacing: 4,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF00E676).withValues(alpha: 0.2),
            height: 1,
          ),
        ),
      ),
      body: BlocBuilder<CourseDetailsBloc, CourseDetailsState>(
        builder: (context, state) {
          if (state is CourseDetailsLoading || state is CourseDetailsInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00E676)),
            );
          } else if (state is CourseDetailsError) {
            return Center(
              child: Text(
                'CORE ERROR: ${state.message}',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'monospace',
                ),
              ),
            );
          } else if (state is CourseDetailsLoaded) {
            final treeData = state.courseData['tree'] as List<dynamic>? ?? [];

            return SingleChildScrollView(
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
                        onPressed: () => _showNodeDialog(context, null, null),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('ADD LESSON / FOLDER'),
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
                  if (treeData.isEmpty)
                    const Text(
                      'NO LESSONS YET. ADD A NEW LESSON TO THIS PACKAGE.',
                      style: TextStyle(color: Colors.white38, letterSpacing: 1),
                    )
                  else
                    ...treeData.asMap().entries.map((entry) {
                      final indexStr = (entry.key + 1).toString().padLeft(
                        2,
                        '0',
                      );
                      return _buildNodeItem(
                        context,
                        entry.value,
                        indexStr,
                        0.0,
                      );
                    }),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNodeItem(
    BuildContext context,
    dynamic node,
    String number,
    double indent,
  ) {
    final bool isFolder = node['item_type'] == 'folder';
    final String title = node['title'] ?? 'UNTITLED';
    final String duration = node['duration']?.toString() ?? '--:--';
    final bool hasVault = node['vault'] != null;
    final List<dynamic> children = node['children'] ?? [];
    final int nodeId = node['id'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: indent, bottom: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              if (isFolder)
                const Icon(
                  Icons.folder_open_outlined,
                  color: Color(0xFF00E676),
                  size: 24,
                )
              else
                Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(width: isFolder ? 16 : 24),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              if (!isFolder) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: !hasVault
                        ? const Color(0xFF00E676).withValues(alpha: 0.1)
                        : Colors.orangeAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: !hasVault
                          ? const Color(0xFF00E676).withValues(alpha: 0.5)
                          : Colors.orangeAccent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    !hasVault ? 'FREE' : 'SECURED',
                    style: TextStyle(
                      color: !hasVault
                          ? const Color(0xFF00E676)
                          : Colors.orangeAccent,
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
              ],
              const SizedBox(width: 24),
              if (isFolder)
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFF00E676),
                    size: 20,
                  ),
                  onPressed: () => _showNodeDialog(context, null, nodeId),
                  tooltip: 'Add child',
                  hoverColor: const Color(0xFF00E676).withValues(alpha: 0.1),
                ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white54,
                  size: 20,
                ),
                onPressed: () => _showNodeDialog(context, node, null),
                tooltip: 'Edit',
                hoverColor: Colors.white10,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: () => _confirmDeleteNode(context, nodeId),
                tooltip: 'Delete',
                hoverColor: Colors.redAccent.withValues(alpha: 0.1),
              ),
            ],
          ),
        ),
        if (children.isNotEmpty)
          ...children.asMap().entries.map((childEntry) {
            final childIndexStr = '$number.${childEntry.key + 1}';
            return _buildNodeItem(
              context,
              childEntry.value,
              childIndexStr,
              indent + 32.0,
            );
          }),
      ],
    );
  }

  void _showNodeDialog(
    BuildContext context,
    dynamic existingNode,
    int? forceParentId,
  ) {
    final isEditing = existingNode != null;
    final titleCtrl = TextEditingController(
      text: isEditing ? existingNode['title'] : '',
    );
    final durationCtrl = TextEditingController(
      text: isEditing ? existingNode['duration']?.toString() : '',
    );
    final sortOrderCtrl = TextEditingController(
      text: isEditing ? existingNode['sort_order']?.toString() : '0',
    );
    String selectedType = isEditing ? existingNode['item_type'] : 'video';
    final int? parentId = isEditing ? existingNode['parent_id'] : forceParentId;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF141414),
              title: Text(
                isEditing ? 'EDIT NODE' : 'CREATE NEW NODE',
                style: const TextStyle(
                  color: Color(0xFF00E676),
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
              ),
              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isEditing) ...[
                      const Text(
                        'NODE TYPE',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: selectedType,
                        dropdownColor: const Color(0xFF1A1A1A),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF0A0A0A),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00E676)),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'video',
                            child: Text('VIDEO LESSON'),
                          ),
                          DropdownMenuItem(
                            value: 'folder',
                            child: Text('FOLDER / SECTION'),
                          ),
                        ],
                        onChanged: (val) => setState(() => selectedType = val!),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildDialogField('TITLE', titleCtrl),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDialogField(
                            'SORT ORDER',
                            sortOrderCtrl,
                            isNumber: true,
                          ),
                        ),
                        if (selectedType == 'video') ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDialogField(
                              'DURATION (MIN)',
                              durationCtrl,
                              isNumber: true,
                            ),
                          ),
                        ],
                      ],
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
                    if (titleCtrl.text.isEmpty) return;

                    final parsedCourseId = int.parse(courseId);
                    final parsedSort = int.tryParse(sortOrderCtrl.text) ?? 0;
                    final parsedDuration = int.tryParse(durationCtrl.text);

                    if (isEditing) {
                      context.read<CourseDetailsBloc>().add(
                        UpdateNodeEvent(
                          parsedCourseId,
                          existingNode['id'],
                          titleCtrl.text,
                          parsedSort,
                          duration: selectedType == 'video'
                              ? parsedDuration
                              : null,
                        ),
                      );
                    } else {
                      context.read<CourseDetailsBloc>().add(
                        CreateNodeEvent(
                          parsedCourseId,
                          parentId,
                          selectedType,
                          titleCtrl.text,
                          parsedSort,
                          duration: selectedType == 'video'
                              ? parsedDuration
                              : null,
                        ),
                      );
                    }
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: Colors.black,
                  ),
                  child: Text(isEditing ? 'UPDATE' : 'SAVE NODE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteNode(BuildContext context, int nodeId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text(
          'DANGER: DELETE NODE',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this item? If it is a folder, all child items will be lost.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ABORT', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CourseDetailsBloc>().add(
                DeleteNodeEvent(int.parse(courseId), nodeId),
              );
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
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
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0A0A0A),
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
