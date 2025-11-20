import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class AddUserScoreUseCase {
  final LearnRepository repository;
  AddUserScoreUseCase({required this.repository});

  Future<Either> call(double score) async {
    return await repository.addUserScore(score);
  }
}
