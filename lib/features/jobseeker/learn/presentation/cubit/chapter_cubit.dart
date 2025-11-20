import 'package:bloc/bloc.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_subchapters.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_state.dart';
import 'package:trajectoria/service_locator.dart';

class ChapterCubit extends Cubit<ChapterState> {
  ChapterCubit() : super(ChapterInitial());

  Future<void> getChapterAndSubchapters(
    String courseId,
    int chapterOrder,
  ) async {
    emit(ChapterLoading());

    final returnedCourseChapter = await sl<GetCourseChapterUseCase>().call(
      courseId,
      chapterOrder,
    );

    final chapterData = returnedCourseChapter.fold((error) {
      emit(ChapterFailure());
      return null;
    }, (data) => data);

    if (chapterData == null) return;

    final returnedSubchapters = await sl<GetSubchaptersUseCase>().call(
      courseId,
      chapterOrder,
    );

    final subchapterData = returnedSubchapters.fold((error) {
      emit(ChapterFailure());
      return null;
    }, (data) => data);

    if (subchapterData == null) return;

    emit(ChapterAndSubchaptersLoaded(chapterData, subchapterData));
  }
}
