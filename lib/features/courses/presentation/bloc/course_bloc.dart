import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/course_repository.dart';

abstract class CourseEvent {}

class FetchCourses extends CourseEvent {}

class CreateCourseEvent extends CourseEvent {
  final String title;
  final String baseStreamUrl;
  CreateCourseEvent(this.title, this.baseStreamUrl);
}

class DeleteCourseEvent extends CourseEvent {
  final int courseId;
  DeleteCourseEvent(this.courseId);
}

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<dynamic> courses;
  CourseLoaded(this.courses);
}

class CourseError extends CourseState {
  final String message;
  CourseError(this.message);
}

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final AdminCourseRepository _repository;

  CourseBloc(this._repository) : super(CourseInitial()) {
    on<FetchCourses>((event, emit) async {
      emit(CourseLoading());
      try {
        final courses = await _repository.getCourses();
        emit(CourseLoaded(courses));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<CreateCourseEvent>((event, emit) async {
      try {
        await _repository.createCourse(event.title, event.baseStreamUrl);
        add(FetchCourses());
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<DeleteCourseEvent>((event, emit) async {
      try {
        await _repository.deleteCourse(event.courseId);
        add(FetchCourses());
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });
  }
}
