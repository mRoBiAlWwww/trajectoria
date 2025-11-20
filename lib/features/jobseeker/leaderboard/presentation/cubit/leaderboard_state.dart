part of 'leaderboard_cubit.dart';

abstract class JobseekerLeaderboardState {
  const JobseekerLeaderboardState();
}

class JobseekerLeaderboardInitial extends JobseekerLeaderboardState {}

class JobseekerLeaderboardLoading extends JobseekerLeaderboardState {}

class JobseekerLeaderboardLoaded extends JobseekerLeaderboardState {
  final List<JobSeekerEntity> data;
  JobseekerLeaderboardLoaded(this.data);
}

class JobseekerLeaderboardFailure extends JobseekerLeaderboardState {
  final String message;
  JobseekerLeaderboardFailure(this.message);
}
