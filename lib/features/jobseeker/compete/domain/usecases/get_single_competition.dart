import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class GetSingleCompetitionUseCase {
  final CompetitionRepository repository;
  GetSingleCompetitionUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.getSingleCompetition(competitionId);
  }
}
