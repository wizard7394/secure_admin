import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/service_locator.dart';
import '../bloc/course_details_bloc.dart';
import '../../data/course_repository.dart';

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

            return Padding(
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
                    Expanded(
                      child: _ReorderableNodeTree(
                        nodes: treeData,
                        courseId: courseId,
                        onEdit: (node) => _showNodeDialog(context, node, null),
                        onDelete: (id) => _confirmDeleteNode(context, id),
                        onAddChild: (parentId) =>
                            _showNodeDialog(context, null, parentId),
                        isRoot: true,
                      ),
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

  void _showNodeDialog(
    BuildContext context,
    dynamic existingNode,
    int? forceParentId,
  ) {
    final bloc = context.read<CourseDetailsBloc>();

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
                      bloc.add(
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
                      bloc.add(
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
    final bloc = context.read<CourseDetailsBloc>();
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
              bloc.add(DeleteNodeEvent(int.parse(courseId), nodeId));
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

class _ReorderableNodeTree extends StatefulWidget {
  final List<dynamic> nodes;
  final String courseId;
  final Function(dynamic) onEdit;
  final Function(int) onDelete;
  final Function(int) onAddChild;
  final bool isRoot;

  const _ReorderableNodeTree({
    required this.nodes,
    required this.courseId,
    required this.onEdit,
    required this.onDelete,
    required this.onAddChild,
    this.isRoot = false,
  });

  @override
  State<_ReorderableNodeTree> createState() => _ReorderableNodeTreeState();
}

class _ReorderableNodeTreeState extends State<_ReorderableNodeTree> {
  late List<dynamic> _localNodes;
  final Set<int> _expandedNodes = {};

  @override
  void initState() {
    super.initState();
    _syncNodes();
  }

  @override
  void didUpdateWidget(_ReorderableNodeTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncNodes();
  }

  void _syncNodes() {
    _localNodes = List.from(widget.nodes);
    _localNodes.sort(
      (a, b) => (a['sort_order'] ?? 0).compareTo(b['sort_order'] ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: !widget.isRoot,
      physics: widget.isRoot
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: _localNodes.length,
      onReorderItem: (int oldIndex, int newIndex) async {
        setState(() {
          final item = _localNodes.removeAt(oldIndex);
          _localNodes.insert(newIndex, item);
        });

        List<Map<String, dynamic>> updates = [];
        for (int i = 0; i < _localNodes.length; i++) {
          updates.add({'node_id': _localNodes[i]['id'], 'sort_order': i + 1});
        }

        final messenger = ScaffoldMessenger.of(context);

        try {
          await sl<AdminCourseRepository>().reorderNodes(updates);
        } catch (e) {
          messenger.showSnackBar(SnackBar(content: Text('SORT ERROR: $e')));
        }
      },
      itemBuilder: (context, index) {
        final node = _localNodes[index];
        return _buildInteractiveNode(node, index);
      },
    );
  }

  Widget _buildInteractiveNode(dynamic node, int index) {
    final bool isFolder = node['item_type'] == 'folder';
    final String title = node['title'] ?? 'UNTITLED';
    final String duration = node['duration']?.toString() ?? '--:--';
    final bool hasVault = node['vault'] != null || node['vault_id'] != null;
    final List<dynamic> children = node['children'] ?? [];
    final int nodeId = node['id'];
    final bool isExpanded = _expandedNodes.contains(nodeId);

    Widget headerContent = Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: const MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.drag_indicator,
                  color: Colors.white38,
                  size: 20,
                ),
              ),
            ),
          ),
          if (isFolder)
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedNodes.remove(nodeId);
                  } else {
                    _expandedNodes.add(nodeId);
                  }
                });
              },
              child: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: const Color(0xFF00E676),
                size: 28,
              ),
            )
          else
            const Icon(
              Icons.play_circle_outline,
              color: Colors.white54,
              size: 24,
            ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: isFolder
                  ? () {
                      setState(() {
                        if (isExpanded) {
                          _expandedNodes.remove(nodeId);
                        } else {
                          _expandedNodes.add(nodeId);
                        }
                      });
                    }
                  : null,
              child: Text(
                title,
                style: TextStyle(
                  color: isFolder ? const Color(0xFF00E676) : Colors.white,
                  fontSize: 16,
                  fontWeight: isFolder ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          if (!isFolder) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: !hasVault
                    ? const Color(0xFF00E676).withValues(alpha: 0.1)
                    : Colors.blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: !hasVault
                      ? const Color(0xFF00E676).withValues(alpha: 0.5)
                      : Colors.blueAccent.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                !hasVault ? 'FREE' : 'SECURED',
                style: TextStyle(
                  color: !hasVault
                      ? const Color(0xFF00E676)
                      : Colors.blueAccent,
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
              onPressed: () => widget.onAddChild(nodeId),
              tooltip: 'Add content to folder',
            ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white54,
              size: 20,
            ),
            onPressed: () => widget.onEdit(node),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 20,
            ),
            onPressed: () => widget.onDelete(nodeId),
          ),
        ],
      ),
    );

    return Container(
      key: ValueKey(nodeId),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerContent,
          if (isFolder && isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
              child: children.isNotEmpty
                  ? _ReorderableNodeTree(
                      nodes: children,
                      courseId: widget.courseId,
                      onEdit: widget.onEdit,
                      onDelete: widget.onDelete,
                      onAddChild: widget.onAddChild,
                      isRoot: false,
                    )
                  : const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'EMPTY SECTION',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
