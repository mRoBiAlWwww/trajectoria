import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competition_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

class GetUserInformationUseCase {
  final CompetitionOrganizerRepository repository;
  GetUserInformationUseCase({required this.repository});

  Future<Either> call(String submissionId) async {
    final submissionResult = await repository.getSubmissionById(submissionId);

    //Fold getSubmissionById
    return submissionResult.fold(
      (submissionFailure) => Future.value(Left(submissionFailure)),
      (submissionData) async {
        final submissionDataFinal = submissionData as SubmissionEntity;
        final participantResult = await repository.getCompetitionParticipants(
          submissionDataFinal.competitionParticipantId,
        );

        //Fold getCompetitionParticipants
        return participantResult.fold(
          (participantFailure) => Future.value(Left(participantFailure)),
          (participantData) async {
            final participantDataFinal =
                participantData as CompetitionParticipantsEntity;
            final jobseekerResult = await repository.getUserInformationById(
              participantDataFinal.userId,
            );

            //Fold getUserInformationById
            return jobseekerResult.fold(
              (jobseekerFailure) => Future.value(Left(jobseekerFailure)),
              (jobseekerData) => Right(jobseekerData),
            );
          },
        );
      },
    );
  }
}
