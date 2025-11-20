import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission_req.dart';

abstract class CompetitionRepository {
  Future<Either> getCompetitions();
  Future<Either> getSingleCompetition(String competitionId);
  Future<Either> addCompetitionParticipant(String compId);
  Future<Either> downloadAndOpenFile(String fileUrl, String fileName);
  Future<Either> uploadMultiplePdfs();
  Future<Either> addSubmission(SubmissionReq submission);
  Future<Either> getCompetitionsByTitle(String keyword);
  Future<Either> getCategories();
  Future<Either> getCompetitionsByCategory(String categoryId);
  Future<Either> getCompetitionsByFilters(
    List<String> category,
    String deadline,
  );
  Future<Either> isAlreadySubmitted(String competitionId);
}
