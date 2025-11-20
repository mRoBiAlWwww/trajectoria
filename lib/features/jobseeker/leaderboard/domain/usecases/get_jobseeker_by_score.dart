import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/domain/repositories/leaderboard.dart';

class GetJobseekerByScoreUseCase {
  final LeaderboardRepository repository;
  GetJobseekerByScoreUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getUserByScore();
  }
}
