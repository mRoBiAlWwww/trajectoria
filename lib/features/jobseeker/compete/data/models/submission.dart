import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/insightAI.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

class SubmissionModel {
  final String submissionId;
  final String competitionParticipantId;
  final String competitionId;
  final String problemStatement;
  final Timestamp submittedAt;
  final String answerText;
  final List<FileItemModel> answerFiles;
  final InsightAIModel aiAnalyzed;
  final String feedback;
  final double score;
  final int rank;
  final bool isChecked;

  SubmissionModel({
    required this.submissionId,
    required this.competitionParticipantId,
    required this.competitionId,
    required this.problemStatement,
    required this.submittedAt,
    required this.answerText,
    required this.answerFiles,
    required this.aiAnalyzed,
    required this.feedback,
    required this.score,
    required this.rank,
    required this.isChecked,
  });

  Map<String, dynamic> toMap() {
    return {
      'submissions_id': submissionId,
      'competition_participants_id': competitionParticipantId,
      'competition_id': competitionId,
      'problem_statement': problemStatement,
      'submitted_at': submittedAt,
      'answer_text': answerText,
      'answer_file_url': answerFiles.map((x) => x.toMap()).toList(),
      'ai_analyzed': aiAnalyzed.toMap(),
      'feedback': feedback,
      'score': score,
      'rank': rank,
      'isChecked': isChecked,
    };
  }

  factory SubmissionModel.fromMap(Map<String, dynamic> map) {
    return SubmissionModel(
      submissionId: map['submissions_id'] ?? '',
      competitionParticipantId: map['competition_participant_id'] ?? '',
      competitionId: map['competition_id'] ?? '',
      problemStatement: map['problem_statement'] ?? '',
      submittedAt: map['submitted_at'] as Timestamp,
      answerText: map['answer_text'] ?? '',
      answerFiles: map['answer_file_url'] != null
          ? List<FileItemModel>.from(
              (map['answer_file_url'] as List).map(
                (e) => FileItemModel.fromMap(e),
              ),
            )
          : [],
      aiAnalyzed: map['ai_analyzed'] is Map<String, dynamic>
          ? InsightAIModel.fromMap(map['ai_analyzed'])
          : InsightAIModel(commonPattern: [], summary: []),
      feedback: map['feedback'] ?? '',
      score: (map['score'] is int)
          ? (map['score'] as int).toDouble()
          : (map['score'] ?? 0.0),
      rank: map['rank'] ?? 0,
      isChecked: map['isChecked'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubmissionModel.fromJson(String source) =>
      SubmissionModel.fromMap(json.decode(source));

  /// Konversi ke entity
  SubmissionEntity toEntity() {
    return SubmissionEntity(
      submissionId: submissionId,
      competitionParticipantId: competitionParticipantId,
      competitionId: competitionId,
      problemStatement: problemStatement,
      submittedAt: submittedAt,
      answerText: answerText,
      answerFiles: answerFiles.map((e) => e.toEntity()).toList(),
      aiAnalyzed: aiAnalyzed.toEntity(),
      feedback: feedback,
      score: score,
      rank: rank,
      isChecked: isChecked,
    );
  }

  /// Buat dari entity
  factory SubmissionModel.fromEntity(SubmissionEntity entity) {
    return SubmissionModel(
      submissionId: entity.submissionId,
      competitionParticipantId: entity.competitionParticipantId,
      competitionId: entity.competitionId,
      problemStatement: entity.problemStatement,
      submittedAt: entity.submittedAt,
      answerText: entity.answerText,
      answerFiles: entity.answerFiles
          .map((e) => FileItemModel.fromEntity(e))
          .toList(),
      aiAnalyzed: InsightAIModel.fromEntity(entity.aiAnalyzed),
      feedback: entity.feedback,
      score: entity.score,
      rank: entity.rank,
      isChecked: entity.isChecked,
    );
  }
}
