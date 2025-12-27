import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either> getCompetitionParticipants();
  Future<Either> getCompetition(String competitionId);
  Future<Either> getAnnouncementsByUserId();
  Future<Either> deleteAnnouncement(String announcementId);
  Future<Either> getUserprofileInfo();
  Future<Either> marksasDone(String announcementId);
}
