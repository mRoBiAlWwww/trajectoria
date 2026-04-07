import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class AnalyzedUseCase {
  final CompetitionOrganizerRepository repository;

  AnalyzedUseCase({required this.repository});
  Future<Either> call(
    String problemStatement,
    String submissionId,
    List<String> fileUrls,
  ) async {
    return await repository.analyzeSubmission(
      problemStatement: problemStatement,
      submissionId: submissionId,
      fileUrls: fileUrls,
    );
  }
}
