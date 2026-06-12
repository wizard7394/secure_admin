import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/course_repository.dart';

abstract class CourseEvent {}

class FetchCourses extends CourseEvent {}

class CreateCourseEvent extends CourseEvent {
  final String title;
  final String watermarkText;
  final String watermarkColor;
  CreateCourseEvent(this.title, this.watermarkText, this.watermarkColor);
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
  final AdminCourseRepository repository;

  CourseBloc(this.repository) : super(CourseInitial()) {
    on<FetchCourses>((event, emit) async {
      emit(CourseLoading());
      await _loadCourses(emit);
    });

    on<CreateCourseEvent>((event, emit) async {
      emit(CourseLoading());
      try {
        await repository.createCourse(
          event.title,
          event.watermarkText,
          event.watermarkColor,
        );
        await _loadCourses(emit);
      } catch (e) {
        emit(CourseError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<DeleteCourseEvent>((event, emit) async {
      emit(CourseLoading());
      try {
        await repository.deleteCourse(event.courseId);
        await _loadCourses(emit);
      } catch (e) {
        emit(CourseError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }

  Future<void> _loadCourses(Emitter<CourseState> emit) async {
    try {
      final data = await repository.getAllCourses();
      emit(CourseLoaded(data));
    } catch (e) {
      emit(CourseError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
