import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/insightAI.dart';

class SubmissionEntity {
  final String submissionId;
  final String competitionParticipantId;
  final String competitionId;
  final String problemStatement;
  final Timestamp submittedAt;
  final String answerText;
  final List<FileItemEntity> answerFiles;
  final InsightAIEntity aiAnalyzed;
  final String feedback;
  final double score;
  final int rank;
  final bool isChecked;
  final bool isFinalist;

  SubmissionEntity({
    required this.submissionId,
    required this.competitionParticipantId,
    required this.competitionId,
    required this.submittedAt,
    required this.problemStatement,
    required this.answerText,
    required this.answerFiles,
    required this.aiAnalyzed,
    required this.feedback,
    required this.score,
    required this.rank,
    required this.isChecked,
    required this.isFinalist,
  });

  SubmissionEntity copyWith({
    String? submissionId,
    String? competitionParticipantId,
    String? competitionId,
    String? problemStatement,
    Timestamp? submittedAt,
    String? answerText,
    List<FileItemEntity>? answerFiles,
    InsightAIEntity? aiAnalyzed,
    String? feedback,
    double? score,
    int? rank,
    bool? isChecked,
    bool? isFinalist,
  }) {
    return SubmissionEntity(
      submissionId: submissionId ?? this.submissionId,
      competitionParticipantId:
          competitionParticipantId ?? this.competitionParticipantId,
      competitionId: competitionId ?? this.competitionId,
      problemStatement: problemStatement ?? this.problemStatement,
      submittedAt: submittedAt ?? this.submittedAt,
      answerText: answerText ?? this.answerText,
      answerFiles: answerFiles ?? this.answerFiles,
      aiAnalyzed: aiAnalyzed ?? this.aiAnalyzed,
      feedback: feedback ?? this.feedback,
      score: score ?? this.score,
      rank: rank ?? this.rank,
      isChecked: isChecked ?? this.isChecked,
      isFinalist: isFinalist ?? this.isFinalist,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'submissions_id': submissionId,
      'competition_participants_id': competitionParticipantId,
      'competition_id': competitionId,
      'problem_statement': problemStatement,
      'submitted_at': submittedAt,
      'answer_text': answerText,
      'answer_file_url': answerFiles.map((e) => e.toMap()).toList(),
      'ai_analyzed': aiAnalyzed.toMap(),
      'feedback': feedback,
      'score': score,
      'rank': rank,
      'is_checked': isChecked,
      'is_finalist': isFinalist,
    };
  }

  factory SubmissionEntity.fromMap(Map<String, dynamic> map) {
    return SubmissionEntity(
      submissionId: map['submissions_id'] ?? '',
      competitionParticipantId: map['competition_participants_id'] ?? '',
      competitionId: map['competition_id'] ?? '',
      problemStatement: map['problem_statement'] ?? '',
      submittedAt: map['submitted_at'],
      answerText: map['answer_text'] ?? '',
      answerFiles: map['answer_file_url'] != null
          ? List<FileItemEntity>.from(
              (map['answer_file_url'] as List).map(
                (e) => FileItemEntity.fromMap(e),
              ),
            )
          : [],
      aiAnalyzed: map['ai_analyzed'] != null
          ? InsightAIEntity.fromMap(map['ai_analyzed'])
          : InsightAIEntity(commonPattern: [], summary: []),
      feedback: map['feedback'] ?? '',
      score: (map['score'] is int)
          ? (map['score'] as int).toDouble()
          : (map['score'] ?? 0.0),
      rank: map['rank'] ?? 0,
      isChecked: map['is_checked'],
      isFinalist: map['is_finalist'],
    );
  }

  SubmissionModel toModel() {
    return SubmissionModel(
      submissionId: submissionId,
      competitionParticipantId: competitionParticipantId,
      competitionId: competitionId,
      problemStatement: problemStatement,
      submittedAt: submittedAt,
      answerText: answerText,
      answerFiles: answerFiles.map((e) => e.toModel()).toList(),
      aiAnalyzed: aiAnalyzed.toModel(),
      feedback: feedback,
      score: score,
      rank: rank,
      isChecked: isChecked,
      isFinalist: isFinalist,
    );
  }
}
