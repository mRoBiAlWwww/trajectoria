import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

abstract class CreateCompetitionRepository {
  Future<Either> createCompetition(CompetitionEntity newCompetition);
  Future<Either> draftCompetition(CompetitionEntity newCompetition);
  Future<Either> getDraftCompetitions();
  Future<Either> getCompetitions();
  Future<Either> getCompetitionById(String competitionId);
  Future<Either> deleteCompetitionById(String competitionId);
  Future<Either> getCompetitionsByTitle(String keyword);
  Future<Either> getJobseekerSubmissions(String competitionId);
  Future<Either> analyzeSubmission({
    required String submissionId,
    required String problemStatement,
    required List<String> fileUrls,
  });
  Future<Either> getUserInfo(String submissionId);
  Future<Either> scoring(int totalScore, String feedback, String submissionId);
  Future<Either> addToFinalis(
    SubmissionEntity finalis,
    String name,
    String imageUrl,
  );
  Future<Either> getFinalis(String competitionId);
  Future<Either> deleteFinalis(String finalisId);
  Future<Either> getJobseekerSubmissionsIncrement(String competitionId);
  Future<Either> getAcrossJobseekerSubmissions();
}
