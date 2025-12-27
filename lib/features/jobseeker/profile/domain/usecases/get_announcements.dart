import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/repositories/profile.dart';

class GetAnnouncementsUseCase {
  final ProfileRepository repository;
  GetAnnouncementsUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getAnnouncementsByUserId();
  }
}
