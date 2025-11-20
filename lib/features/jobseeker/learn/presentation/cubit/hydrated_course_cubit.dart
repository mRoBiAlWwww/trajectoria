import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/course.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/course.dart';

class HydratedSelectedCourseCubit extends HydratedCubit<CourseEntity?> {
  HydratedSelectedCourseCubit() : super(null);

  void setCourse(CourseEntity course) {
    emit(course);
  }

  void clearCourse() {
    emit(null);
  }

  @override
  CourseEntity? fromJson(Map<String, dynamic> json) {
    try {
      return CourseModel.fromMap(json).toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CourseEntity? state) {
    if (state == null) return null;
    return CourseModel.fromEntity(state).toMap();
  }
}
