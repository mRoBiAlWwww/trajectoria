import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class ScoringUseCase {
  final CreateCompetitionRepository repository;
  ScoringUseCase({required this.repository});

  Future<Either> call(
    int totalScore,
    String feedback,
    String submissionId,
  ) async {
    return await repository.scoring(totalScore, feedback, submissionId);
  }
}
