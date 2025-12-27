import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

class AddFinalisUseCase {
  final CompetitionOrganizerRepository repository;
  AddFinalisUseCase({required this.repository});

  Future<Either> call(
    SubmissionEntity finalis,
    String name,
    String imageUrl,
  ) async {
    return await repository.addToFinalis(finalis, name, imageUrl);
  }
}
