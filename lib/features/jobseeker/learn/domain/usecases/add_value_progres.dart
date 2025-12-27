import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class AddValueProgresUseCase {
  final LearnRepository repository;
  AddValueProgresUseCase({required this.repository});

  Future<Either> call(String courseId, int newValue) async {
    return await repository.addValueProgres(courseId, newValue);
  }
}
