import 'package:trajectoria/features/jobseeker/learn/domain/entities/course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/subchapter.dart';

abstract class ChapterState {
  const ChapterState();
}

class ChapterInitial extends ChapterState {}

class ChapterLoading extends ChapterState {}

class ChapterAndSubchaptersLoaded extends ChapterState {
  final CourseChapterEntity courseChapter;
  final List<SubChapterEntity> subChapters;
  ChapterAndSubchaptersLoaded(this.courseChapter, this.subChapters);
}

class ChapterFailure extends ChapterState {}
