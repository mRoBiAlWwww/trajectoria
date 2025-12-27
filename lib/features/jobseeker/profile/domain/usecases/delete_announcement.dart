import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/repositories/profile.dart';

class DeleteAnnouncementUseCase {
  final ProfileRepository repository;
  DeleteAnnouncementUseCase({required this.repository});

  Future<Either> call(String announcementId) async {
    return await repository.deleteAnnouncement(announcementId);
  }
}
