import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/authentication/domain/usecases/get_current_user.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_course_by_id.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_modules.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/finished_chapter_module_state.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';

class FinishedChapterAndModuleCubit
    extends Cubit<FinishedChapterAndModuleState> {
  FinishedChapterAndModuleCubit() : super(FinishedChapterAndModuleInitial());

  Future<void> getModulesAndFinishedModules(
    String courseId,
    int chapterOrder,
    String subChapterId,
  ) async {
    emit(FinishedChapterAndModuleLoading());

    final modulesResult = await sl<GetModulesUseCase>().call(
      courseId,
      chapterOrder,
      subChapterId,
    );
    return modulesResult.fold(
      (error) {
        emit(FinishedChapterAndModuleFailure());
      },
      (modules) async {
        final userResult = await sl<GetCurrentUserUseCase>().call();
        userResult.fold(
          (error) {
            emit(FinishedChapterAndModuleFailure());
          },
          (user) {
            final finishedModules = user is JobSeekerEntity
                ? user.finishedModule
                : <String>[];

            emit(ModulesAndFinishedModulesLoaded(modules, finishedModules));
          },
        );
      },
    );
  }

  Future<void> getFinishedChapters(String courseId) async {
    emit(FinishedChapterAndModuleLoading());

    final userResult = await sl<GetCurrentUserUseCase>().call();

    return userResult.fold(
      (error) {
        emit(FinishedChapterAndModuleFailure());
      },
      (user) async {
        final onprogresChapterId = user is JobSeekerEntity
            ? user.onprogresChapter
            : "";
        final finishedChapterIdList = user is JobSeekerEntity
            ? user.finishedChapter
            : <String>[];

        if (onprogresChapterId != "") {
          final courseResult = await sl<GetCourseChapterByIdUseCase>().call(
            courseId,
            onprogresChapterId,
          );
          return courseResult.fold(
            (error) {
              emit(FinishedChapterAndModuleFailure());
            },
            (course) async {
              emit(
                OnprogresOrFinishedChapterLoaded(course, finishedChapterIdList),
              );
            },
          );
        } else {
          emit(OnprogresOrFinishedChapterLoaded(null, finishedChapterIdList));
        }
      },
    );
  }
}
