import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission_req.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/add_competition_participant.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/add_submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/download_file.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/is_already_submit.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/upload_file.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_state.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';

class SubmissionCubit extends Cubit<SubmissionState> {
  SubmissionCubit() : super(SubmissionInitial());

  Future<void> addCompetitionParticipant(String compId) async {
    emit(SubmissionLoading());
    var returnedData = await sl<AddCompetitionParticipantUseCase>().call(
      compId,
    );

    returnedData.fold(
      (error) {
        emit(SubmissionError(error));
      },
      (competitionParticipantId) {
        emit(OnprogresSubmited(competitionParticipantId));
      },
    );
  }

  Future<void> downloadAndOpenFile(String fileUrl, String fileName) async {
    emit(SubmissionLoading());
    var returnedData = await sl<DownloadFileUseCase>().call(fileUrl, fileName);
    returnedData.fold(
      (error) {
        emit(SubmissionError(error));
      },
      (data) {
        emit(SuccessDownload(data.toString()));
      },
    );
  }

  Future<void> uploadFilesSubmissions() async {
    emit(SubmissionLoading());
    var returnedData = await sl<UpploadFileUseCase>().call();
    returnedData.fold(
      (error) {
        emit(SubmissionError(error));
      },
      (data) {
        emit(SuccessUpload(data));
      },
    );
  }

  Future<void> addSubmission(SubmissionReq submission) async {
    emit(SubmissionLoading());
    var returnedData = await sl<AddSubmissionUseCase>().call(submission);
    returnedData.fold(
      (error) {
        debugPrint("A");
        emit(SubmissionError(error));
      },
      (data) {
        debugPrint("B");
        emit(DoneSubmited());
      },
    );
  }

  Future<void> isAlreadySubmitted(String competitionId) async {
    emit(SubmissionLoading());
    var returnedData = await sl<IsAlreadySubmitedUseCase>().call(competitionId);
    returnedData.fold(
      (error) {
        return emit(SubmissionError(error));
      },
      (data) {
        data == "notparticipation"
            ? emit(SubmissionInitial())
            : data == "done"
            ? emit(DoneSubmited())
            : emit(OnprogresSubmited(data));
      },
    );
  }

  void reset() {
    emit(SubmissionInitial());
  }
}
