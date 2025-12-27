import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class GetTotalCompParticipantsUseCase {
  final CompetitionRepository repository;
  GetTotalCompParticipantsUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.getTotalCompetitionParticipants(competitionId);
  }
}
