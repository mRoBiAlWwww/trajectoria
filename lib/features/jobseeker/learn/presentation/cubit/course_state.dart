import 'package:trajectoria/features/jobseeker/learn/domain/entities/course.dart';

abstract class CourseState {
  const CourseState();
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<CourseEntity> course;
  CourseLoaded(this.course);
}

class SelectedCourse extends CourseState {
  final CourseEntity course;
  SelectedCourse(this.course);
}

class SuccessfulProcess extends CourseState {
  final String message;
  SuccessfulProcess(this.message);
}

class CourseFailure extends CourseState {}
