import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class GetSubchaptersUseCase {
  final LearnRepository repository;
  GetSubchaptersUseCase({required this.repository});

  Future<Either> call(String courseId, int chapterOrder) async {
    return await repository.getSubchapters(courseId, chapterOrder);
  }
}
