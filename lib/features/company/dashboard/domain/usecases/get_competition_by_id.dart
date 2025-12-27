import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class GetCompetitionByIdCompanyUseCase {
  final CompetitionOrganizerRepository repository;
  GetCompetitionByIdCompanyUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.getCompetitionById(competitionId);
  }
}
