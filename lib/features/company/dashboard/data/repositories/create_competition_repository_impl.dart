import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/company/dashboard/data/datasources/create_competition_service.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/finalis.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';
import 'package:trajectoria/service_locator.dart';

class CreateCompetitionRepositoryImpl extends CreateCompetitionRepository {
  @override
  Future<Either> createCompetition(CompetitionEntity newCompetition) async {
    return await sl<CreateCompetitionService>().createCompetition(
      CompetitionModel.fromEntity(newCompetition),
    );
  }

  @override
  Future<Either> draftCompetition(CompetitionEntity newCompetition) async {
    return await sl<CreateCompetitionService>().draftCompetition(
      CompetitionModel.fromEntity(newCompetition),
    );
  }

  @override
  Future<Either> getDraftCompetitions() async {
    var drafts = await sl<CreateCompetitionService>().getDraftCompetitions();
    return drafts.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => CompetitionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getCompetitions() async {
    var competitions = await sl<CreateCompetitionService>().getCompetitions();
    return competitions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => CompetitionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> deleteCompetitionById(String competitionId) async {
    var competitions = await sl<CreateCompetitionService>()
        .deleteCompetitionById(competitionId);
    return competitions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either> getCompetitionById(String competitionId) async {
    var competitions = await sl<CreateCompetitionService>().getCompetitionById(
      competitionId,
    );
    return competitions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(CompetitionModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> getCompetitionsByTitle(String keyword) async {
    var competitions = await sl<CreateCompetitionService>()
        .getCompetitionsByTitle(keyword);
    return competitions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => CompetitionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getJobseekerSubmissions(String competitionId) async {
    var submissions = await sl<CreateCompetitionService>()
        .getJobseekerSubmissions(competitionId);
    return submissions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => SubmissionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> analyzeSubmission({
    required String submissionId,
    required String problemStatement,
    required List<String> fileUrls,
  }) async {
    var analyzedStatus = await sl<CreateCompetitionService>().analyzeSubmission(
      problemStatement: problemStatement,
      submissionId: submissionId,
      fileUrls: fileUrls,
    );
    return analyzedStatus.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
        // return Right(InsightAIModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> getUserInfo(String submissionId) async {
    var userInfo = await sl<CreateCompetitionService>().getUserInfo(
      submissionId,
    );
    return userInfo.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(JobSeekerModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> scoring(
    int totalScore,
    String feedback,
    String submissionId,
  ) async {
    var userInfo = await sl<CreateCompetitionService>().scoring(
      totalScore,
      feedback,
      submissionId,
    );
    return userInfo.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either> addToFinalis(
    SubmissionEntity finalis,
    String name,
    String imageUrl,
  ) async {
    var userInfo = await sl<CreateCompetitionService>().addToFinalis(
      finalis.toModel(),
      name,
      imageUrl,
    );
    return userInfo.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either> getFinalis(String competitionId) async {
    var competitions = await sl<CreateCompetitionService>().getFinalis(
      competitionId,
    );
    return competitions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => FinalisModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> deleteFinalis(String finalisId) async {
    var competitions = await sl<CreateCompetitionService>().deleteFinalis(
      finalisId,
    );
    return competitions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either> getJobseekerSubmissionsIncrement(String competitionId) async {
    var submissions = await sl<CreateCompetitionService>()
        .getJobseekerSubmissionsIncrement(competitionId);
    return submissions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => SubmissionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getAcrossJobseekerSubmissions() async {
    var submissions = await sl<CreateCompetitionService>()
        .getAcrossJobseekerSubmissions();
    return submissions.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => SubmissionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }
}
