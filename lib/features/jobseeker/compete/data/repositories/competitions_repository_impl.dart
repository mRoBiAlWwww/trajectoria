import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/jobseeker/compete/data/datasources/competition_services.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/category.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competition_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission_req.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class CompetitionRepositoryImpl extends CompetitionRepository {
  final CompetitionService service;
  CompetitionRepositoryImpl({required this.service});

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
  Future<Either> getSingleCompetition(String competitionId) async {
    try {
      final result = await service.getSingleCompetition(competitionId);
      return Right(CompetitionModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> addCompetitionParticipant(String compId) async {
    try {
      final result = await service.addCompetitionParticipant(compId);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> downloadAndOpenFile(String fileUrl, String fileName) async {
    try {
      final result = await service.downloadAndOpenFile(fileUrl, fileName);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> uploadMultiplePdfs() async {
    try {
      final detailFiles = await service.uploadMultiplePdfs();
      return Right(detailFiles.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addSubmission(SubmissionReq submission) async {
    try {
      final result = await service.addSubmission(submission);
      return Right(result);
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
  Future<Either> getCategories() async {
    try {
      final result = await service.getCategories();
      return Right(
        List.from(
          result,
        ).map((e) => CategoryModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCompetitionsByCategory(String categoryId) async {
    try {
      final result = await service.getCompetitionsByCategory(categoryId);
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
  Future<Either> getCompetitionsByFilters(
    List<String> category,
    String deadline,
  ) async {
    try {
      final result = await service.getCompetitionsByFilters(category, deadline);
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
  Future<Either> isAlreadySubmitted(String competitionId) async {
    try {
      final result = await service.isAlreadySubmitted(competitionId);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCompetitionParticipants(String competitionId) async {
    try {
      final result = await service.getCompetitionParticipants(competitionId);

      if (result == null) return Right(null);

      return Right(CompetitionParticipantsModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getSubmissionByCompetitionParticipantId(
    String competitionParticipantId,
  ) async {
    try {
      final result = await service.getSubmissionByCompetitionParticipantId(
        competitionParticipantId,
      );

      if (result == null) return Right(null);

      return Right(SubmissionModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getTotalCompetitionParticipants(String competitionId) async {
    try {
      final result = await service.getTotalCompetitionParticipants(
        competitionId,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> addBookmark(String competitionId) async {
    try {
      final result = await service.addBookmark(competitionId);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> deleteBookmark(String competitionId) async {
    try {
      final result = await service.deleteBookmark(competitionId);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getUserprofileInfo() async {
    try {
      final result = await service.getUserprofileInfo();
      return Right(JobSeekerModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}
