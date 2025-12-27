import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class DeleteCompPartcByCompIdUseCase {
  final CompetitionOrganizerRepository repository;

  DeleteCompPartcByCompIdUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.deleteCompetitionParticipantsByCompetitionId(
      competitionId,
    );
  }
}
