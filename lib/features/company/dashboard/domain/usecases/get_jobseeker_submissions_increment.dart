import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class GetJobseekerSubmissionsIncrementUseCase {
  final CreateCompetitionRepository repository;
  GetJobseekerSubmissionsIncrementUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.getJobseekerSubmissionsIncrement(competitionId);
  }
}
