import 'package:bloc/bloc.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/authentication/domain/usecases/get_current_user.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_all_course_chapters.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_subchapters.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_state.dart';
import 'package:trajectoria/service_locator.dart';

class ChapterCubit extends Cubit<ChapterState> {
  ChapterCubit() : super(ChapterInitial());

  Future<void> getAllChapters(String courseId) async {
    emit(ChapterLoading());

    final returnedCourseChapter = await sl<GetAllCourseChaptersUseCase>().call(
      courseId,
    );
    return returnedCourseChapter.fold(
      (error) {
        emit(ChapterFailure());
      },
      (chapterData) async {
        emit(ChapterLoaded(chapterData));
      },
    );
  }

  Future<void> getChapterAndSubchaptersAndFinishedSubchapters(
    String courseId,
    int chapterOrder,
  ) async {
    emit(ChapterLoading());

    final returnedCourseChapter = await sl<GetCourseChapterUseCase>().call(
      courseId,
      chapterOrder,
    );
    return returnedCourseChapter.fold(
      (error) {
        emit(ChapterFailure());
      },
      (chapterData) async {
        final returnedSubchapters = await sl<GetSubchaptersUseCase>().call(
          courseId,
          chapterOrder,
        );

        returnedSubchapters.fold(
          (error) {
            emit(ChapterFailure());
          },
          (subchapterData) async {
            final userResult = await sl<GetCurrentUserUseCase>().call();
            userResult.fold(
              (error) {
                emit(ChapterFailure());
              },
              (user) {
                final finishedSubchapter = user is JobSeekerEntity
                    ? user.finishedSubchapter
                    : <String>[];
                emit(
                  ChapterAndSubchaptersAndFinishedSubchaptersLoaded(
                    chapterData,
                    subchapterData,
                    finishedSubchapter,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
