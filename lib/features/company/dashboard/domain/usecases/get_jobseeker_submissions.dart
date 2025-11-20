import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class GetJobseekerSubmissionsUseCase {
  final CreateCompetitionRepository repository;
  GetJobseekerSubmissionsUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.getJobseekerSubmissions(competitionId);
  }
}
