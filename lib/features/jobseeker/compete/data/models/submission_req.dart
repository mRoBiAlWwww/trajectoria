import 'package:trajectoria/features/jobseeker/compete/data/models/file_items.dart';

class SubmissionReq {
  final String competitionParticipantId;
  final String competitionId;
  final String answerText;
  final String problemStatement;
  final List<FileItemModel> answerFiles;

  SubmissionReq({
    required this.competitionParticipantId,
    required this.competitionId,
    required this.problemStatement,
    required this.answerText,
    required this.answerFiles,
  });
}
