import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class GetAllCourseChaptersUseCase {
  final LearnRepository repository;
  GetAllCourseChaptersUseCase({required this.repository});

  Future<Either> call(String courseId) async {
    return await repository.getAllCourseChapters(courseId);
  }
}
