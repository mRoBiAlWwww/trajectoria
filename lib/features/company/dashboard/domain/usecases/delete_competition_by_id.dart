import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class DeleteCompetitionByIdUseCase {
  final CompetitionOrganizerRepository repository;

  DeleteCompetitionByIdUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.deleteCompetitionById(competitionId);
  }
}
