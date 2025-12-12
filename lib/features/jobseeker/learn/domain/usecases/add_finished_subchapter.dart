import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class AddFinishedSubchapterStatusUseCase {
  final LearnRepository repository;
  AddFinishedSubchapterStatusUseCase({required this.repository});

  Future<Either> call(String subChapterId) async {
    return await repository.addFinishedSubchapter(subChapterId);
  }
}
