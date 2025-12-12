import 'package:bloc/bloc.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/course.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_courses_path.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/course_state.dart';
import 'package:trajectoria/service_locator.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit() : super(CourseInitial());

  Future<void> getCourses() async {
    emit(CourseLoading());
    var returnedData = await sl<GetCoursesUseCase>().call();

    returnedData.fold(
      (error) {
        emit(CourseFailure());
      },
      (data) {
        emit(CourseLoaded(data));
      },
    );
  }

  Future<void> selectCourse(CourseEntity course) async {
    emit(SelectedCourse(course));
  }
}
