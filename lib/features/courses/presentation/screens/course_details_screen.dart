import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/service_locator.dart';
import '../bloc/course_details_bloc.dart';

void executeReorder(
  int oldIndex,
  int newIndex,
  List<dynamic> list,
  CourseDetailsBloc bloc,
  int courseId,
) {
  final mutableList = List<dynamic>.from(list);
  final item = mutableList.removeAt(oldIndex);
  mutableList.insert(newIndex, item);

  List<dynamic> nodesToUpdate = [];
  for (int i = 0; i < mutableList.length; i++) {
    if (mutableList[i]['sort_order'] != i + 1) {
      mutableList[i]['sort_order'] = i + 1;
      nodesToUpdate.add(mutableList[i]);
    }
  }

  if (nodesToUpdate.isNotEmpty) {
    bloc.add(UpdateNodesOrderEvent(courseId, nodesToUpdate));
  }
}

class CourseDetailsScreen extends StatelessWidget {
  final int courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CourseDetailsBloc>()..add(FetchCourseDetails(courseId)),
      child: _CourseDetailsView(courseId: courseId),
    );
  }
}

class _CourseDetailsView extends StatelessWidget {
  final int courseId;

  const _CourseDetailsView({required this.courseId});

  void _showAutoBuildDialog(BuildContext context, CourseDetailsBloc bloc) {
    final batchController = TextEditingController();
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
          'AUTO BUILD TREE ENGINE',
          style: TextStyle(
            color: Color(0xFF00E676),
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        content: TextField(
          controller: batchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'TARGET BATCH NAME',
            labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              if (batchController.text.trim().isNotEmpty) {
                bloc.add(
                  AutoBuildCourseEvent(courseId, batchController.text.trim()),
                );
              }
              context.pop();
            },
            child: const Text(
              'LAUNCH GENERATOR',
              style: TextStyle(color: Color(0xFF00E676)),
            ),
          ),
        ],
      ),
    );
  }

  void _showNodeDialog(
    BuildContext context,
    CourseDetailsBloc bloc, {
    int? parentId,
    dynamic existingNode,
    required String itemType,
  }) {
    final isEdit = existingNode != null;
    final titleController = TextEditingController(
      text: isEdit ? existingNode['title'] : '',
    );
    final orderController = TextEditingController(
      text: isEdit ? existingNode['sort_order'].toString() : '1',
    );
    final attachmentController = TextEditingController(
      text: isEdit && itemType == 'video' ? existingNode['attachment_url'] : '',
    );
    final durationController = TextEditingController(
      text: isEdit && itemType == 'video'
          ? existingNode['duration'].toString()
          : '0',
    );
    final downloadUrlController = TextEditingController(
      text: isEdit && itemType == 'video' && existingNode['vault'] != null
          ? existingNode['vault']['download_url']
          : '',
    );

    int? selectedVaultId = isEdit && itemType == 'video'
        ? existingNode['vault_id']
        : null;

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
        title: Text(
          isEdit
              ? 'EDIT ${itemType.toUpperCase()} // ID: ${existingNode['id']}'
              : 'CREATE NEW ${itemType.toUpperCase()}',
          style: const TextStyle(
            color: Color(0xFF00E676),
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: '${itemType.toUpperCase()} TITLE',
                    labelStyle: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextField(
                  controller: orderController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'SORT ORDER',
                    labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
                if (itemType == 'video') ...[
                  TextField(
                    controller: durationController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'DURATION (MINUTES)',
                      labelStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextField(
                    controller: attachmentController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'LAB ATTACHMENT URL',
                      labelStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<dynamic>>(
                    future: bloc.repository.getVaultItems(courseId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const LinearProgressIndicator(
                          color: Color(0xFF00E676),
                        );
                      }
                      final vaultItems = snapshot.data!;
                      return DropdownButtonFormField<int>(
                        initialValue: selectedVaultId,
                        dropdownColor: const Color(0xFF141414),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'CONNECT VIDEO VAULT ITEM',
                          labelStyle: TextStyle(
                            color: Color(0xFF00E676),
                            fontSize: 12,
                          ),
                        ),
                        items: [
                          if (isEdit && existingNode['vault_id'] != null)
                            DropdownMenuItem<int>(
                              value: existingNode['vault_id'],
                              child: Text(
                                'CURRENT: [ID: ${existingNode['vault_id']}] ${existingNode['title']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ...vaultItems.map(
                            (item) => DropdownMenuItem<int>(
                              value: item['id'],
                              child: Text(
                                '[ID: ${item['id']}] ${item['original_filename'] ?? item['uuid'].toString().substring(0, 8)}',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          setDialogState(() {
                            selectedVaultId = val;
                            if (val != null) {
                              final selectedItem = vaultItems.firstWhere(
                                (element) => element['id'] == val,
                                orElse: () => null,
                              );
                              if (selectedItem != null &&
                                  selectedItem['download_url'] != null) {
                                downloadUrlController.text =
                                    selectedItem['download_url'];
                              }
                            }
                          });
                        },
                      );
                    },
                  ),
                  if (selectedVaultId != null)
                    TextField(
                      controller: downloadUrlController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'MP6 DOWNLOAD PATH (CDN URL)',
                        labelStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              // برای جلوگیری از ارور کانتکست، مسنجر رو قبل از پاپ شدن دیالوگ می‌گیریم
              final messenger = ScaffoldMessenger.of(context);

              try {
                // آپدیت لینک دانلود خزانه در صورت وجود
                if (selectedVaultId != null &&
                    downloadUrlController.text.trim().isNotEmpty) {
                  await bloc.repository.updateVaultUrl(
                    selectedVaultId!,
                    downloadUrlController.text.trim(),
                  );
                }

                // شلیک ایونت به BLoC
                if (isEdit) {
                  bloc.add(
                    UpdateNodeEvent(
                      courseId,
                      existingNode['id'],
                      titleController.text,
                      int.parse(orderController.text),
                      duration: itemType == 'video'
                          ? int.parse(durationController.text)
                          : null,
                      attachmentUrl: itemType == 'video'
                          ? attachmentController.text
                          : null,
                      vaultId: itemType == 'video' ? selectedVaultId : null,
                    ),
                  );
                } else {
                  bloc.add(
                    CreateNodeEvent(
                      courseId,
                      parentId,
                      itemType,
                      titleController.text,
                      int.parse(orderController.text),
                      duration: itemType == 'video'
                          ? int.parse(durationController.text)
                          : null,
                      attachmentUrl: itemType == 'video'
                          ? attachmentController.text
                          : null,
                      vaultId: itemType == 'video' ? selectedVaultId : null,
                    ),
                  );
                }

                // بستن امن دیالوگ
                if (context.mounted) {
                  context.pop();
                }

                // نمایش اسنک‌بار موفقیت
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text(
                      'DATA SYNCED SUCCESSFULLY',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Color(0xFF00E676),
                    duration: Duration(seconds: 2),
                  ),
                );

                // فورس رفرش: به BLoC میگیم دیتای جدید رو از بک‌اند بگیره تا صفحه همون لحظه آپدیت بشه
                Future.delayed(const Duration(milliseconds: 500), () {
                  bloc.add(FetchCourseDetails(courseId));
                });
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'SYNC FAILED: $e',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.redAccent,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
            child: const Text(
              'EXECUTE',
              style: TextStyle(
                color: Color(0xFF00E676),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF141414),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00E676)),
            onPressed: () => context.go('/courses'),
          ),
          title: Text(
            'COURSE CONTROL CENTER // ID: $courseId',
            style: const TextStyle(
              color: Color(0xFF00E676),
              letterSpacing: 2,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bolt, color: Color(0xFF00E676)),
              onPressed: () => _showAutoBuildDialog(context, bloc),
              tooltip: 'AUTO BUILD FROM VAULT',
            ),
            IconButton(
              icon: const Icon(
                Icons.create_new_folder_outlined,
                color: Color(0xFF00E676),
              ),
              onPressed: () =>
                  _showNodeDialog(context, bloc, itemType: 'folder'),
              tooltip: 'ADD ROOT FOLDER',
            ),
            const SizedBox(width: 16),
          ],
          bottom: TabBar(
            indicatorColor: const Color(0xFF00E676),
            labelColor: const Color(0xFF00E676),
            unselectedLabelColor: Colors.white54,
            dividerColor: const Color(0xFF00E676).withValues(alpha: 0.2),
            tabs: const [
              Tab(text: 'LESSONS MANAGEMENT'),
              Tab(text: 'LICENSES & SERIALS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLessonsTab(bloc),
            const Center(
              child: Text(
                'LICENSES MODULE COMING SOON...',
                style: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'monospace',
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonsTab(CourseDetailsBloc bloc) {
    return BlocBuilder<CourseDetailsBloc, CourseDetailsState>(
      builder: (context, state) {
        if (state is CourseDetailsLoading || state is CourseDetailsInitial) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00E676)),
          );
        } else if (state is CourseDetailsError) {
          return Center(
            child: Text(
              'SYSTEM FAULT: ${state.message}',
              style: const TextStyle(
                color: Colors.redAccent,
                fontFamily: 'monospace',
              ),
            ),
          );
        } else if (state is CourseDetailsLoaded) {
          final tree = state.courseData['tree'] as List<dynamic>? ?? [];

          return Column(
            children: [
              if (state.isUpdating)
                const LinearProgressIndicator(
                  color: Color(0xFF00E676),
                  backgroundColor: Colors.transparent,
                ),
              Expanded(
                child: tree.isEmpty
                    ? const Center(
                        child: Text(
                          'NO DATA FOUND. CLICK THE BOLT ICON FOR AUTO-BUILD.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontFamily: 'monospace',
                          ),
                        ),
                      )
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.all(32),
                        buildDefaultDragHandles: false,
                        itemCount: tree.length,
                        itemBuilder: (context, index) {
                          return RecursiveNodeWidget(
                            key: ValueKey('root_${tree[index]['id']}'),
                            node: tree[index],
                            index: index,
                            courseId: courseId,
                            bloc: bloc,
                            onEdit: (node, type) => _showNodeDialog(
                              context,
                              bloc,
                              existingNode: node,
                              itemType: type,
                            ),
                            onAddChild: (parentId, type) => _showNodeDialog(
                              context,
                              bloc,
                              parentId: parentId,
                              itemType: type,
                            ),
                          );
                        },
                        onReorderItem: (oldIndex, newIndex) => executeReorder(
                          oldIndex,
                          newIndex,
                          tree,
                          bloc,
                          courseId,
                        ),
                      ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class RecursiveNodeWidget extends StatefulWidget {
  final dynamic node;
  final int index;
  final int courseId;
  final CourseDetailsBloc bloc;
  final Function(dynamic node, String type) onEdit;
  final Function(int parentId, String type) onAddChild;

  const RecursiveNodeWidget({
    super.key,
    required this.node,
    required this.index,
    required this.courseId,
    required this.bloc,
    required this.onEdit,
    required this.onAddChild,
  });

  @override
  State<RecursiveNodeWidget> createState() => _RecursiveNodeWidgetState();
}

class _RecursiveNodeWidgetState extends State<RecursiveNodeWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isFolder = widget.node['item_type'] == 'folder';
    final children = widget.node['children'] as List<dynamic>? ?? [];

    if (!isFolder) {
      final isEncrypted = widget.node['is_encrypted'] == true;
      return Container(
        margin: const EdgeInsets.only(bottom: 8, top: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          border: Border(
            left: BorderSide(
              color: isEncrypted ? const Color(0xFF00E676) : Colors.redAccent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: widget.index,
              child: const MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.drag_indicator,
                    color: Colors.white24,
                    size: 24,
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.play_circle_outline,
              color: Colors.white54,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.node['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DURATION: ${widget.node['duration']} MIN // SORT: ${widget.node['sort_order']}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.white54,
                size: 20,
              ),
              onPressed: () => widget.onEdit(widget.node, 'video'),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 20,
              ),
              onPressed: () => widget.bloc.add(
                DeleteNodeEvent(widget.courseId, widget.node['id']),
              ),
            ),
          ],
        ),
      );
    }

    final folderContent = Container(
      margin: const EdgeInsets.only(bottom: 8, top: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        border: Border.all(
          color: const Color(0xFF00E676).withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: widget.index,
            child: const MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.drag_indicator,
                  color: Colors.white54,
                  size: 24,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Icon(
              isExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
              color: const Color(0xFF00E676),
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.node['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NODE ID: ${widget.node['id']} // SORT: ${widget.node['sort_order']}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.create_new_folder_outlined,
              color: Color(0xFF00E676),
              size: 18,
            ),
            onPressed: () => widget.onAddChild(widget.node['id'], 'folder'),
            tooltip: 'ADD SUB-FOLDER',
          ),
          IconButton(
            icon: const Icon(
              Icons.video_call_outlined,
              color: Color(0xFF00E676),
              size: 18,
            ),
            onPressed: () => widget.onAddChild(widget.node['id'], 'video'),
            tooltip: 'ADD VIDEO',
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white54,
              size: 18,
            ),
            onPressed: () => widget.onEdit(widget.node, 'folder'),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 18,
            ),
            onPressed: () => widget.bloc.add(
              DeleteNodeEvent(widget.courseId, widget.node['id']),
            ),
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        folderContent,
        if (isExpanded && children.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(left: 32, bottom: 8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: const Color(0xFF00E676).withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 16),
            child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: children.length,
              itemBuilder: (context, childIndex) {
                return RecursiveNodeWidget(
                  key: ValueKey('child_${children[childIndex]['id']}'),
                  node: children[childIndex],
                  index: childIndex,
                  courseId: widget.courseId,
                  bloc: widget.bloc,
                  onEdit: widget.onEdit,
                  onAddChild: widget.onAddChild,
                );
              },
              onReorderItem: (oldIndex, newIndex) => executeReorder(
                oldIndex,
                newIndex,
                children,
                widget.bloc,
                widget.courseId,
              ),
            ),
          ),
      ],
    );
  }
}
