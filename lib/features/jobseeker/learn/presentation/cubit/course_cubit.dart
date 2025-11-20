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

// Future<void> getCourseAndSubchapters(
//     String courseId,
//     int chapterOrder,
//   ) async {
//     emit(LearnLoading());
//     final returnedCourseChapter = await sl<GetCourseChapterUseCase>().call(
//       courseId,
//       chapterOrder,
//     );
//     final chapterData = returnedCourseChapter.fold((error) {
//       emit(LearnFailure());
//       return null;
//     }, (data) => data);
//     if (chapterData == null) return;
//     final returnedSubchapters = await sl<GetSubchaptersUseCase>().call(
//       courseId,
//       chapterOrder,
//     );
//     final subchapterData = returnedSubchapters.fold((error) {
//       emit(LearnFailure());
//       return null;
//     }, (data) => data);
//     if (subchapterData == null) return;
//     ///////
//     final List<SubChapterEntity> subChapters = subchapterData;
//     final List<ModuleEntity> modules = [];
//     // Loop tiap subchapter
//     for (final sub in subChapters) {
//       if (sub.hasCollection == true) {
//         final returnedModules = await sl<GetModulesUseCase>().call(
//           courseId,
//           chapterOrder,
//           sub.subchapterId,
//         );
//         // Ambil data module jika sukses
//         returnedModules.fold(
//           (error) {
//             emit(LearnFailure());
//           },
//           (data) {
//             modules.addAll(data); // kumpulkan semua module di sini
//           },
//         );
//       }
//     }
//     emit(
//       LearnChapterAndSubchaptersLoaded(chapterData, subchapterData, modules),
//     );
//   }
//   Future<void> getFinishedModules() async {
//     emit(LearnLoading());
//     var returnedUser = await sl<LearnService>().getFinishedModules();
//     returnedUser.fold(
//       (error) {
//         emit(LearnFailure());
//       },
//       (data) {
//         emit(LearnModulesAndFinishedModulesLoaded(data));
//       },
//     );
//   }
 // debugPrint("cok jaran");
        // final moduleList = data as List<ModuleEntity>;
        // moduleList.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        // debugPrint("--- [DEBUG] Pengecekan Urutan Modul ---");
        // for (var module in moduleList) {
        //   print("Judul: ${module.title} | Urutan: ${module.orderIndex}");
        // }
        // debugPrint("--- [DEBUG] Selesai ---");