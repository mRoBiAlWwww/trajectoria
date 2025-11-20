import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class GetQuizUseCase {
  final LearnRepository repository;
  GetQuizUseCase({required this.repository});

  Future<Either> call(
    String courseId,
    int chapterOrder,
    String subChapterId,
    String moduleId,
  ) async {
    return await repository.getQuiz(
      courseId,
      chapterOrder,
      subChapterId,
      moduleId,
    );
  }
}
