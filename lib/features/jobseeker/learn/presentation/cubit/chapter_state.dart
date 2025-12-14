import 'package:trajectoria/features/jobseeker/learn/domain/entities/course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/subchapter.dart';

abstract class ChapterState {
  const ChapterState();
}

class ChapterInitial extends ChapterState {}

class ChapterLoading extends ChapterState {}

class ChapterLoaded extends ChapterState {
  final List<CourseChapterEntity> courseChapter;
  ChapterLoaded(this.courseChapter);
}

class ChapterAndSubchaptersAndFinishedSubchaptersLoaded extends ChapterState {
  final CourseChapterEntity courseChapter;
  final List<SubChapterEntity> subChapters;
  final List<String> user;
  ChapterAndSubchaptersAndFinishedSubchaptersLoaded(
    this.courseChapter,
    this.subChapters,
    this.user,
  );
}

class ChapterFailure extends ChapterState {}
