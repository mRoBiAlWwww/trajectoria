import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class GetJobseekerAcrossSubmissionsUseCase {
  final CompetitionOrganizerRepository repository;
  GetJobseekerAcrossSubmissionsUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getAcrossJobseekerSubmissions();
  }
}
