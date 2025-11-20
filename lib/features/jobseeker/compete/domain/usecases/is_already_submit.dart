import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class IsAlreadySubmitedUseCase {
  final CompetitionRepository repository;
  IsAlreadySubmitedUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.isAlreadySubmitted(competitionId);
  }
}
