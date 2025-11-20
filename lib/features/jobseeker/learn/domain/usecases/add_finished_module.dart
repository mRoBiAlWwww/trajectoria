import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class AddFinishedModuleStatusUseCase {
  final LearnRepository repository;
  AddFinishedModuleStatusUseCase({required this.repository});

  Future<Either> call(String moduleId) async {
    return await repository.addFinishedModule(moduleId);
  }
}
