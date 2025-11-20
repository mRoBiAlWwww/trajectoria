import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class AddCompetitionParticipantUseCase {
  final CompetitionRepository repository;
  AddCompetitionParticipantUseCase({required this.repository});

  Future<Either> call(String compId) async {
    return await repository.addCompetitionParticipant(compId);
  }
}
