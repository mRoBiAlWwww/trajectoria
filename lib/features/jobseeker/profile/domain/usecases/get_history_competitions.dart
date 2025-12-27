import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competition_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/repositories/profile.dart';

class GetHistoryCompetitionsUseCase {
  final ProfileRepository repository;

  GetHistoryCompetitionsUseCase({required this.repository});

  Future<Either> call() async {
    //1. fetch competition participants by current user
    final participantResult = await repository.getCompetitionParticipants();

    return participantResult.fold(
      (participantFailure) => Future.value(Left(participantFailure)),
      (participantsData) async {
        // list final competition yang akan di return
        List<CompetitionEntity> competitionHistory = [];

        // jika tidak menemukan competition participant dari current user
        if (participantsData == []) {
          return Future.value(Right(competitionHistory));
        }

        //convert menjadi list CompetitionParticipantsEntity
        final participantsList =
            participantsData as List<CompetitionParticipantsEntity>;

        // 2. fetch competition by masing2 competition partisipants
        for (var participant in participantsList) {
          final competitionResult = await repository.getCompetition(
            participant.competitionId,
          );

          competitionResult.fold(
            (competitionFailure) {
              return Future.value(Left(competitionFailure));
            },
            (successData) {
              competitionHistory.add(successData);
              return;
            },
          );
        }

        return Right(competitionHistory);
      },
    );
  }
}
