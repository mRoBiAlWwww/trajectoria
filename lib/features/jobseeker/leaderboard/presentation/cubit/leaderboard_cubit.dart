import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/domain/usecases/get_jobseeker_by_score.dart';
import 'package:trajectoria/service_locator.dart';

part 'leaderboard_state.dart';

class JobseekerLeaderboardCubit extends Cubit<JobseekerLeaderboardState> {
  JobseekerLeaderboardCubit() : super(JobseekerLeaderboardInitial());

  Future<void> getJobseekerByScore() async {
    debugPrint("Cubit dipanggil");
    emit(JobseekerLeaderboardLoading());
    var returnedData = await sl<GetJobseekerByScoreUseCase>().call();

    returnedData.fold(
      (error) {
        emit(JobseekerLeaderboardFailure(error));
      },
      (data) {
        debugPrint("Cubit pusing");
        emit(JobseekerLeaderboardLoaded(data));
      },
    );
  }
}
