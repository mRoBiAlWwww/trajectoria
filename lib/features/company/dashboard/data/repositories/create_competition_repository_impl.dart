import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/company/dashboard/data/datasources/create_competition_service.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/finalis.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

class CreateCompetitionRepositoryImpl extends CreateCompetitionRepository {
  final CreateCompetitionService service;
  CreateCompetitionRepositoryImpl({required this.service});

  @override
  Future<Either> createCompetition(CompetitionEntity newCompetition) async {
    try {
      final result = await service.createCompetition(
        CompetitionModel.fromEntity(newCompetition),
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> draftCompetition(CompetitionEntity newCompetition) async {
    try {
      final result = await service.draftCompetition(
        CompetitionModel.fromEntity(newCompetition),
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getDraftCompetitions() async {
    try {
      final result = await service.getDraftCompetitions();
      return Right(
        List.from(
          result,
        ).map((e) => CompetitionModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCompetitions() async {
    try {
      final result = await service.getCompetitions();
      return Right(
        List.from(
          result,
        ).map((e) => CompetitionModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> deleteCompetitionById(String competitionId) async {
    try {
      final result = await service.deleteCompetitionById(competitionId);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCompetitionById(String competitionId) async {
    try {
      final result = await service.getCompetitionById(competitionId);
      return Right(CompetitionModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCompetitionsByTitle(String keyword) async {
    try {
      final result = await service.getCompetitionsByTitle(keyword);
      return Right(
        List.from(
          result,
        ).map((e) => CompetitionModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getJobseekerSubmissions(String competitionId) async {
    try {
      final result = await service.getJobseekerSubmissions(competitionId);
      return Right(
        List.from(
          result,
        ).map((e) => SubmissionModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> analyzeSubmission({
    required String submissionId,
    required String problemStatement,
    required List<String> fileUrls,
  }) async {
    try {
      final result = await service.analyzeSubmission(
        problemStatement: problemStatement,
        submissionId: submissionId,
        fileUrls: fileUrls,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getUserInfo(String submissionId) async {
    try {
      final result = await service.getUserInfo(submissionId);
      return Right(JobSeekerModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> scoring(
    int totalScore,
    String feedback,
    String submissionId,
  ) async {
    try {
      final result = await service.scoring(totalScore, feedback, submissionId);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> addToFinalis(
    SubmissionEntity finalis,
    String name,
    String imageUrl,
  ) async {
    try {
      final result = await service.addToFinalis(
        finalis.toModel(),
        name,
        imageUrl,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getFinalis(String competitionId) async {
    try {
      final result = await service.getFinalis(competitionId);
      return Right(
        List.from(
          result,
        ).map((e) => FinalisModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> deleteFinalis(String finalisId) async {
    try {
      final result = await service.deleteFinalis(finalisId);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getJobseekerSubmissionsIncrement(String competitionId) async {
    try {
      final result = await service.getJobseekerSubmissionsIncrement(
        competitionId,
      );
      return Right(
        List.from(
          result,
        ).map((e) => SubmissionModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getAcrossJobseekerSubmissions() async {
    try {
      final result = await service.getAcrossJobseekerSubmissions();
      return Right(
        List.from(
          result,
        ).map((e) => SubmissionModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}
