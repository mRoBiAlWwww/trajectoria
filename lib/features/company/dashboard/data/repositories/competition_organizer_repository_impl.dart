import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/company.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/company/dashboard/data/datasources/competition_organizer_service.dart';
import 'package:trajectoria/features/company/dashboard/data/models/announcement.dart';
import 'package:trajectoria/features/company/dashboard/domain/entities/announcement.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competition_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

class CompetitionOrganizerRepositoryImpl
    extends CompetitionOrganizerRepository {
  final CompetitionOrganizerService service;
  CompetitionOrganizerRepositoryImpl({required this.service});

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
  Future<Either> getCompetitionsByCurrentCompany() async {
    try {
      final result = await service.getCompetitionsByCurrentCompany();
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
  Future<Either> deleteCompetitionParticipantsByCompetitionId(
    String competitionId,
  ) async {
    try {
      final result = await service.deleteCompetitionParticipantsByCompetitionId(
        competitionId,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> deleteSubmissionsByCompetitionId(String competitionId) async {
    try {
      final result = await service.deleteSubmissionsByCompetitionId(
        competitionId,
      );
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
  Future<Either> getJobseekerSubmissions(
    String competitionId,
    String show,
  ) async {
    try {
      final result = await service.getJobseekerSubmissions(competitionId, show);
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
  Future<Either> finalAssessment(
    int totalScore,
    String feedback,
    String submissionId,
    AnnouncementEntity announcement,
  ) async {
    try {
      final result = await service.finalAssessment(
        totalScore,
        feedback,
        submissionId,
        AnnouncementModel.fromEntity(announcement),
      );
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
        ).map((e) => SubmissionModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> deleteFinalis(String submissionId) async {
    try {
      final result = await service.deleteFinalis(submissionId);
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

  @override
  Future<Either> getSubmissionById(String submissionId) async {
    try {
      final result = await service.getSubmissionById(submissionId);
      return Right(SubmissionModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCompetitionParticipants(
    String competitionParticipantId,
  ) async {
    try {
      final result = await service.getCompetitionParticipants(
        competitionParticipantId,
      );
      return Right(CompetitionParticipantsModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getUserInformationById(String userId) async {
    try {
      final result = await service.getUserInformationById(userId);
      return Right(JobSeekerModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCurrentCompanyInformation() async {
    try {
      final result = await service.getCurrentCompanyInformation();
      return Right(CompanyModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getJobseekerByName(String jobsName) async {
    try {
      final result = await service.getJobseekerByName(jobsName);
      return Right(
        List.from(
          result,
        ).map((e) => JobSeekerModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCompetitionParticipantsByUserId(String userId) async {
    try {
      final result = await service.getCompetitionParticipantsByUserId(userId);
      return Right(
        List.from(result)
            .map((e) => CompetitionParticipantsModel.fromMap(e).toEntity())
            .toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getJobseekerSubmissionsByPartisipantId(
    String partisipanId,
  ) async {
    try {
      final result = await service.getJobseekerSubmissionsByPartisipantId(
        partisipanId,
      );

      if (result == null) return Right(null);
      return Right(SubmissionModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}
