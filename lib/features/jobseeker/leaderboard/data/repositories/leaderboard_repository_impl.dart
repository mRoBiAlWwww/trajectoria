import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/data/datasources/leaderboard_services.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/domain/repositories/leaderboard.dart';
import 'package:trajectoria/service_locator.dart';

class LeaderboardRepositoryImpl extends LeaderboardRepository {
  @override
  Future<Either> getUserByScore() async {
    var jobseeker = await sl<LeaderboardServices>().getUserByScore();
    return jobseeker.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => JobSeekerModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }
}
