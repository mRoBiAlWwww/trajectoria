import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/repositories/profile.dart';

class MarksasDoneUseCase {
  final ProfileRepository repository;
  MarksasDoneUseCase({required this.repository});

  Future<Either> call(String announcementId) async {
    return await repository.marksasDone(announcementId);
  }
}
