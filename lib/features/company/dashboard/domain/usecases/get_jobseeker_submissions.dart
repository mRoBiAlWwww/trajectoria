import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class GetJobseekerSubmissionsUseCase {
  final CompetitionOrganizerRepository repository;
  GetJobseekerSubmissionsUseCase({required this.repository});

  Future<Either> call(String competitionId, String show) async {
    return await repository.getJobseekerSubmissions(competitionId, show);
  }
}
