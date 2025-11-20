import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

class AddFinalisUseCase {
  final CreateCompetitionRepository repository;
  AddFinalisUseCase({required this.repository});

  Future<Either> call(
    SubmissionEntity finalis,
    String name,
    String imageUrl,
  ) async {
    return await repository.addToFinalis(finalis, name, imageUrl);
  }
}
