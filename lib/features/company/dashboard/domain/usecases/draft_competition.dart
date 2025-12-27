import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';

class DraftCompetitionUseCase {
  final CompetitionOrganizerRepository repository;

  DraftCompetitionUseCase({required this.repository});

  Future<Either> call(CompetitionEntity newCompetition) async {
    return await repository.draftCompetition(newCompetition);
  }
}
