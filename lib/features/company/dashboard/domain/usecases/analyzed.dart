import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class AnalyzedUseCase {
  final CreateCompetitionRepository repository;

  AnalyzedUseCase({required this.repository});
  Future<Either> call(
    String submissionId,
    String problemStatement,
    List<String> fileUrls,
  ) async {
    return await repository.analyzeSubmission(
      problemStatement: problemStatement,
      submissionId: submissionId,
      fileUrls: fileUrls,
    );
  }
}
