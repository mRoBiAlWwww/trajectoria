import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competition_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

class GetSubmissionByUsernameUseCase {
  final CompetitionOrganizerRepository repository;

  GetSubmissionByUsernameUseCase({required this.repository});

  Future<Either> call(String jobsName, String competitionId) async {
    // 1. fetch jobseeker by name
    final usernameResults = await repository.getJobseekerByName(jobsName);

    return usernameResults.fold(
      (usernameFailure) => Future.value(Left(usernameFailure)),
      (usernamesData) async {
        // list final submission yang akan di return
        List<SubmissionEntity> userSubmissionList = [];

        // jika tidak menemukan nama yg cocok di db
        if (usernamesData == []) {
          return Future.value(Right(userSubmissionList));
        }

        // convert menjadi list jobseekerentity
        final usernamesDataFinal = usernamesData as List<JobSeekerEntity>;

        // 2. fetch competition participants by masing2 user id
        for (var user in usernamesDataFinal) {
          final partisipantResult = await repository
              .getCompetitionParticipantsByUserId(user.userId);

          await partisipantResult.fold(
            (partisipantFailure) {
              return Future.value(Left(partisipantFailure));
            },
            (partisipantData) async {
              // jika user belum menjadi partisipan kompetisi apapun
              if (partisipantData == []) {
                return Future.value(Right(userSubmissionList));
              }

              // convert menjadi list CompetitionParticipantsEntity
              final partisipantDataFinal =
                  partisipantData as List<CompetitionParticipantsEntity>;

              // 3. fetch submission by masing2 competition partisipant id
              for (var partisipant in partisipantDataFinal) {
                final submissionResult = await repository
                    .getJobseekerSubmissionsByPartisipantId(
                      partisipant.competitionParticipantId,
                    );

                submissionResult.fold(
                  (submissionFailure) {
                    return Future.value(Left(submissionFailure));
                  },
                  (submissionData) {
                    // jika partisipan belum submit
                    if (submissionData == null) {
                      return;
                    }

                    // convert menjadi SubmissionEntity
                    final submissionDataFinal =
                        submissionData as SubmissionEntity;

                    //cek apakah benar submission dari competitionId yg dicari?
                    if (submissionDataFinal.competitionId == competitionId) {
                      userSubmissionList.add(submissionDataFinal);
                    }
                  },
                );
              }
            },
          );
        }
        return Right(userSubmissionList);
      },
    );
  }
}

// class GetSubmissionByUsernameUseCase {
//   final CompetitionOrganizerRepository repository;
//   GetSubmissionByUsernameUseCase({required this.repository});
//   Future<Either> call(String jobsName) async {
//     // 1. fetch jobseeker by name
//     final usernameResults = await repository.getJobseekerByName(jobsName);
//     return usernameResults.fold(
//       (usernameFailure) => Future.value(Left(usernameFailure)),
//       (usernamesData) async {
//         // list final submission yang akan di return
//         List<SubmissionEntity> userSubmissionList = [];
//         // jika tidak menemukan nama yg cocok di db
//         if (usernamesData == []) {
//           return Future.value(Right(userSubmissionList));
//         }
//         // convert menjadi list jobseekerentity
//         final usernamesDataFinal = usernamesData as List<JobSeekerEntity>;
//         // 2. fetch competition participants by masing2 user id
//         for (var user in usernamesDataFinal) {
//           final partisipantResult = await repository
//               .getCompetitionParticipantsByUserId(user.userId);
//           await partisipantResult.fold(
//             (partisipantFailure) {
//               return Future.value(Left(partisipantFailure));
//             },
//             (partisipantData) async {
//               // jika user belum menjadi partisipan kompetisi apapun
//               if (partisipantData == null) {
//                 return;
//               }
//               // convert menjadi CompetitionParticipantsEntity
//               final partisipantDataFinal =
//                   partisipantData as CompetitionParticipantsEntity;
//               // 3. fetch submission by competition partisipant id
//               final submissionResult = await repository
//                   .getJobseekerSubmissionsByPartisipantId(
//                     partisipantDataFinal.competitionParticipantId,
//                   );
//               submissionResult.fold(
//                 (submissionFailure) {
//                   return Future.value(Left(submissionFailure));
//                 },
//                 (submissionData) {
//                   // jika partisipan belum submit
//                   if (submissionData == null) {
//                     return;
//                   }
//                   // convert menjadi SubmissionEntity
//                   final submissionDataFinal =
//                       submissionData as SubmissionEntity;
//                   userSubmissionList.add(submissionDataFinal);
//                 },
//               );
//             },
//           );
//         }
//         return Right(userSubmissionList);
//       },
//     );
//   }
// }
