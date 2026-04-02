import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class ExportSubmissionsCsvUseCase {
  final CompetitionOrganizerRepository repository;
  ExportSubmissionsCsvUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.exportSubmissionsToCsv(competitionId);
  }
}
