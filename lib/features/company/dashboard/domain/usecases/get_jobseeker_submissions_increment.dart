import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class GetJobseekerSubmissionsIncrementUseCase {
  final CompetitionOrganizerRepository repository;
  GetJobseekerSubmissionsIncrementUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.getJobseekerSubmissionsIncrement(competitionId);
  }
}
