import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class GetCoursesUseCase {
  final LearnRepository repository;
  GetCoursesUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getCourses();
  }
}
