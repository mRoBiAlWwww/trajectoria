import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class GetCourseChapterUseCase {
  final LearnRepository repository;
  GetCourseChapterUseCase({required this.repository});

  Future<Either> call(String courseId, int chapterOrder) async {
    return await repository.getCourseChapter(courseId, chapterOrder);
  }
}
