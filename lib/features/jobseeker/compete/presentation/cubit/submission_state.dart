import 'package:trajectoria/features/jobseeker/compete/domain/entities/file_items.dart';

abstract class SubmissionState {}

class SubmissionInitial extends SubmissionState {}

class SubmissionLoading extends SubmissionState {}

class SubmissionError extends SubmissionState {
  final String message;
  SubmissionError(this.message);
}

class SuccessDownload extends SubmissionState {
  String message;
  SuccessDownload(this.message);
}

class SuccessUpload extends SubmissionState {
  List<FileItemEntity> files;
  SuccessUpload(this.files);
}

class DoneSubmited extends SubmissionState {
  DoneSubmited();
}

class OnprogressSubmited extends SubmissionState {
  String competitionParticipantId;
  OnprogressSubmited(this.competitionParticipantId);
}
