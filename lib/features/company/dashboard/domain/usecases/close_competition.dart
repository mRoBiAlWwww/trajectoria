import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class CloseCompetitionUseCase {
  final CompetitionOrganizerRepository repository;
  CloseCompetitionUseCase({required this.repository});

  Future<Either> call(
    String competitionId,
    String competitionName,
    String companyName, {
    int topN = 10,
  }) async {
    return await repository.closeCompetition(
      competitionId,
      competitionName,
      companyName,
      topN: topN,
    );
  }
}
