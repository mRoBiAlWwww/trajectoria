import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class GetFinalisUseCase {
  final CompetitionOrganizerRepository repository;

  GetFinalisUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.getFinalis(competitionId);
  }
}
