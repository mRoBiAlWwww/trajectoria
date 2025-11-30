import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/data/datasources/leaderboard_services.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/domain/repositories/leaderboard.dart';

class LeaderboardRepositoryImpl extends LeaderboardRepository {
  final LeaderboardServices service;
  LeaderboardRepositoryImpl({required this.service});

  @override
  Future<Either> getUserByScore() async {
    try {
      final user = await service.getUserByScore();
      return Right(
        List.from(
          user,
        ).map((e) => JobSeekerModel.fromMap(e).toEntity()).toList(),
      );
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}
