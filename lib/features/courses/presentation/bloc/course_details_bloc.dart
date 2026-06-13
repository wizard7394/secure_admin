import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/course_repository.dart';

abstract class CourseDetailsEvent {}

class FetchCourseDetails extends CourseDetailsEvent {
  final int courseId;
  FetchCourseDetails(this.courseId);
}

class CreateNodeEvent extends CourseDetailsEvent {
  final int courseId;
  final int? parentId;
  final String itemType;
  final String title;
  final int sortOrder;
  final String? videoUrl;
  final int? duration;
  final String? attachmentUrl;
  final int? vaultId;
  CreateNodeEvent(
    this.courseId,
    this.parentId,
    this.itemType,
    this.title,
    this.sortOrder, {
    this.videoUrl,
    this.duration,
    this.attachmentUrl,
    this.vaultId,
  });
}

class UpdateNodeEvent extends CourseDetailsEvent {
  final int courseId;
  final int nodeId;
  final String title;
  final int sortOrder;
  final String? videoUrl;
  final int? duration;
  final String? attachmentUrl;
  final int? vaultId;
  UpdateNodeEvent(
    this.courseId,
    this.nodeId,
    this.title,
    this.sortOrder, {
    this.videoUrl,
    this.duration,
    this.attachmentUrl,
    this.vaultId,
  });
}

class UpdateNodesOrderEvent extends CourseDetailsEvent {
  final int courseId;
  final List<dynamic> updatedNodes;
  UpdateNodesOrderEvent(this.courseId, this.updatedNodes);
}

class DeleteNodeEvent extends CourseDetailsEvent {
  final int courseId;
  final int nodeId;
  DeleteNodeEvent(this.courseId, this.nodeId);
}

class AutoBuildCourseEvent extends CourseDetailsEvent {
  final int courseId;
  final String batchName;
  AutoBuildCourseEvent(this.courseId, this.batchName);
}

abstract class CourseDetailsState {}

class CourseDetailsInitial extends CourseDetailsState {}

class CourseDetailsLoading extends CourseDetailsState {}

class CourseDetailsLoaded extends CourseDetailsState {
  final Map<String, dynamic> courseData;
  final bool isUpdating;
  CourseDetailsLoaded(this.courseData, {this.isUpdating = false});
}

class CourseDetailsError extends CourseDetailsState {
  final String message;
  CourseDetailsError(this.message);
}

class CourseDetailsBloc extends Bloc<CourseDetailsEvent, CourseDetailsState> {
  final AdminCourseRepository repository;

  CourseDetailsBloc(this.repository) : super(CourseDetailsInitial()) {
    on<FetchCourseDetails>((event, emit) async {
      emit(CourseDetailsLoading());
      await _fetchData(event.courseId, emit);
    });

    on<CreateNodeEvent>((event, emit) async {
      _emitBackgroundUpdating(emit);
      try {
        await repository.createNode(
          event.courseId,
          event.parentId,
          event.itemType,
          event.title,
          event.sortOrder,
          videoUrl: event.videoUrl,
          duration: event.duration,
          attachmentUrl: event.attachmentUrl,
          vaultId: event.vaultId,
        );
        await _fetchData(event.courseId, emit);
      } catch (e) {
        emit(CourseDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<UpdateNodeEvent>((event, emit) async {
      _emitBackgroundUpdating(emit);
      try {
        await repository.updateNode(
          event.nodeId,
          event.title,
          event.sortOrder,
          videoUrl: event.videoUrl,
          duration: event.duration,
          attachmentUrl: event.attachmentUrl,
          vaultId: event.vaultId,
        );
        await _fetchData(event.courseId, emit);
      } catch (e) {
        emit(CourseDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<UpdateNodesOrderEvent>((event, emit) async {
      _emitBackgroundUpdating(emit);
      try {
        for (var node in event.updatedNodes) {
          await repository.updateNode(
            node['id'],
            node['title'],
            node['sort_order'],
            videoUrl: node['video_url'],
            duration: node['duration'],
            attachmentUrl: node['attachment_url'],
            vaultId: node['vault_id'],
          );
        }
        await _fetchData(event.courseId, emit);
      } catch (e) {
        emit(CourseDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<DeleteNodeEvent>((event, emit) async {
      _emitBackgroundUpdating(emit);
      try {
        await repository.deleteNode(event.nodeId);
        await _fetchData(event.courseId, emit);
      } catch (e) {
        emit(CourseDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<AutoBuildCourseEvent>((event, emit) async {
      _emitBackgroundUpdating(emit);
      try {
        await repository.autoBuildCourse(event.courseId, event.batchName);
        await _fetchData(event.courseId, emit);
      } catch (e) {
        emit(CourseDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }

  void _emitBackgroundUpdating(Emitter<CourseDetailsState> emit) {
    if (state is CourseDetailsLoaded) {
      emit(
        CourseDetailsLoaded(
          (state as CourseDetailsLoaded).courseData,
          isUpdating: true,
        ),
      );
    } else {
      emit(CourseDetailsLoading());
    }
  }

  Future<void> _fetchData(
    int courseId,
    Emitter<CourseDetailsState> emit,
  ) async {
    try {
      final data = await repository.getCourseTree(courseId);
      emit(CourseDetailsLoaded(data, isUpdating: false));
    } catch (e) {
      emit(CourseDetailsError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
