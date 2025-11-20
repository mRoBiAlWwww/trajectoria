import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class GetJobseekerAcrossSubmissionsUseCase {
  final CreateCompetitionRepository repository;
  GetJobseekerAcrossSubmissionsUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getAcrossJobseekerSubmissions();
  }
}
