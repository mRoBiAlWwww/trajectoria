import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/data/datasources/competition_services.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/category.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission_req.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

import 'package:trajectoria/service_locator.dart';

class CompetitionRepositoryImpl extends CompetitionRepository {
  @override
  Future<Either> getCompetitions() async {
    var competitions = await sl<CompetitionService>().getCompetitions();
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
  Future<Either> getSingleCompetition(String competitionId) async {
    var competition = await sl<CompetitionService>().getSingleCompetition(
      competitionId,
    );
    return competition.fold(
      (error) {
        return Left(error);
      },
      (data) {
        if (data == null) {
          return Left("Data kompetisi tidak ditemukan");
        }
        return Right(CompetitionModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> addCompetitionParticipant(String compId) async {
    return await sl<CompetitionService>().addCompetitionParticipant(compId);
  }

  @override
  Future<Either> downloadAndOpenFile(String fileUrl, String fileName) async {
    return await sl<CompetitionService>().downloadAndOpenFile(
      fileUrl,
      fileName,
    );
  }

  @override
  Future<Either> uploadMultiplePdfs() async {
    var detailFile = await sl<CompetitionService>().uploadMultiplePdfs();
    return detailFile.fold(
      (error) {
        return Left(error);
      },
      (data) {
        final list = (data as List).cast<FileItemModel>();
        final entities = list.map((m) => m.toEntity()).toList();
        return Right(entities);
      },
    );
  }

  @override
  Future<Either> addSubmission(SubmissionReq submission) async {
    return await sl<CompetitionService>().addSubmission(submission);
  }

  @override
  Future<Either> getCompetitionsByTitle(String keyword) async {
    var competitions = await sl<CompetitionService>().getCompetitionsByTitle(
      keyword,
    );
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
  Future<Either> getCategories() async {
    var categories = await sl<CompetitionService>().getCategories();
    return categories.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => CategoryModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getCompetitionsByCategory(String categoryId) async {
    var competitions = await sl<CompetitionService>().getCompetitionsByCategory(
      categoryId,
    );
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
  Future<Either> getCompetitionsByFilters(
    List<String> category,
    String deadline,
  ) async {
    var competitions = await sl<CompetitionService>().getCompetitionsByFilters(
      category,
      deadline,
    );
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
  Future<Either> isAlreadySubmitted(String competitionId) async {
    var isAlreadySubmitted = await sl<CompetitionService>().isAlreadySubmitted(
      competitionId,
    );
    return isAlreadySubmitted.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
}
