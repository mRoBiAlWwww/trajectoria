import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class GetDraftCompetitionsUseCase {
  final CompetitionOrganizerRepository repository;

  GetDraftCompetitionsUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getDraftCompetitions();
  }
}
