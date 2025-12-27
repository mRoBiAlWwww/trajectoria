import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_jobseeker_across_submissions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_jobseeker_submissions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_jobseeker_submissions_increment.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_submission_by_username.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/jobseeker_submission_state.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';

class JobseekerSubmissionCubit extends Cubit<JobseekerSubmissionState> {
  JobseekerSubmissionCubit() : super(JobseekerSubmissionInitial());

  Future<void> getJobseekerSubmissions(
    String competitionId,
    String show,
  ) async {
    emit(JobseekerSubmissionLoading());
    final result = await sl<GetJobseekerSubmissionsUseCase>().call(
      competitionId,
      show,
    );
    result.fold(
      (failure) {
        emit(JobseekerSubmissionFailure(message: failure.toString()));
      },
      (data) {
        emit(JobseekerSubmissionsCompetitionLoaded(data: data));
      },
    );
  }

  Future<void> getJobseekerSubmissionsByJobsName(
    String jobsName,
    String competitionId,
  ) async {
    emit(JobseekerSubmissionLoading());
    final result = await sl<GetSubmissionByUsernameUseCase>().call(
      jobsName,
      competitionId,
    );
    result.fold(
      (failure) {
        emit(JobseekerSubmissionFailure(message: failure.toString()));
      },
      (data) {
        emit(JobseekerSubmissionsCompetitionLoaded(data: data));
      },
    );
  }

  Future<void> getJobseekerSubmissionsIncrement(String competitionId) async {
    emit(JobseekerSubmissionLoading());
    final result = await sl<GetJobseekerSubmissionsIncrementUseCase>().call(
      competitionId,
    );
    result.fold(
      (failure) {
        emit(JobseekerSubmissionFailure(message: failure.toString()));
      },
      (data) {
        emit(JobseekerSubmissionsCompetitionLoaded(data: data));
      },
    );
  }

  Future<void> getJobseekerAcrossSubmissions() async {
    emit(JobseekerSubmissionLoading());
    final result = await sl<GetJobseekerAcrossSubmissionsUseCase>().call();
    result.fold(
      (failure) {
        emit(JobseekerSubmissionFailure(message: failure.toString()));
      },
      (data) {
        emit(JobseekerSubmissionsCompetitionLoaded(data: data));
      },
    );
  }
}
