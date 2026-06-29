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
  final int? duration;
  CreateNodeEvent(
    this.courseId,
    this.parentId,
    this.itemType,
    this.title,
    this.sortOrder, {
    this.duration,
  });
}

class UpdateNodeEvent extends CourseDetailsEvent {
  final int courseId;
  final int nodeId;
  final String title;
  final int sortOrder;
  final int? duration;
  UpdateNodeEvent(
    this.courseId,
    this.nodeId,
    this.title,
    this.sortOrder, {
    this.duration,
  });
}

class DeleteNodeEvent extends CourseDetailsEvent {
  final int courseId;
  final int nodeId;
  DeleteNodeEvent(this.courseId, this.nodeId);
}

abstract class CourseDetailsState {}

class CourseDetailsInitial extends CourseDetailsState {}

class CourseDetailsLoading extends CourseDetailsState {}

class CourseDetailsLoaded extends CourseDetailsState {
  final Map<String, dynamic> courseData;
  CourseDetailsLoaded(this.courseData);
}

class CourseDetailsError extends CourseDetailsState {
  final String message;
  CourseDetailsError(this.message);
}

class CourseDetailsBloc extends Bloc<CourseDetailsEvent, CourseDetailsState> {
  final AdminCourseRepository _repository;

  CourseDetailsBloc(this._repository) : super(CourseDetailsInitial()) {
    on<FetchCourseDetails>((event, emit) async {
      emit(CourseDetailsLoading());
      try {
        final data = await _repository.getCourseTree(event.courseId);
        emit(CourseDetailsLoaded(data));
      } catch (e) {
        emit(CourseDetailsError(e.toString()));
      }
    });

    on<CreateNodeEvent>((event, emit) async {
      try {
        await _repository.createNode(
          event.courseId,
          event.parentId,
          event.itemType,
          event.title,
          event.sortOrder,
          duration: event.duration,
        );
        add(FetchCourseDetails(event.courseId));
      } catch (e) {
        emit(CourseDetailsError(e.toString()));
      }
    });

    on<UpdateNodeEvent>((event, emit) async {
      try {
        await _repository.updateNode(
          event.nodeId,
          event.title,
          event.sortOrder,
          duration: event.duration,
        );
        add(FetchCourseDetails(event.courseId));
      } catch (e) {
        emit(CourseDetailsError(e.toString()));
      }
    });

    on<DeleteNodeEvent>((event, emit) async {
      try {
        await _repository.deleteNode(event.nodeId);
        add(FetchCourseDetails(event.courseId));
      } catch (e) {
        emit(CourseDetailsError(e.toString()));
      }
    });
  }
}
