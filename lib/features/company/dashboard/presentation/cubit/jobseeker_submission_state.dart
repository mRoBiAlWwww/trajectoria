import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

abstract class JobseekerSubmissionState {}

class JobseekerSubmissionInitial extends JobseekerSubmissionState {}

class JobseekerSubmissionLoading extends JobseekerSubmissionState {}

class JobseekerSubmissionSuccess extends JobseekerSubmissionState {
  final String success;
  JobseekerSubmissionSuccess({required this.success});
}

class JobseekerSubmissionsCompetitionLoaded extends JobseekerSubmissionState {
  final List<SubmissionEntity> data;
  JobseekerSubmissionsCompetitionLoaded({required this.data});
}

class JobseekerSubmissionFailure extends JobseekerSubmissionState {
  final String message;
  JobseekerSubmissionFailure({required this.message});
}
