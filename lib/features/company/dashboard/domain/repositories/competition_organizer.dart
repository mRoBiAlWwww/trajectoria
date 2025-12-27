import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/entities/announcement.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

abstract class CompetitionOrganizerRepository {
  Future<Either> createCompetition(CompetitionEntity newCompetition);
  Future<Either> draftCompetition(CompetitionEntity newCompetition);
  Future<Either> getDraftCompetitions();
  Future<Either> getCompetitionsByCurrentCompany();
  Future<Either> getCompetitionById(String competitionId);
  Future<Either> deleteCompetitionById(String competitionId);
  Future<Either> deleteCompetitionParticipantsByCompetitionId(
    String competitionId,
  );
  Future<Either> deleteSubmissionsByCompetitionId(String competitionId);
  Future<Either> getCompetitionsByTitle(String keyword);
  Future<Either> getJobseekerSubmissions(String competitionId, String show);
  Future<Either> analyzeSubmission({
    required String submissionId,
    required String problemStatement,
    required List<String> fileUrls,
  });
  Future<Either> finalAssessment(
    int totalScore,
    String feedback,
    String submissionId,
    AnnouncementEntity announcement,
  );
  Future<Either> addToFinalis(
    SubmissionEntity finalis,
    String name,
    String imageUrl,
  );
  Future<Either> getFinalis(String competitionId);
  Future<Either> deleteFinalis(String submissionId);
  Future<Either> getJobseekerSubmissionsIncrement(String competitionId);
  Future<Either> getAcrossJobseekerSubmissions();
  Future<Either> getSubmissionById(String submissionId);
  Future<Either> getCompetitionParticipants(String competitionParticipantId);
  Future<Either> getUserInformationById(String userId);
  Future<Either> getCurrentCompanyInformation();
  Future<Either> getJobseekerByName(String jobsName);
  Future<Either> getCompetitionParticipantsByUserId(String userId);
  Future<Either> getJobseekerSubmissionsByPartisipantId(String partisipanId);
}
