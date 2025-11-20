import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission_req.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class AddSubmissionUseCase {
  final CompetitionRepository repository;
  AddSubmissionUseCase({required this.repository});

  Future<Either> call(SubmissionReq submission) async {
    return await repository.addSubmission(submission);
  }
}
