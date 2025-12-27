import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class DeleteSubmissionByCompIdUseCase {
  final CompetitionOrganizerRepository repository;

  DeleteSubmissionByCompIdUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.deleteSubmissionsByCompetitionId(competitionId);
  }
}
