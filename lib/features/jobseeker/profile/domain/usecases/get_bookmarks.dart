import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/repositories/profile.dart';

class GetBookmarksUseCase {
  final ProfileRepository repository;

  GetBookmarksUseCase({required this.repository});
  Future<Either> call() async {
    //1. fetch userprofile yang sedang aktif
    final userprofileResult = await repository.getUserprofileInfo();

    return userprofileResult.fold(
      (userprofileFailure) => Future.value(Left(userprofileFailure)),
      (userprofileData) async {
        // list final competition yang akan di return
        List<CompetitionEntity> bookmarks = [];

        //convert menjadi jobseekerEntity
        final userprofileDataFinal = userprofileData as JobSeekerEntity;

        //ambil list bookmarksIds dari userprofile
        final userprofileBookmarksIds = userprofileDataFinal.bookmarks;

        // jika list bookmarksIds dari userprofile kosong
        if (userprofileBookmarksIds == []) {
          return Future.value(Right(bookmarks));
        }

        // 2. fetch competition dari masing2 bookmarksIds
        for (var bookmark in userprofileBookmarksIds) {
          final competitionResult = await repository.getCompetition(bookmark);

          competitionResult.fold(
            (competitionFailure) {
              return Future.value(Left(competitionFailure));
            },
            (competitionData) {
              bookmarks.add(competitionData);
              return;
            },
          );
        }

        return Right(bookmarks);
      },
    );
  }
}
