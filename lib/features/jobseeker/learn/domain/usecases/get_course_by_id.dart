import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class GetCourseChapterByIdUseCase {
  final LearnRepository repository;
  GetCourseChapterByIdUseCase({required this.repository});

  Future<Either> call(String courseId, String courseChapterId) async {
    return await repository.getCourseChapterById(courseId, courseChapterId);
  }
}
