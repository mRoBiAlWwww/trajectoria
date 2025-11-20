import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class GetModulesUseCase {
  final LearnRepository repository;
  GetModulesUseCase({required this.repository});

  Future<Either> call(
    String courseId,
    int chapterOrder,
    String subChapterId,
  ) async {
    return await repository.getModules(courseId, chapterOrder, subChapterId);
  }
}
