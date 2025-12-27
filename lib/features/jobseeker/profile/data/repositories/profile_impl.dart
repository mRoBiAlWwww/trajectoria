import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/company/dashboard/data/models/announcement.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competition_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/competitions.dart';
import 'package:trajectoria/features/jobseeker/profile/data/datasources/profile_service.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/repositories/profile.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileService service;
  ProfileRepositoryImpl({required this.service});

  @override
  Future<Either> getCompetitionParticipants() async {
    try {
      final result = await service.getCompetitionParticipants();
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
  Future<Either> getCompetition(String competitionId) async {
    try {
      final result = await service.getCompetition(competitionId);
      return Right(CompetitionModel.fromMap(result).toEntity());
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getAnnouncementsByUserId() async {
    try {
      final result = await service.getAnnouncementsByUserId();
      return Right(
        List.from(
          result,
        ).map((e) => AnnouncementModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> deleteAnnouncement(String announcementId) async {
    try {
      final result = await service.deleteAnnouncement(announcementId);
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

  @override
  Future<Either> marksasDone(String announcementId) async {
    try {
      final result = await service.marksasDone(announcementId);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}
