import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competition_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class GetSubmissionParticipantUseCase {
  final CompetitionRepository repository;

  GetSubmissionParticipantUseCase({required this.repository});

  Future<Either> call(String competitiondId) async {
    // 1. fetch competition participant by competition id
    final participantResult = await repository.getCompetitionParticipants(
      competitiondId,
    );

    return participantResult.fold(
      (participantFailure) => Future.value(Left(participantFailure)),
      (participantsData) async {
        //jika user belum join kompetisi tersebut
        if (participantsData == null) {
          return Future.value(Right(null));
        }

        //convert menjadi CompetitionParticipantsEntity
        final participantsDataFinal =
            participantsData as CompetitionParticipantsEntity;

        // 2. fetch submission by competition participants id
        final submissionResult = await repository
            .getSubmissionByCompetitionParticipantId(
              participantsDataFinal.competitionParticipantId,
            );
        return submissionResult.fold(
          (failure) => Future.value(Left(failure)),
          (submission) => Right(submission),
        );
      },
    );
  }
}
