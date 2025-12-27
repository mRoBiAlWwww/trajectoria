import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class IsBookmarkedUseCase {
  final CompetitionRepository repository;
  IsBookmarkedUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    //1. fetch userprofile yang sedang aktif
    final userprofileResult = await repository.getUserprofileInfo();

    return userprofileResult.fold(
      (userprofileFailure) {
        return Left(userprofileFailure);
      },
      (userprofileData) async {
        // convert menjadi jobseekerEntity
        final userprofileDataFinal = userprofileData as JobSeekerEntity;
        // cek di masing bookmarks di userprofile
        final isExists = userprofileDataFinal.bookmarks.contains(competitionId);
        return Right(isExists);
      },
    );
  }
}
